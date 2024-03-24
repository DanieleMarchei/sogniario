import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/utils.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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
                        const Center(
                            child: Hero(
                                tag: "SogniarioLogo",
                                child: Material(
                                    type: MaterialType.transparency,
                                    child: Text(
                                      'Sogniario Admin',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )))),
                        IconTextButton(
                            icon: const Icon(Icons.groups),
                            text: "Gestisci utenti",
                            onPressed: () => {Navigator.pushNamed(context, "/manage_users")}),
                        SizedBox(height: screenHeight * .01),
                        IconTextButton(
                            icon: const Icon(Icons.download),
                            text: "Scarica il database",
                            onPressed: () => {}),
                      ],
                    )))),
                    );
  }
}
