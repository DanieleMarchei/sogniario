import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/utils.dart';

List<String> userList = [
  "XYZK",
  "XKCD",
  "ABCD",
  "ACDC",
  "YYYY",
  "XXXX",
  "YRDFG",
  "CVFFD",
  "QWERTY"
];

class ManageUsers extends StatefulWidget {
  const ManageUsers({
    super.key,
  });

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  String searchQuery = "";

  bool matchUsername(String username){
    if(searchQuery == "") return true;

    return username.toLowerCase().contains(searchQuery.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    print(searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestisci utenti"),
        backgroundColor: Colors.orange,
        actions: [
          Row(
            children: [
              SizedBox(
                width: 250,
                height: 40,
                child: InputField(
                  labelText: "Cerca",
                  onCleared: () {
                    setState(() {
                      searchQuery = "";
                    });
                  },
                  onChanged: (String query) {
                    setState(() {
                      searchQuery = query;
                    });
                  },
                ),
              ),
            ],
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Center(
              child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                      width: min(screenWidth, halfWidthConstraint)),
                  child: ListView(
                    children: [
                      SizedBox(height: screenHeight * .01),
                      ...userList.where((element) => matchUsername(element)).map((e) => UserWidget(username: e,))
                    ],
                  )))),
    );
  }
}

class UserWidget extends StatefulWidget {
  final String username;

  const UserWidget({super.key, required this.username});

  @override
  State<StatefulWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Colors.orange),
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.username),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.visibility),
              tooltip: "Visualizza",
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit),
              tooltip: "Modifica",
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete),
              tooltip: "Elimina",
            ),
          ],
        ));
  }
}
