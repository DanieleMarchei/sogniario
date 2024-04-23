import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/routes.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('tokens');
  await Hive.openBox('userData');
  runApp(Frontend());
}

class Frontend extends StatelessWidget {
  Frontend({super.key});

  late StreamSubscription<List<ConnectivityResult>> subscription;


  @override
  Widget build(BuildContext context) {
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
        if(result.contains(ConnectivityResult.none)){
          Fluttertoast.showToast(
            msg: "Errore durante la connessione ad internet.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 12.0
        );
        }
    });
    return MaterialApp.router(
      title: "Sogniario",
      onGenerateTitle: (context) => "Sogniario",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}