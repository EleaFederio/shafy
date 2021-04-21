import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopy/models/http_exception.dart';

class Auth with ChangeNotifier{
  //not final because this will change
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

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
      _autoLogout();
      notifyListeners();

    //  save token to device
    //  needs to be async
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token' : _token,
        'userId' : _userId,
        'expiryDate' : _expiryDate.toIso8601String()
      });
      prefs.setString('userData', userData );
      print('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
      print(json.decode(prefs.getString('userData')));
      print('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
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

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    // json.decode() to convert userData(String) to map
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    print('*************************************************************************');
    print(expiryDate);
    print('*************************************************************************');
    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }

  //  initialize auth properties
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout(){
    _token = null;
    _userId = null;
    _expiryDate = null;
    if(_authTimer != null){
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void _autoLogout(){
    // if there is a existing timer cancel it, before setting a new one
    if(_authTimer != null){
      _authTimer.cancel();
    }
    // calculate/convert _expiryDate to seconds
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    // user will automatically logout when equal to expiry date
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}