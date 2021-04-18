import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier{
  //not final because this will change
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    final url = Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAiZsg5XHs3yw7m3QeQmPOntv8Yljlp_Hc");
    print(url);
    final response = await http.post(url, body: json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true
    }));
  }

  Future<void> signup(String email, String password) async {
    //return is needed for CircularProgressScreen in auth_screen
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}