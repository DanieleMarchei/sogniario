import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/decorations.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/utils.dart';
import 'package:go_router/go_router.dart';

class HomeUser extends StatelessWidget {
  const HomeUser({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    bool showMobileLayout = screenWidth < widthConstraint;
    print("jwt? ${doIHaveJwt()}");

    var exitFunc = () async {
      deleteJwt();
      context.goNamed(Routes.login.name);
    };

    return ScaffoldWithCircles(
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
                                onPressed: exitFunc
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
                                    context.goNamed(Routes.infoAndPrivacy.name)
                                  }),
                          if(!kIsWeb)...{
                            SizedBox(height: 100,),
                            IconTextButton(
                                icon: Icon(Icons.logout),
                                text: "Esci",
                                onPressed: exitFunc,
                              )
                          }
                        ],
                      )))));
  }

  List<Widget> desktopWidgets(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return [
      IconTextButton(
        icon: const Icon(Icons.cloud_upload),
        text: "Racconta un sogno",
        onPressed: () => context.goNamed(Routes.addDream.name)
      ),
      SizedBox(height: screenHeight * .01),
      IconTextButton(
        icon: const Icon(Icons.rocket_launch),
        text: "I miei sogni",
        onPressed: () => context.goNamed(Routes.myDreams.name),
      ),
      SizedBox(height: screenHeight * .01),
      IconTextButton(
        icon: const Icon(Icons.format_list_bulleted),
        text: "PSQI",
        onPressed: () => context.goNamed(Routes.psqi.name)
      ),
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
          onPressed: () => context.goNamed(Routes.addDream.name)),
      SizedBox(height: screenHeight * .01),
      IconTextButton(
        icon: const Icon(Icons.rocket_launch),
        text: "I miei sogni",
        onPressed: () => context.goNamed(Routes.myDreams.name),
      ),
      SizedBox(height: screenHeight * .01),
      IconTextButton(
          icon: const Icon(Icons.format_list_bulleted),
          text: "PSQI",
          onPressed: () => context.goNamed(Routes.psqi.name)),
    ];
  }
}
