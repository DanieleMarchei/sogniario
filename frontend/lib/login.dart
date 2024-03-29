import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'dart:math';

import 'package:frontend/utils.dart';

enum LoginType {
  user,
  admin
}

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String username, password;
  int? id;
  late bool redirectToGeneralInfo;
  String? usernameError, passwordError;
  late LoginType loginType;
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

  Future<bool> validate() async {
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

    if(username == "admin"){
      loginType = LoginType.admin;
      return true;
    }

    bool loginValid;
    int? fetchedId; 
    (loginValid, fetchedId) = await isValidLogin(username, password);

    isValid &= loginValid;

    if (isValid){
      switch (username) {
        case "admin":
          loginType = LoginType.admin;
          break;
          
        default:
          setState(() {
            id = fetchedId!;
          });

          DateTime? birthdate;
          Gender? gender;
          (birthdate, gender) = await getGeneralInfo(id!);
          setState(() {
            redirectToGeneralInfo = birthdate == null || gender == null;
          });
          loginType = LoginType.user;
          break;
      }
    } else{
      setState(() {
        loginError = "Credenziali errate";
      });
    }


    return isValid;
  }

  void submit() async {
    if (await validate()) {
      switch (loginType) {
        case LoginType.admin:
          Navigator.pushNamed(context, "/home_admin");
          break;
        
        case LoginType.user:
          if(redirectToGeneralInfo){
            Navigator.pushNamed(context, "/general_info", arguments: {"id": id!});
          }else{
            ChronoTypeData? chronotype = await getChronotype(id!);
            if (chronotype == null){
              Navigator.pushNamed(context, "/chronotype", arguments: {"id": id!});
            }else{
              Navigator.pushNamed(context, "/home_user", arguments: {"id": id!});
            }
          }
          break;
      }
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
                        toggleObscure: true,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: screenHeight * .075,
                      ),
                      if (loginError != null) Text(loginError!),
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
