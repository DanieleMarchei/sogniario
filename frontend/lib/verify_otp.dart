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

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({super.key});
  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  late String otp;
  String? otpError;
  bool askToWait = false;
  bool registration_finished = false;

  @override
  void initState() {
    super.initState();
    // if (doIHaveJwt()) {
    //   tokenBox.delete(HiveBoxes.jwt.label);
    // }
    otp = '';

    otpError = null;
    registration_finished = false;
  }

  void resetErrorText() {
    setState(() {
      otpError = null;
    });
  }

  (bool, String) isValidOTP(String otp_to_verify, { int otp_length = 8, }){

    List<String> errors = [];

    // print("length");
    // print(pwd.length);
    bool length = otp_to_verify.length >= otp_length;
    String err_length = "contenere esattamente $otp_length caratteri";
    if(!length){
      errors.add(err_length);
    }

    bool n_digits = RegExp(r'[0-9]').allMatches(otp_to_verify).length == otp_length;
    String err_n_digits = "essere composto da soli numeri";
    if(!n_digits){
      errors.add(err_n_digits);
    }
    
    String err_string = errors.join(" ed ");
    if(errors.isNotEmpty){
      err_string = "Il codice deve $err_string";
    }else{
      err_string = "";
    }

    // print("-----------------");

    return (errors.isEmpty, err_string);
  }

  void validate() async{
    resetErrorText();

    bool isValid = true;

    var (validPwd, errorPwd) = isValidOTP(otp);
    if(!validPwd){
      setState(() {
        otpError = errorPwd;
      });
      isValid = false;
    }

    setState(() {
      askToWait = true;
    });
    
    if (!isValid) {

      Fluttertoast.showToast(
          msg: "Codice invalido.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);

    }else{
      try {
        bool? isValidOTP = await verifyOTP(otp);
        if(isValidOTP == null){
          Fluttertoast.showToast(
            msg: "Errore: richiesta non andata a buon fine.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 12.0);
            return;
        }
        if(!isValidOTP){
          Fluttertoast.showToast(
              msg: "Codice incorretto, riprova a registrarti.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 12.0);
          context.goNamed(Routes.signUp.name);
        }else{
          deleteJwtAndUserData();
          setState(() {
            registration_finished = true;
          });
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

    var otpField = InputField(
      labelText: "Codice ricevuto via mail", 
      onChanged: (value) {
        setState(() {
          otp = value;
        });
      },
      errorText: otpError,
    );
    

    var inviaButton = IconTextButton(text: "Invia", onPressed: validate, backgroundColor:  Colors.blue.shade400, icon: const Icon(Icons.rocket_launch));
    var tornaALoginButton = IconTextButton(text: "Torna alla schermata di login", onPressed: () {
      context.goNamed(Routes.login.name);
    }, backgroundColor:  Colors.blue.shade400, icon: const Icon(Icons.login_outlined));

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
                              if(!registration_finished)...{
                                const Text("Ti abbiamo inviato per email un codice per verificare la tua iscrizione. Inseriscilo qua sotto e infine premi il tasto Invia.", textAlign: TextAlign.center),
                                SizedBox(height: screenHeight * .05),
                                otpField,
                                SizedBox(
                                  height: screenHeight * .03,
                                ),
                                if(askToWait)...{
                                  const Text("Attendere...", textAlign: TextAlign.center)
                                }else...{
                                  inviaButton,

                                },

                              }else...{
                                const Text("Registrazione terminata! Ti abbiamo mandato per mail il tuo nome utente da usare durante l'accesso.", textAlign: TextAlign.center),
                                SizedBox(height: screenHeight * .05),
                                tornaALoginButton
                              },

                              SizedBox(
                                height: screenHeight * .03,
                              ),
                            ]),
                          ],
                        )))),
          ),
        );
      }
    );
  }
}
