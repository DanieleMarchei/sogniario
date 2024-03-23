import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/utils.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
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
                                      'Sogniario',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )))),
                        SizedBox(height: screenHeight * .025),
                        if (showMobileLayout)
                          ...mobileWidgets(context)
                        else
                          ...desktopWidgets(context)
                      ],
                    )))),
        floatingActionButton: showMobileLayout
            ? FloatingActionButton(
                onPressed: () => {Navigator.pushNamed(context, "/add_dream")},
                tooltip: 'Racconta un sogno',
                child: const Icon(Icons.insert_comment),
              )
            : null);
  }

  List<Widget> desktopWidgets(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return [
      IconTextButton(
        icon: const Icon(Icons.insert_comment),
        text: "Racconta un sogno",
        onPressed: () => {Navigator.pushNamed(context, "/add_dream")}
      ),
      SizedBox(height: screenHeight * .01),
      IconTextButton(
        icon: const Icon(Icons.format_list_bulleted),
        text: "PSQI",
        onPressed: () => {Navigator.pushNamed(context, "/psqi")}
      ),
      SizedBox(height: screenHeight * .01),
      IconTextButton(
        icon: const Icon(Icons.view_list),
        text: "Cronotipo",
        onPressed: () => {Navigator.pushNamed(context, "/chronotype")}
      ),
    ];
  }

  List<Widget> mobileWidgets(BuildContext context) {
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
              onPressed: () => {Navigator.pushNamed(context, "/psqi")},
              iconData: Icons.format_list_bulleted,
              showAlert: true,
              text: "PSQI"),
          Spacer(),
          SimpleCircularIconButton(
              onPressed: () => {Navigator.pushNamed(context, "/chronotype")},
              showAlert: true,
              iconData: Icons.view_list,
              text: "Cronotipo")
        ],
      )
    ];
  }
}

class SimpleCircularIconButton extends StatelessWidget {
  const SimpleCircularIconButton(
      {this.fillColor = Colors.transparent,
      required this.iconData,
      this.text = "",
      this.iconColor = Colors.blue,
      this.outlineColor = Colors.transparent,
      this.showAlert = false,
      this.onPressed,
      this.radius = 70.0,
      super.key});

  final IconData iconData;
  final String text;
  final Color fillColor;
  final Color outlineColor;
  final bool showAlert;
  final Color iconColor;
  final Function? onPressed;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Ink(
              width: radius,
              height: radius,
              decoration: ShapeDecoration(
                color: fillColor,
                shape: CircleBorder(side: BorderSide(color: outlineColor)),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                splashRadius: radius,
                iconSize: radius,
                icon: Icon(iconData, color: iconColor),
                splashColor: iconColor.withOpacity(.4),
                onPressed: onPressed as void Function()?,
              ),
            ),
            if (showAlert) ...[
              Positioned(
                top: radius / 100,
                right: radius / 100,
                child: Container(
                  width: radius / 3,
                  height: radius / 3,
                  decoration: const ShapeDecoration(
                    color: Colors.red,
                    shape: CircleBorder(),
                  ),
                  child: Center(
                    child: Text(
                      "!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: radius / 4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        Text(
          this.text,
          textAlign: TextAlign.justify,
        )
      ],
    );
  }
}
