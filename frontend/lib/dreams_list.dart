import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/utils.dart';

class DreamsList extends StatefulWidget {
  @override
  State<DreamsList> createState() => _DreamsListState();
}

class _DreamsListState extends State<DreamsList> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool showMobileLayout = screenWidth < widthConstraint;

    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    String jwt = arguments["jwt"];

    return FutureBuilder(
      future: getAllDreams(jwt),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        List<DreamData> dreams = snapshot.data!;

        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: Text("I miei sogni"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                  child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    width: min(screenWidth, widthConstraint)),
                child: ListView(
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
