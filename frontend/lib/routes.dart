import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/add_dream_with_s2t.dart';
import 'package:frontend/add_dream_without_s2t.dart';
import 'package:frontend/api.dart';
import 'package:frontend/chronotype.dart';
import 'package:frontend/dreams_list.dart';
import 'package:frontend/general_info.dart';
import 'package:frontend/home_admin.dart';
import 'package:frontend/home_user.dart';
import 'package:frontend/info_privacy.dart';
import 'package:frontend/login.dart';
import 'package:frontend/manage_users.dart';
import 'package:frontend/psqi.dart';
import 'package:page_transition/page_transition.dart';

class PageTransitionOrLogin extends MaterialPageRoute {
  PageTransitionOrLogin({
    required builder,
    required RouteSettings super.settings
    }) : super(builder: doIHaveJwt() ? builder : (context) {
      print("wops");
      return const Login();});

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}

class Routes {
  static Route<dynamic> routes(RouteSettings settings) {
    print(settings.name);
    switch (settings.name) {
      case "/":
        return PageTransition(
            type: PageTransitionType.fade,
            child: const Login());

      case "/home_user":
        return PageTransitionOrLogin(
            settings: settings, 
            builder: (context) => const HomeUser());

      case "/home_admin":
        return PageTransitionOrLogin(
            settings: settings, 
            builder: (context) => const HomeAdmin());

      case "/manage_users":
        return PageTransitionOrLogin(
            settings: settings, 
            builder: (context) => const ManageUsers());

      case "/add_dream":
        return PageTransitionOrLogin(
            settings: settings, 
            builder: (context) {
              return AddDreamWithS2T();
              // if(kIsWeb){
              //   return AddDreamWithoutS2T();
              // }else{
              //   return AddDreamWithS2T();
              // }
            });

      case "/dreams_list":
        return PageTransitionOrLogin(
            settings: settings, 
            builder: (context) => DreamsList());

      case "/general_info":
        return PageTransitionOrLogin(
            settings: settings, 
            builder: (context) => const GeneralInfo());

      case "/psqi":
        return PageTransitionOrLogin(
            settings: settings, 
            builder: (context) => const PSQI());

      case "/chronotype":
        return PageTransitionOrLogin(
            settings: settings, 
            builder: (context) => const ChronoType());
      
      case "/info_and_privacy":
        return PageTransitionOrLogin(
            settings: settings, 
            builder: (context) => InfoAndProvacy());

      default:
        return errorPage();
    }
  }

  static Route<dynamic> errorPage() {
    return MaterialPageRoute(
        builder: (_) => const Scaffold(
              body: Center(
                  child: Text('Page not found!',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ))),
            ));
  }
}
