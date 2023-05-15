import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expirDate;
  String? _userId;

  static const apiKey = 'AIzaSyD-1pUta039_feFIEJdUKRArt3tbTlc-WY';

  bool get isAuth {
    return _token != null;
  }

  String get userId {
    return _userId!;
  }

  String? get token {
    if (_expirDate != null &&
        _expirDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null; //token mavjud emas
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final data = jsonDecode(response.body);
      if (data['error'] != null) {
        throw HttpException(data['error']['message']);
      }
      _token = data['idToken'];
      _expirDate = DateTime.now().add(
        Duration(
          seconds: int.parse(data['expiresIn']),
        ),
      );
      _userId = data['localId'];
      notifyListeners();
      print(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
