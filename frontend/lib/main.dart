import 'package:flutter/material.dart';
import 'package:frontend/home.dart';
import 'package:frontend/login.dart';
import 'package:frontend/routes.dart';

void main() async {
  runApp(const Frontend());
}

class Frontend extends StatelessWidget {
  const Frontend({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sogniario',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/add_dream',
      onGenerateRoute: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}