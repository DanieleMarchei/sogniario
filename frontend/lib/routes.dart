import 'package:flutter/material.dart';
import 'package:frontend/add_dream.dart';
import 'package:frontend/chronotype.dart';
import 'package:frontend/general_info.dart';
import 'package:frontend/home.dart';
import 'package:frontend/login.dart';
import 'package:frontend/psqi.dart';
import 'package:page_transition/page_transition.dart';


class Routes {

  static Route<dynamic> routes(RouteSettings settings) {

    switch (settings.name) {

      case "/":
        return PageTransition(
          child: const Login(),
          type: PageTransitionType.fade);

      case "/home":
        return PageTransition(
          child: const Home(),
          type: PageTransitionType.fade);
      
      case "/add_dream":
      return PageTransition(
        child: const AddDream(),
        type: PageTransitionType.fade);

      case "/general_info":
      return PageTransition(
        child: const GeneralInfo(),
        type: PageTransitionType.fade);

      case "/psqi":
      return PageTransition(
        child: const PSQI(),
        type: PageTransitionType.fade);

      case "/chronotype":
      return PageTransition(
        child: const ChronoType(),
        type: PageTransitionType.fade);

      default:
        return errorPage();
    }
  }


  static Route<dynamic> errorPage() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Container(
            child: Center(
                child: Text(
                    'Page not found!',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )
                )
            ),
          ),
        )
    );
  }

}