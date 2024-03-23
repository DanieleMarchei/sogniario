import 'package:flutter/material.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'dart:math';

import 'package:frontend/utils.dart';

class Login extends StatefulWidget {
  const Login({super.key});
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
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
              child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: min(screenWidth, halfWidthConstraint)),
                  child: ListView(
                    children: [
                      SizedBox(height: screenHeight * .12),
                      const Hero(
                          tag: "SogniarioLogo",
                          child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                'Sogniario',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))),
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
                  )))),
    );
  }
}
