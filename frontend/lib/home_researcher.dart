import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/decorations.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/utils.dart';
import 'package:go_router/go_router.dart';

class HomeResearcher extends StatelessWidget {
  const HomeResearcher({super.key});

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var exitFunc = () async {
      deleteJwt();
      context.goNamed(Routes.login.name);
    };

    return FutureBuilder(
        future: getMyResearcher(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          UserData user = snapshot.data!;

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
                              Text(
                                'Sogniario \n${user.organizationName}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if(kIsWeb)...{
                                Spacer(),
                                IconTextButton(
                                  icon: Icon(Icons.logout),
                                  text: "Esci",
                                  onPressed: exitFunc
                                )
                              }
                            ]),
                            IconTextButton(
                                icon: const Icon(Icons.groups),
                                text: "Gestisci utenti",
                                onPressed: () => context.goNamed(Routes.manageUsers.name)),
                            SizedBox(height: screenHeight * .01),
                            IconTextButton(
                                icon: const Icon(Icons.download),
                                text: "Scarica il database",
                                onPressed: () async {
                                  if (kIsWeb) {
                                    return await downloadDatabaseDesktop();
                                  }

                                  File file;
                                  MobileDBDownloadState state;
                                  (file, state) = (await downloadDatabaseMobile())!;
                                  switch (state) {
                                    case MobileDBDownloadState.downloadFinished:
                                      await showAlert(context, file, state);
                                      break;

                                    case MobileDBDownloadState
                                          .fileAlreadyExists:
                                      bool overwriteFile = await showAlert(
                                              context, file, state) ??
                                          false;
                                      if (overwriteFile) {
                                        state = (await downloadDatabaseMobileConfirmed(file))!;
                                        await showAlert(context, file, state);
                                      }
                                      break;

                                    case MobileDBDownloadState.downloadFailed:
                                      await showAlert(context, file, state);
                                      break;
                                  }
                                }),
                            if(!kIsWeb)...{
                              SizedBox(height: 100,),
                              IconTextButton(
                                  icon: Icon(Icons.logout),
                                  text: "Esci",
                                  onPressed: exitFunc
                                )
                            }
                          ],
                        )))),
          );
        });
  }

  Future<bool?> showAlert(
      BuildContext context, File file, MobileDBDownloadState state) async {
    late String title;
    late String content;
    late String actionsLbl;
    var actionsToShow = {
      "yes_no": <Widget>[
        TextButton(
          child: const Text('Si'),
          onPressed: () {
            context.pop(true);
          },
        ),
        TextButton(
          child: const Text('No'),
          onPressed: () {
            context.pop(false);
          },
        ),
      ],
      "ok": <Widget>[
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            context.pop();
          },
        ),
      ],
    };

    switch (state) {
      case MobileDBDownloadState.downloadFinished:
        title = "Download effettuato!";
        content = "Database scaricato in ${file.path}.";
        actionsLbl = "ok";
        break;

      case MobileDBDownloadState.fileAlreadyExists:
        title = "Sovrascrivere il file?";
        String fileName = file.uri.pathSegments.last;
        content =
            "Esiste già un file chiamato \"$fileName\" in ${file.parent.path}.";
        actionsLbl = "yes_no";
        break;

      case MobileDBDownloadState.downloadFailed:
        title = "Download fallito!";
        content = "C'è stato un errore durante la preparazione del database.";
        actionsLbl = "ok";
        break;
    }

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: actionsToShow[actionsLbl]);
      },
    );
  }
}
