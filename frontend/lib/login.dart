import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/api.dart';
import 'package:frontend/decorations.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/routes.dart';
import 'dart:math';

import 'package:frontend/utils.dart';
import 'package:go_router/go_router.dart';

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
  bool askToWait = false;

  @override
  void initState() {
    super.initState();
    // if (doIHaveJwt()) {
    //   tokenBox.delete(HiveBoxes.jwt.label);
    // }
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
    try {
      loginValid = await validateFunc(username, password);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Errore: impossibile contattare il server.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
      return false;
    }
    isValid &= loginValid;

    if (!isValid) {
      Fluttertoast.showToast(
          msg: "Credenziali errate.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }

    return isValid;
  }

  void submitUser() async {
    if (await validate(isValidLoginUser)) {
      print("validate jwt: ${doIHaveJwt()}");
      DateTime? birthdate;
      Sex? sex;
      (birthdate, sex) = await getMyGeneralInfo();
      bool redirectToGeneralInfo = birthdate == null || sex == null;
      if (redirectToGeneralInfo) {
        context.goNamed(Routes.generalInfo.name);
        // Navigator.pushNamed(context, "/general_info");
      } else {
          context.goNamed(Routes.homeUser.name);
          // Navigator.pushNamed(context, "/home_user");
      }
    }
  }
  

  void submitResearcher() async {
    if (await validate(isValidLoginResearcher)) {
      context.goNamed(Routes.homeResearcher.name);

      // Navigator.pushNamed(context, "/home_admin");
    }
  }

  @override 
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isScreenWide = MediaQuery.sizeOf(context).width >= widthConstraint;

    var userLoginBtn = IconTextButton(
                                    icon: const Icon(Icons.person),
                                    text: 'Entra come utente',
                                    onPressed: submitUser,
                                    backgroundColor: Colors.blue.shade400,
                                  );
    var researcherLoginBtn = IconTextButton(
                                    icon: const Icon(Icons.person_search_rounded),
                                    text: 'Entra come ricercatore',
                                    onPressed: submitResearcher,
                                    backgroundColor: Colors.orange.shade400,
                                  );

    return PopScope(
      canPop: false,
      child: ScaffoldWithCircles(
        context: context,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
                child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: min(screenWidth, halfWidthConstraint)),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 25),
                            SizedBox(
                              height: 100,
                              child: Row(children: [
                                Expanded(
                                  child: Image.asset('assets/unicam_logo.png', 
                                  scale: 0.5,
                                  ),),
                                const Spacer(),
                                Expanded(
                                  child: Image.asset('assets/bsrl_logo.png', 
                                  scale: 1, 
                                  fit: BoxFit.contain,),),
                              ],),
                            ),
                          ],
                        ),
                        ListView(children: [                        
                          SizedBox(height: screenHeight * .2),
                          const Text(
                            'Sogniario',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10,),
                          const SelectableText("Sogniario è una applicazione mobile sviluppata dall'Università di Camerino per registrare e catalogare i sogni.", textAlign: TextAlign.center,),
                          SizedBox(height: screenHeight * .05),
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
                            height: screenHeight * .03,
                          ),
                          if (loginError != null) Text(loginError!),
                          if (isScreenWide) ...{
                            Row(
                              children: [
                                Expanded(
                                  child: userLoginBtn,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: researcherLoginBtn
                                ),
                              ],
                            ),
                          } else ...{
                            userLoginBtn,
                            const SizedBox(
                              height: 10,
                            ),
                            researcherLoginBtn
                          },
                          if (kIsWeb) ...{
                            const SizedBox(
                              height: 50,
                            ),
                            IconTextButton(
                              icon: askToWait ? const CircularProgressIndicator() : const Icon(Icons.android),
                              text: "Scarica l'app (Android)",
                              onPressed: () async {
                                setState(() {
                                  askToWait = true;
                                });
                                await downloadAndroidApp();
                                setState(() {
                                  askToWait = false;
                                });
                              }
                            ),
                          },
                        
                        ]),
                      ],
                    )))),
      ),
    );
  }
}
