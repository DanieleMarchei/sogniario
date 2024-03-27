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
    int id = arguments["id"];

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
                          ...mobileWidgets(context, id)
                        else
                          ...desktopWidgets(context, id)
                      ],
                    )))),
        floatingActionButton: showMobileLayout
            ? FloatingActionButton(
                onPressed: () => {Navigator.pushNamed(context, "/add_dream", arguments: {"id": id})},
                tooltip: 'Racconta un sogno',
                child: const Icon(Icons.insert_comment),
              )
            : null);
  }

  List<Widget> desktopWidgets(BuildContext context, int id) {
    double screenHeight = MediaQuery.of(context).size.height;

    return [
      IconTextButton(
        icon: const Icon(Icons.insert_comment),
        text: "Racconta un sogno",
        onPressed: () => {Navigator.pushNamed(context, "/add_dream", arguments: {"id": id})}
      ),
      SizedBox(height: screenHeight * .01),
      IconTextButton(
        icon: const Icon(Icons.format_list_bulleted),
        text: "PSQI",
        onPressed: () => {Navigator.pushNamed(context, "/psqi", arguments: {"id": id})}
      ),
      SizedBox(height: screenHeight * .01),
      IconTextButton(
        icon: const Icon(Icons.view_list),
        text: "Cronotipo",
        onPressed: () => {Navigator.pushNamed(context, "/chronotype", arguments: {"id": id})}
      ),
      SizedBox(height: screenHeight * .01),
      IconTextButton(
        icon: const Icon(Icons.view_list),
        text: "I miei sogni",
        onPressed: () async {
          print(await getAllDreams(id));
        },
        // onPressed: () => {Navigator.pushNamed(context, "/chronotype", arguments: {"id": id})}
      ),
    ];
  }

  List<Widget> mobileWidgets(BuildContext context, int id) {
    double screenHeight = MediaQuery.of(context).size.height;

    return [
      const Center(
        child: SimpleCircularIconButton(
            iconData: Icons.cloud_done, text: "I miei sogni"),
      ),
      SizedBox(height: screenHeight * .025),
      Row(
        children: [
          SimpleCircularIconButton(
              onPressed: () => {Navigator.pushNamed(context, "/psqi", arguments: {"id": id})},
              iconData: Icons.format_list_bulleted,
              showAlert: true,
              text: "PSQI"),
          const Spacer(),
          SimpleCircularIconButton(
              onPressed: () => {Navigator.pushNamed(context, "/chronotype", arguments: {"id": id})},
              showAlert: true,
              iconData: Icons.view_list,
              text: "Cronotipo")
        ],
      )
    ];
  }
}

