import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/utils.dart';

class HomeUser extends StatelessWidget {
  const HomeUser({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    String jwt = arguments["jwt"];

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    bool showMobileLayout = screenWidth < widthConstraint;

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
                                      "Sogniario",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )))),
                        SizedBox(height: screenHeight * .025),
                        if (showMobileLayout)
                          ...mobileWidgets(context, jwt)
                        else
                          ...desktopWidgets(context, jwt)
                      ],
                    )))),
        floatingActionButton: showMobileLayout
            ? FloatingActionButton(
                onPressed: () => {Navigator.pushNamed(context, "/add_dream", arguments: {"jwt": jwt})},
                tooltip: 'Racconta un sogno',
                child: const Icon(Icons.cloud_upload),
              )
            : null);
  }

  List<Widget> desktopWidgets(BuildContext context, String jwt) {
    double screenHeight = MediaQuery.of(context).size.height;

    return [
      IconTextButton(
        icon: const Icon(Icons.cloud_upload),
        text: "Racconta un sogno",
        onPressed: () => {Navigator.pushNamed(context, "/add_dream", arguments: {"jwt": jwt})}
      ),
      SizedBox(height: screenHeight * .01),
      IconTextButton(
        icon: const Icon(Icons.format_list_bulleted),
        text: "PSQI",
        onPressed: () => {Navigator.pushNamed(context, "/psqi", arguments: {"jwt": jwt})}
      ),
      SizedBox(height: screenHeight * .01),
      IconTextButton(
        icon: const Icon(Icons.rocket_launch),
        text: "I miei sogni",
        onPressed: () => Navigator.pushNamed(context, "/dreams_list", arguments: {"jwt":jwt}),
      ),
    ];
  }

  List<Widget> mobileWidgets(BuildContext context, String jwt) {
    double screenHeight = MediaQuery.of(context).size.height;

    return [
      Center(
        child: SimpleCircularIconButton(
            iconData: Icons.rocket_launch, 
            text: "I miei sogni",
            onPressed: () => Navigator.pushNamed(context, "/dreams_list", arguments: {"jwt":jwt})
        ),
      ),
      SizedBox(height: screenHeight * .025),
      Row(
        children: [
          SimpleCircularIconButton(
              onPressed: () => {Navigator.pushNamed(context, "/psqi", arguments: {"jwt": jwt})},
              iconData: Icons.format_list_bulleted,
              showAlert: true,
              text: "PSQI"),
        ],
      )
    ];
  }
}

