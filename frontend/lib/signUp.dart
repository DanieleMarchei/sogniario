import 'dart:async';

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

import 'package:email_validator/email_validator.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String email, confirmEmail, password, confirmPassword;
  String? emailError;
  String? emailConfirmError;
  String? passwordError;
  String? passwordConfirmError;
  bool askToWait = false;

  @override
  void initState() {
    super.initState();
    // if (doIHaveJwt()) {
    //   tokenBox.delete(HiveBoxes.jwt.label);
    // }
    email = '';
    confirmEmail = '';
    password = '';
    confirmPassword = '';

    emailError = null;
    emailConfirmError = null;
    passwordError = null;
    passwordConfirmError = null;
  }

  void resetErrorText() {
    setState(() {
      emailError = null;
      emailConfirmError = null;
      passwordError = null;
      passwordConfirmError = null;
    });
  }

  (bool, String) isValidPassword(
        String pwd, 
        {
          int min_length = 8, 
          int min_n_digits = 1, 
          int min_n_uppers = 1, 
          int min_n_lowers = 1, 
          int min_n_specials = 1
        }
    ){


    List<String> errors = [];

    // print("length");
    // print(pwd.length);
    bool length = pwd.length >= min_length;
    String err_length = "contenere almeno $min_length caratteri";
    if(!length){
      errors.add(err_length);
    }
    
    
    // print("n_digits");
    // print(RegExp(r'[0-9]').allMatches(pwd).length);
    bool n_digits = RegExp(r'[0-9]').allMatches(pwd).length >= min_n_digits;
    String err_n_digits = "contenere almeno $min_n_digits numeri";
    if(!n_digits){
      errors.add(err_n_digits);
    }

    // print("n_uppers");
    // print(RegExp(r'[A-Z]').allMatches(pwd).length);
    bool n_uppers = RegExp(r'[A-Z]').allMatches(pwd).length >= min_n_uppers;
    String err_n_uppers = "contenere almeno $min_n_uppers lettere maiuscole";
    if(!n_uppers){
      errors.add(err_n_uppers);
    }

    // print("n_lowers");
    // print(RegExp(r'[a-z]').allMatches(pwd).length);
    bool n_lowers = RegExp(r'[a-z]').allMatches(pwd).length >= min_n_lowers;
    String err_n_lowers = "contenere almeno $min_n_lowers lettere minuscole";
    if(!n_lowers){
      errors.add(err_n_lowers);
    }


    // from: https://gist.github.com/rahulbagal/4a06a997497e6f921663b69e5286d859
    // print("n_specials");
    // print(RegExp(r'[!@#$%^&*(),.?":{}|<>_-]').allMatches(pwd).length);
    bool n_specials = RegExp(r'[!@#$%^&*(),.?":{}|<>_-]').allMatches(pwd).length >= min_n_specials;
    String err_n_specials = "contenere almeno $min_n_specials caratteri speciali fra " r'!@#$%^&*(),.?":{}|<>_-';
    if(!n_specials){
      errors.add(err_n_specials);
    }

    // print("n_impossibles");
    var invalid_chars = RegExp(r'[^0-9a-zA-Z!@#$%^&*(),.?":{}|<>_-]').allMatches(pwd).map((m) => m.group(0));
    // print(invalid_chars.join(" "));

    bool contains_invalid_chars = invalid_chars.isEmpty;
    var invalid_chars_str = invalid_chars.toSet().join("");
    String err_contains_invalid_chars = "evitare i caratteri $invalid_chars_str";
    if(!contains_invalid_chars){
      errors.add(err_contains_invalid_chars);
    }

    String err_string = errors.join(", ");
    if(errors.isNotEmpty){
      err_string = "La password deve $err_string";
    }else{
      err_string = "";
    }

    // print("-----------------");

    return (errors.isEmpty, err_string);
  }

  void validate() async{
    resetErrorText();

    bool isValid = true;
    if (email.isEmpty) {
      setState(() {
        emailError = 'Inserisci una mail';
      });
      isValid = false;
    }
    // top-level and international set to false for security reasons
    // if in the future we will open Sogniario to other countries, set international (3rd argument) to true
    else if (!EmailValidator.validate(email, false, false)){
        setState(() {
          emailError = 'Inserisci una mail valida';
      });
      isValid = false;
    }
    else if (confirmEmail.isEmpty) {
      setState(() {
        emailConfirmError = 'Inserisci una seconda volta la tua mail';
      });
      isValid = false;
    }
    else if (email != confirmEmail) {
      setState(() {
        emailError = 'Le due mail devono coincidere';
        emailConfirmError = 'Le due mail devono coincidere';
      });
      isValid = false;
    }
    
    if (password.isEmpty) {
      setState(() {
        passwordError = 'Inserisci una password';
      });
      isValid = false;
    }
    else if (confirmPassword.isEmpty) {
      setState(() {
        passwordConfirmError = 'Inserisci una seconda volta la tua password';
      });
      isValid = false;
    }
    else if (password != confirmPassword) {
      setState(() {
        passwordError = 'Le due password devono coincidere';
        passwordConfirmError = 'Le due password devono coincidere';
      });
      isValid = false;
    }

    var (validPwd, errorPwd) = isValidPassword(password);
    if(!validPwd){
      setState(() {
        passwordError = errorPwd;
      });
      isValid = false;
    }

    setState(() {
      askToWait = true;
    });

    if (!isValid) {
      Fluttertoast.showToast(
          msg: "Credenziali errate.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }else{
      try {

        bool success = await sendEmailSignUp(email, confirmEmail, password, confirmPassword);
        if(!success){
          Fluttertoast.showToast(
            msg: "Errore: richiesta non andata a buon fine. Riprova più tardi.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 12.0);

        }else{
          context.goNamed(Routes.otp.name);
        }
      } 
      catch (e) {
        Fluttertoast.showToast(
            msg: "Errore: impossibile contattare il server.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 12.0);
      }
      
    }
    setState(() {
      askToWait = false;
    });

  }

  @override 
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isScreenWide = MediaQuery.sizeOf(context).width >= widthConstraint;

    var emailField = InputField(
      labelText: "Email", 
      onChanged: (value) {
        setState(() {
          email = value;
        });
      },
      errorText: emailError,
    );
    var confermaEmailField = InputField(
      labelText: "Conferma email",
      onChanged: (value) {
        setState(() {
          confirmEmail = value;
        });
      },
      errorText: emailConfirmError,
      textInputAction: TextInputAction.next,
    );
    var passwordField = InputField(
      labelText: "Password", 
      obscureText: true, 
      toggleObscure: true,
      onChanged: (value) {
        setState(() {
          password = value;
        });
      },
      errorText: passwordError,
      textInputAction: TextInputAction.next,
    );
    var confermaPasswordField = InputField(
      labelText: "Conferma password", 
      obscureText: true, 
      toggleObscure: true,
      onChanged: (value) {
        setState(() {
          confirmPassword = value;
        });
      },
      errorText: passwordConfirmError,
      textInputAction: TextInputAction.next,
    );

    var inviaButton = IconTextButton(text: "Registrati", onPressed: validate, backgroundColor:  Colors.blue.shade400, icon: const Icon(Icons.mail));

    return Builder(
      builder: (context) { 
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
                                'Registrati a Sogniario',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: screenHeight * .05),
                              emailField,
                              SizedBox(height: screenHeight * .025),
                              confermaEmailField,
                              SizedBox(
                                height: screenHeight * .03,
                              ),
                              passwordField,
                              SizedBox(height: screenHeight * .025),
                              confermaPasswordField,
                              SizedBox(
                                height: screenHeight * .03,
                              ),
                              if(askToWait)...{
                                const Text(
                                  "Attendere...",
                                  textAlign: TextAlign.center,
                                )
                              }else...{
                                inviaButton,
                              },
                              SizedBox(
                                height: screenHeight * .03,
                              ),
                              const Text(
                                "Riceverai una mail con un codice che ti servirà a confermare la registrazione. La tua mail sarà salvata in maniera sicura e non ti invieremo spam.",
                                textAlign: TextAlign.center,
                              )
                            
                            ]),
                          ],
                        )))),
          ),
        );
      }
    );
  }
}
