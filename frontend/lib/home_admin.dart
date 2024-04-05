import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/utils.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: getMyResearcher(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        UserData user = snapshot.data!;

        return Scaffold(
          body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Center(
                  child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                          width: min(screenWidth, halfWidthConstraint)),
                      child: ListView(
                        children: [
                          SizedBox(height: screenHeight * .01),
                          Center(
                              child: Hero(
                                  tag: "SogniarioLogo",
                                  child: Material(
                                      type: MaterialType.transparency,
                                      child: Text(
                                        'Sogniario Ricercatore\n${user.organizationName}',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )))),
                          IconTextButton(
                              icon: const Icon(Icons.groups),
                              text: "Gestisci utenti",
                              onPressed: () => {
                                    Navigator.pushNamed(context, "/manage_users")
                                  }),
                          SizedBox(height: screenHeight * .01),
                          IconTextButton(
                              icon: const Icon(Icons.download),
                              text: "Scarica il database",
                              onPressed: () async {
                                String? filePath = await downloadDatabase();
                                if (!kIsWeb) {
                                  showAlert(context, filePath);
                                }
                              }),
                        ],
                      )))),
        );
      }
    );
  }

  void showAlert(BuildContext context, String? filePath) {
    if (filePath == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Errore",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            content: Text("Errore durante il download."),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Download effettuato",
            ),
            content: Text("Database scaricato in $filePath."),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
