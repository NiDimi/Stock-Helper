import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  static const KEY = 'LOGINDATA';
  bool alreadySingedIn = false;//bool so we dont continue loggin the user again and again

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyC-49zz8wty5xRSnYWUek_ldmSIEXYXIsc'),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw Exception(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  void refreshLogin(String email, String password) {
    Future.delayed(_expiryDate.timeZoneOffset, () {
      login(email, password);
      refreshLogin(email, password);
    });
  }

  Future<void> signup(String email, String password) async {
    alreadySingedIn = true;
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
      KEY,
      json.encode({'email': email, 'password': password}),
    );
    alreadySingedIn = true;
    await _authenticate(email, password, 'signInWithPassword');
    refreshLogin(email, password);
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(KEY, '');
    notifyListeners();
  }

  Future<bool> quickSignIn() async {
    if(!alreadySingedIn) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userData = prefs.get(KEY);
      if (userData == null || userData == '') {
        return false;
      }
      var test = json.decode(userData);
      await login(test['email'], test['password']);
      alreadySingedIn = true;
      return true;
    }
  }
}
