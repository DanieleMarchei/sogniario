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




  Future<(bool, bool)> showChronotypePsqiButtons() async{
    ChronoTypeData? chrono = await getMyChronotype();
    List<PSQIData> psqis = await getMyPSQIs();

    psqis.sort((p1,p2) => p1.compiled_date!.compareTo(p2.compiled_date!));

    bool showPsqiBtn = psqis.isEmpty;
    if(psqis.isNotEmpty){
      DateTime now = DateTime.now();
      Duration d = now.difference(psqis.last.compiled_date!);
      showPsqiBtn |= d.inDays >= 31;
      // showPsqiBtn = false;
    }
    return (chrono == null, showPsqiBtn);      
  }

  alertReportOnPressed(BuildContext context, bool showChronoBtn, bool showPsqiAlert, String routeName) async {
      if (showChronoBtn || showPsqiAlert){
        List<(String, String)> q = [];
        if(showChronoBtn) q.add(("Cronotipo", Routes.chronotype.name));
        if(showPsqiAlert) q.add(("PSQI", Routes.psqi.name));
        String text = "Prima di continuare è necessario compilare ";
        if (q.length == 1){
          text += "il questionario sul ${q[0].$1}.";
        }else{
          text += "i questionari ${q[0].$1} e ${q[1].$1}.";
        }

        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: Text("Attenzione"),
                  insetPadding: EdgeInsets.all(16),
                  content: Text(text, textAlign: TextAlign.justify,),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Annulla'),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                    ...List.generate(q.length, (int index) {
                      return TextButton(
                        child: Text(q[index].$1),
                        onPressed: () {
                          context.goNamed(q[index].$2);
                        },
                      );
                    }
                    )
                  ],
                );
            }
        );
      }else{
        context.goNamed(routeName);
      }
    }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    bool showMobileLayout = screenWidth < widthConstraint;


    exitFunc() async {
      deleteJwtAndUserData();
      context.goNamed(Routes.login.name);
    }


    return FutureBuilder(
      future: Future.wait([
        isTimeToCheckVersion() ? isAppUpToDate() : Future(() => true),
        showChronotypePsqiButtons()
      ]),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return ScaffoldWithCircles(
            body: Container(
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
            context: context
          );
        }

        if(snapshot.data![0] == false){
          Future( () => showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: const Text("Aggiorna Sogniario"),
                insetPadding: const EdgeInsets.all(16),
                content: const Text("Una nuova versione di Sogniario è disponibile!\n Ti preghiamo di aggiornare l'app prima di continuare.", textAlign: TextAlign.justify,),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      context.pop(true);
                    },
                  ),
                ],);
            },
          ));
        }

        bool showChronoBtn, showPsqiAlert;
        (showChronoBtn, showPsqiAlert) = snapshot.data![1] as (bool, bool);

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
                                ...mobileWidgets(context, showChronoBtn, showPsqiAlert)
                              else
                                ...desktopWidgets(context, showChronoBtn, showPsqiAlert),
                              SizedBox(height: screenHeight * .05),
                              IconTextButton(
                                  icon: const Icon(Icons.privacy_tip_outlined),
                                  text: "Info e privacy",
                                  onPressed: () => {
                                        context.goNamed(Routes.infoAndPrivacy.name)
                                      }),
                              if(!kIsWeb)...{
                                SizedBox(height: 80,),
                                IconTextButton(
                                    icon: Icon(Icons.logout),
                                    text: "Esci",
                                    onPressed: exitFunc,
                                  )
                              }
                            ],
                          )))));
      }
    );
  }

  List<Widget> desktopWidgets(BuildContext context, bool showChronoBtn, bool showPsqiAlert) {
    double screenHeight = MediaQuery.of(context).size.height;

    return [
      IconTextButton(
        icon: const Icon(Icons.cloud_upload),
        text: "Racconta un sogno",
        onPressed: () => alertReportOnPressed(context, showChronoBtn, showPsqiAlert, Routes.addDream.name)
      ),
      SizedBox(height: screenHeight * .01),
      IconTextButton(
        icon: const Icon(Icons.rocket_launch),
        text: "I miei sogni",
        onPressed: () => alertReportOnPressed(context, showChronoBtn, showPsqiAlert, Routes.myDreams.name),
      ),
      if(showChronoBtn || showPsqiAlert)...{
        SizedBox(height: screenHeight * .05),
      },
      if(showPsqiAlert)...{
        IconTextButton(
          icon: const Icon(Icons.format_list_bulleted),
          text: "PSQI",
          backgroundColor: Colors.red,
          onPressed: () => context.goNamed(Routes.psqi.name)
        ),
      },
      if(showChronoBtn)...{
        SizedBox(height: screenHeight * .01),
        IconTextButton(
          icon: const Icon(Icons.format_list_bulleted),
          text: "Cronotipo",
          backgroundColor: Colors.red,
          onPressed: () => context.goNamed(Routes.chronotype.name)
        ),
      },
      SizedBox(height: screenHeight * .05),
      IconTextButton(
        icon: const Icon(Icons.person),
        text: "I miei dati",
        onPressed: () => context.goNamed(Routes.generalInfo.name)
      ),
    ];
  }

  List<Widget> mobileWidgets(BuildContext context, bool showChronoBtn, bool showPsqiAlert) {
    double screenHeight = MediaQuery.of(context).size.height;

    return [
      IconTextButton(
          icon: const Icon(Icons.cloud_upload),
          text: "Racconta un sogno",
          onPressed: () => alertReportOnPressed(context, showChronoBtn, showPsqiAlert, Routes.addDream.name)
      ),
      SizedBox(height: screenHeight * .01),
      IconTextButton(
        icon: const Icon(Icons.rocket_launch),
        text: "I miei sogni",
        onPressed: () => alertReportOnPressed(context, showChronoBtn, showPsqiAlert, Routes.myDreams.name),
      ),
      if(showChronoBtn || showPsqiAlert)...{
        SizedBox(height: screenHeight * .05),
      },
      if(showPsqiAlert)...{
        IconTextButton(
          icon: const Icon(Icons.format_list_bulleted),
          text: "PSQI",
          backgroundColor: Colors.red,
          onPressed: () => context.goNamed(Routes.psqi.name)
        ),
      },
      if(showChronoBtn)...{
        SizedBox(height: screenHeight * .01),
        IconTextButton(
          icon: const Icon(Icons.format_list_bulleted),
          text: "Cronotipo",
          backgroundColor: Colors.red,
          onPressed: () => context.goNamed(Routes.chronotype.name)
        ),
      },
      SizedBox(height: screenHeight * .05),
      IconTextButton(
        icon: const Icon(Icons.person),
        text: "I miei dati",
        onPressed: () => context.goNamed(Routes.generalInfo.name)
      ),
    ];
  }
}
