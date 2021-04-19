import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shopy/models/http_exception.dart';

class Auth with ChangeNotifier{
  //not final because this will change
  String _token;
  DateTime _expiryDate;
  String _userId;

  // This will determine id the user is login or not
  // This method is called inside the main.dart to change the home parameter inside the MaterialApp in main.dart
  bool get isAuth{
    return token != null;
  }

  String get token{
    // check if token expiry date exist exist and token is > present time and token exist then return _token
    if (_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null){
      return _token;
    }else{
      return null;
    }
  }


  String get userId => _userId;

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    final url = Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAiZsg5XHs3yw7m3QeQmPOntv8Yljlp_Hc");
    try{
      final response = await http.post(url, body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true
      }));
      final responseData = json.decode(response.body);
      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message']);
      }
      // if signin success this variable will be initialized then this variable will be check if the user is signed in or not
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      notifyListeners();
    }catch(error){
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    //return is needed for CircularProgressScreen in auth_screen
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}