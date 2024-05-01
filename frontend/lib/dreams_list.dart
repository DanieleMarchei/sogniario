import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/api.dart';
import 'package:frontend/decorations.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/utils.dart';
import 'package:go_router/go_router.dart';

class DreamsList extends StatefulWidget {
  @override
  State<DreamsList> createState() => _DreamsListState();
}

class _DreamsListState extends State<DreamsList> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool showMobileLayout = screenWidth < widthConstraint;

    return FutureBuilder(
      future: getMyDreams(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        List<DreamData> dreams = snapshot.data!;

        return ScaffoldWithCircles(
            context: context,
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: Text("I miei sogni"),
              leading: IconButton(
                icon: Icon(Icons.home),
                onPressed: () => context.goNamed(Routes.homeUser.name),
                tooltip: "Torna alla pagina iniziale",
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                  child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    width: min(screenWidth, widthConstraint)),
                child: dreams.length == 0
                    ? Column(
                        children: [
                          Text("Non hai ancora registrato nessun sogno."),
                          SizedBox(
                            height: 10,
                          ),
                          IconTextButton(
                            icon: Icon(Icons.cloud_upload),
                            text: "Racconta un sogno!",
                            onPressed: () {
                              context.goNamed(Routes.addDream.name);
                            },
                          )
                        ],
                      )
                    : ListView(
                        children: List.generate(dreams.length, (index) {
                        DreamData dream = dreams[index];
                        return DreamCard(dream: dream);
                      })),
              )),
            ));
      },
    );
  }
}

class DreamCard extends StatelessWidget {
  final DreamData dream;

  const DreamCard({
    super.key,
    required this.dream,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade100,
      child: ExpansionTile(
        title: Text(
          "${dream.createdAt!.day}/${dream.createdAt!.month}/${dream.createdAt!.year}",
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              dream.dreamText,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
