import 'package:flutter/material.dart';
import 'package:frontend/add_dream.dart';
import 'package:frontend/chronotype.dart';
import 'package:frontend/general_info.dart';
import 'package:frontend/home_admin.dart';
import 'package:frontend/home_user.dart';
import 'package:frontend/login.dart';
import 'package:frontend/manage_users.dart';
import 'package:frontend/psqi.dart';

class PageTransition<T> extends MaterialPageRoute<T> {
  PageTransition({
    required super.builder,
    required RouteSettings super.settings
    });

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}

class Routes {
  static Route<dynamic> routes(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return PageTransition(
            settings: settings, 
            builder: (context) => const Login());

      case "/home_user":
        return PageTransition(
            settings: settings, 
            builder: (context) => const HomeUser());

      case "/home_admin":
        return PageTransition(
            settings: settings, 
            builder: (context) => const HomeAdmin());

      case "/manage_users":
        return PageTransition(
            settings: settings, 
            builder: (context) => const ManageUsers());

      case "/add_dream":
        return PageTransition(
            settings: settings, 
            builder: (context) => const AddDream());

      case "/general_info":
        return PageTransition(
            settings: settings, 
            builder: (context) => const GeneralInfo());

      case "/psqi":
        return PageTransition(
            settings: settings, 
            builder: (context) => const PSQI());

      case "/chronotype":
        return PageTransition(
            settings: settings, 
            builder: (context) => const ChronoType());

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
