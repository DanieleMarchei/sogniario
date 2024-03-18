/*
  Flutter UI
  ----------
  lib/screens/simple_login.dart
*/

import 'package:flutter/material.dart';
import 'package:frontend/formbutton.dart';
import 'package:frontend/inputfield.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String username, password;
  String? usernameError, passwordError;

  @override
  void initState() {
    super.initState();
    username = '';
    password = '';

    usernameError = null;
    passwordError = null;
  }

  void resetErrorText() {
    setState(() {
      usernameError = null;
      passwordError = null;
    });
  }

  bool validate() {
    resetErrorText();

    bool isValid = true;
    if (username.isEmpty) {
      setState(() {
        usernameError = 'Username non valido';
      });
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = 'Immettere una password';
      });
      isValid = false;
    }

    return isValid;
  }

  void submit() {
    if (validate()) {
      Navigator.pushNamed(context, "/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * .12),
            const Center(
                child: Hero(
                        tag: "SogniarioLogo",
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            'Sogniario',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ) 
                        )),
            SizedBox(height: screenHeight * .12),
            InputField(
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
              labelText: 'Username',
              errorText: usernameError,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              autoFocus: true,
            ),
            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              onSubmitted: (val) => submit(),
              labelText: 'Password',
              errorText: passwordError,
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: screenHeight * .075,
            ),
            FormButton(
              text: 'Entra',
              onPressed: submit,
            ),
            SizedBox(
              height: screenHeight * .15,
            )
          ],
        ),
      ),
    );
  }
}



