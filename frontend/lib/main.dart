import 'package:flutter/material.dart';
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
      initialRoute: '/',
      onGenerateRoute: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}