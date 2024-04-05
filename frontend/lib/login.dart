import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'dart:math';

import 'package:frontend/utils.dart';

enum LoginType { user, admin }

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String username, password;
  String? usernameError, passwordError;
  String? loginError;

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
      loginError = null;
    });
  }

  Future<bool> validate(
      Future<bool> Function(String, String) validateFunc) async {
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

    bool loginValid;
    loginValid = await validateFunc(username, password);
    isValid &= loginValid;

    if (!isValid) {
      setState(() {
        loginError = "Credenziali errate";
      });
    }

    return isValid;
  }

  void submitUser() async {
    if (await validate(isValidLoginUser)) {
      DateTime? birthdate;
      Sex? sex;
      (birthdate, sex) = await getMyGeneralInfo();
      bool redirectToGeneralInfo = birthdate == null || sex == null;
      if (redirectToGeneralInfo) {
        Navigator.pushNamed(context, "/general_info");
      } else {
        ChronoTypeData? chronotype = await getMyChronotype();
        if (chronotype == null) {
          Navigator.pushNamed(context, "/chronotype");
        } else {
          Navigator.pushNamed(context, "/home_user");
        }
      }
    }
  }

  void submitResearcher() async {
    if (await validate(isValidLoginResearcher)) {
      Navigator.pushNamed(context, "/home_admin");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isScreenWide = MediaQuery.sizeOf(context).width >= widthConstraint;

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
              child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                      width: min(screenWidth, halfWidthConstraint)),
                  child: ListView(children: [
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
                      labelText: 'Password',
                      errorText: passwordError,
                      toggleObscure: true,
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(
                      height: screenHeight * .075,
                    ),
                    if (loginError != null) Text(loginError!),
                    if (isScreenWide) ...{
                      Row(
                        children: [
                          Expanded(
                            child: IconTextButton(
                              icon: const Icon(Icons.person),
                              text: 'Entra come utente',
                              onPressed: submitUser,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: IconTextButton(
                              icon: const Icon(Icons.person_search_rounded),
                              text: 'Entra come ricercatore',
                              onPressed: submitResearcher,
                            ),
                          ),
                        ],
                      ),
                    } else ...{
                      IconTextButton(
                          icon: const Icon(Icons.person),
                          text: 'Entra come utente',
                          onPressed: submitUser,
                        ),
                      
                      SizedBox(
                        height: 10,
                      ),
                      IconTextButton(
                          icon: const Icon(Icons.person_search_rounded),
                          text: 'Entra come ricercatore',
                          onPressed: submitResearcher,
                        ),
                      
                    }
                  ])))),
    );
  }
}
