import 'dart:math';

import 'package:flutter/material.dart';
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
        dreams = dreams.where((d) => d.deleted == false).toList();

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

    Color color = switch (dream.type) {
      DreamType.dreamed => Colors.blue.shade100,

      DreamType.notDreamed => Colors.green.shade100,
      
      DreamType.dontRemember => Colors.yellow.shade100,
    };

    String day = "${dream.createdAt!.day}/${dream.createdAt!.month}/${dream.createdAt!.year}";
    String min = "${dream.createdAt!.minute}";
    if (dream.createdAt!.minute < 10) min = "0" + min;
    String time = "${dream.createdAt!.hour}:${min}";

    return Card(
      color: color,
      child: ExpansionTile(
        title: Text(
          "${day} - ${time}"
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              dream.type == DreamType.dreamed ? dream.dreamText! : dream.type.text,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
