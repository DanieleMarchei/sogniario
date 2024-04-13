import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/decorations.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/utils.dart';

class HomeUser extends StatelessWidget {
  const HomeUser({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    bool showMobileLayout = screenWidth < widthConstraint;

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        if (doIHaveJwt()) {
          tokenBox.delete("jwt");
        }
      },
      child: ScaffoldWithCircles(
          context: context,
          body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Center(
                  child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                          width: min(screenWidth, halfWidthConstraint)),
                      child: ListView(
                        children: [
                          SizedBox(height: screenHeight * .01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            const Center(
                                child: Text(
                              "Sogniario",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                            if (kIsWeb) ...{
                              Spacer(),
                              IconTextButton(
                                icon: Icon(Icons.logout),
                                text: "Esci",
                                onPressed: () async {
                                  deleteJwt();
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    "/",
                                    (route) => false,
                                  );
                                },
                              )
                            }
                          ]),
                          SizedBox(height: screenHeight * .025),
                          if (showMobileLayout)
                            ...mobileWidgets(context)
                          else
                            ...desktopWidgets(context),
                          SizedBox(height: screenHeight * .05),
                          IconTextButton(
                              icon: const Icon(Icons.privacy_tip_outlined),
                              text: "Info e privacy",
                              onPressed: () => {
                                    Navigator.pushNamed(
                                        context, "/info_and_privacy")
                                  }),
                          if(!kIsWeb)...{
                            SizedBox(height: 100,),
                            IconTextButton(
                                icon: Icon(Icons.logout),
                                text: "Esci",
                                onPressed: () async {
                                  deleteJwt();
                                  Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false,);
                                },
                              )
                          }
                        ],
                      ))))),
    );
  }

  List<Widget> desktopWidgets(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return [
      IconTextButton(
          icon: const Icon(Icons.cloud_upload),
          text: "Racconta un sogno",
          onPressed: () => {Navigator.pushNamed(context, "/add_dream")}),
      SizedBox(height: screenHeight * .01),
      IconTextButton(
        icon: const Icon(Icons.rocket_launch),
        text: "I miei sogni",
        onPressed: () => Navigator.pushNamed(context, "/dreams_list"),
      ),
      SizedBox(height: screenHeight * .01),
      IconTextButton(
          icon: const Icon(Icons.format_list_bulleted),
          text: "PSQI",
          onPressed: () => {Navigator.pushNamed(context, "/psqi")}),
    ];
  }

  List<Widget> mobileWidgets(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    // return [
    //   Center(
    //     child: SimpleCircularIconButton(
    //         iconData: Icons.rocket_launch,
    //         text: "I miei sogni",
    //         onPressed: () => Navigator.pushNamed(context, "/dreams_list")),
    //   ),
    //   SizedBox(height: screenHeight * .025),
    //   Row(
    //     children: [
    //       SimpleCircularIconButton(
    //           onPressed: () => {Navigator.pushNamed(context, "/psqi")},
    //           iconData: Icons.format_list_bulleted,
    //           showAlert: true,
    //           text: "PSQI"),
    //     ],
    //   )
    // ];
    return [
      IconTextButton(
          icon: const Icon(Icons.cloud_upload),
          text: "Racconta un sogno",
          onPressed: () => {Navigator.pushNamed(context, "/add_dream")}),
      SizedBox(height: screenHeight * .01),
      IconTextButton(
        icon: const Icon(Icons.rocket_launch),
        text: "I miei sogni",
        onPressed: () => Navigator.pushNamed(context, "/dreams_list"),
      ),
      SizedBox(height: screenHeight * .01),
      IconTextButton(
          icon: const Icon(Icons.format_list_bulleted),
          text: "PSQI",
          onPressed: () => {Navigator.pushNamed(context, "/psqi")}),
    ];
  }
}
