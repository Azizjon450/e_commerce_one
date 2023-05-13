import 'package:flutter/material.dart';

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
  Map<String, String> _authData = {
    "email": '',
    "password": '',
  };

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    } else if (email.contains('@')) {
                      return "Iltimos to'g'ri email kiriting";
                    }
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
                  obscureText: true,
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return "Iltimos parolni kiriting";
                    } else if (password.length < 6) {
                      return "Parol juda oson";
                    }
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
                          if (_authData['password'] != confirmedPassword) {
                            return "Parollar mos emas";
                          }
                        },
                      )
                    ],
                  ),
                const SizedBox(
                  height: 60,
                ),
                ElevatedButton(
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
                  ),
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
