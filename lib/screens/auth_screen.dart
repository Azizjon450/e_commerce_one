import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/auth.dart';

enum AuthMode { Register, Login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static const routName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final _passwordController = TextEditingController();
  var _isLoading = false;
  Map<String, String> _authData = {
    "email": '',
    "password": '',
  };

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Xatolik"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text("Okey"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        if (_authMode == AuthMode.Login) {
          //....login user
          await Provider.of<Auth>(context, listen: false).login(
            _authData['email']!,
            _authData['password']!,
          );
        } else {
          await Provider.of<Auth>(context, listen: false).signUp(
            _authData['email']!,
            _authData['password']!,
          );
        }
      } on HttpException catch (error) {
        var errorMessage = 'Xatolik sodir bo\'ldi';
        if (error.message.contains('EMAIL_EXISTS')) {
          errorMessage = 'Bu email allaqachon ro\'yhatdan o\'tgan';
        } else if (error.message.contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Ushbu email topilmadi, yoki hisob o\'chirilgan.';
        } else if (error.message.contains('INVALID_PASSWORD')) {
          errorMessage = 'Parol noto\'g\'ri, iltimos qaytadan urinib ko\'ring';
        } else if (error.message.contains('INVALID_EMAIL')) {
          errorMessage = 'Email manzili noto\'g\'ri.';
        } else if (error.message.contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Email ro\'yxatdan o\'tmagan';
        } else if (error.message.contains('WEAK_PASSWORD')) {
          errorMessage =
              'Parol 6 yoki undan ortiq belgidan iborat bo\'lishi kerak.';
        } else if (error.message.contains('USER_NOT_FOUND')) {
          errorMessage = 'Foydalanuvchi manzili mos kelmadi';
        }
        _showErrorDialog(errorMessage);
        //print(error);
      } catch (e) {
        var errorMessage =
            'Kechirasiz, xatolik yuz berdi. Qaytadan urinib ko\'ring.';
        _showErrorDialog(errorMessage);    
      }
      setState(
        () {
          _isLoading = false;
        },
      );
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Register;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: _formKey,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Email manzili"),
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return "Iltimos emailni kiriting";
                    } else if (!email.contains('@')) {
                      return "Iltimos to'g'ri email kiriting";
                    }
                    return null;
                  },
                  onSaved: (email) {
                    _authData['email'] = email!;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Parol',
                  ),
                  controller: _passwordController,
                  obscureText: true,
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return "Iltimos parolni kiriting.";
                    } else if (password.length < 6) {
                      return "Parol juda oson.";
                    }
                    return null;
                  },
                  onSaved: (password) {
                    _authData['password'] = password!;
                  },
                ),
                if (_authMode == AuthMode.Register)
                  Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: "Parolni tasdiqlang"),
                        obscureText: true,
                        validator: (confirmedPassword) {
                          if (_passwordController.text != confirmedPassword) {
                            return "Parollar mos emas";
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                const SizedBox(
                  height: 60,
                ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit,
                        child: Text(
                          _authMode == AuthMode.Login
                              ? "KIRISH"
                              : "RO'YHATDAN O'TISH",
                        ),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            minimumSize: Size(double.infinity, 50)),
                      ),
                const SizedBox(
                  height: 40,
                ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    _authMode == AuthMode.Login
                        ? "Ro'yhatdan o'tish"
                        : "Kirish",
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
