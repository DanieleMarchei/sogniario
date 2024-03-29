import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/pickers.dart';
import 'package:frontend/utils.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({
    super.key,
  });

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  String searchQuery = "";

  bool matchUsername(String username) {
    if (searchQuery == "") return true;

    return username.toLowerCase().contains(searchQuery.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: getAllUsers(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        List<UserData> users = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text("Gestisci utenti"),
            backgroundColor: Colors.orange,
            actions: [
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return ManageUserDialog(
                              action: ManageUserDialogActions.create,
                            );
                          });
                      setState(() {});
                    },
                    icon: Icon(Icons.person_add_alt_1_rounded),
                    tooltip: "Aggiungi utente",
                  ),
                  SizedBox(
                    width: 10,
                  ),
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
                  SizedBox(
                    width: 10,
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
                          ...users
                              .where((user) =>
                                  matchUsername(user.username))
                              .map((user) => UserCardWidget(user: user, onActionPerformed: () {
                                setState(() {});
                              },)),
                        ],
                      )))),
        );
      },
    );
  }
}

class UserCardWidget extends StatefulWidget {
  final UserData user;
  final Function? onActionPerformed;

  const UserCardWidget({super.key, required this.user, this.onActionPerformed});

  @override
  State<StatefulWidget> createState() => _UserCardWidgetState();
}

class _UserCardWidgetState extends State<UserCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Colors.orange),
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.user.username),
            Spacer(),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ManageUserDialog(
                        action: ManageUserDialogActions.visualize,
                        user: widget.user,
                      );
                    });
              },
              icon: Icon(Icons.visibility),
              tooltip: "Visualizza",
            ),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ManageUserDialog(
                        action: ManageUserDialogActions.edit,
                        user: widget.user,
                        onSubmitted: widget.onActionPerformed,
                      );
                    });
              },
              icon: Icon(Icons.edit),
              tooltip: "Modifica",
            ),
            IconButton(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return ManageUserDialog(
                        action: ManageUserDialogActions.delete,
                        user: widget.user,
                        onSubmitted: widget.onActionPerformed,
                      );
                    });
              },
              icon: Icon(Icons.delete),
              tooltip: "Elimina",
            ),
          ],
        ));
  }
}

enum ManageUserDialogActions { visualize, edit, create, delete }

class ManageUserDialog extends StatefulWidget {
  final UserData? user;
  final ManageUserDialogActions action;
  final Function? onSubmitted;

  ManageUserDialog({super.key, this.user, required this.action, this.onSubmitted}) {
    assert(
        !(action == ManageUserDialogActions.edit ||
          action == ManageUserDialogActions.visualize ||
          action == ManageUserDialogActions.delete) ||
            user != null,
        "userId can be null only during creation.");
  }

  @override
  State<ManageUserDialog> createState() => _ManageUserDialogState();
}

class _ManageUserDialogState extends State<ManageUserDialog> {

  late UserData? tmpUser;
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.action == ManageUserDialogActions.edit ||
          widget.action == ManageUserDialogActions.visualize ||
          widget.action == ManageUserDialogActions.delete){
      tmpUser = widget.user!;
    }
    else{
      tmpUser = UserData();
    }
    controllerUsername.text = tmpUser!.username;
    controllerUsername.addListener(_onUsernameChanged);
    controllerPassword.text = tmpUser!.password;
    controllerPassword.addListener(_onPasswordChanged);
  }

  void _onUsernameChanged(){
    setState(() {
      tmpUser!.username = controllerUsername.text;
    });
  }
  
  void _onPasswordChanged(){
    setState(() {
      tmpUser!.password = controllerPassword.text;
    });
  }


  @override
  Widget build(BuildContext context) {
    switch (widget.action) {
      case ManageUserDialogActions.create:
        return create(context);
      
      case ManageUserDialogActions.edit:
      case ManageUserDialogActions.visualize:
      return visualizeOrEdit(context);

      case ManageUserDialogActions.delete:
      return delete(context);
      
    }

  }

  Widget delete(BuildContext context){
    return AlertDialog(
      content: Text("Confermi di voler eliminare l'utente ${widget.user!.username}?"),
      actions: [
        TextButton(onPressed: () async {
          await deleteUser(widget.user!.id);
          if(widget.onSubmitted != null) widget.onSubmitted!();
          if(mounted) Navigator.pop(context);
        }, child: Text("Cancella"))
      ],
    );
  }

  Widget create(BuildContext context){
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    Random rnd = Random.secure();

    String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

    return SimpleDialog(
            title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text("Aggiungi utente"),
              Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  tooltip: "Annulla",
                  icon: Icon(Icons.close))
            ]),
            children: [
              SimpleDialogOption(
                child: InputField(
                  controller: controllerUsername,
                  labelText: "Username",
                  text: tmpUser!.username,
                  onChanged: (String username) {
                    setState(() {
                      tmpUser!.username = username;
                    });
                  },
                ),
              ),
              SimpleDialogOption(
                child: InputField(
                  controller: controllerPassword,
                  labelText: "Password",
                  text: tmpUser!.password,
                  onChanged: (String password) {
                    setState(() {
                      tmpUser!.password = password;
                    });
                  },
                ),
              ),
              SimpleDialogOption(
                child: FormButton(
                  text: "Genera casuale",
                  onPressed: () {
                    controllerUsername.text = getRandomString(8);
                    controllerPassword.text = getRandomString(8);
                  },
                  )
              ),
              SimpleDialogOption(
                child: FormButton(
                  text: "Aggiungi",
                  onPressed: () async {
                    await addUser(tmpUser!);
                    if(widget.onSubmitted != null) widget.onSubmitted!();
                    if(mounted) Navigator.pop(context);
                  },
                  )
              ),
            ],
          );
  }

  Widget visualizeOrEdit(BuildContext context) {
          
          return SimpleDialog(
            title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(tmpUser!.username),
              Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  tooltip: "Annulla",
                  icon: Icon(Icons.close))
            ]),
            children: [
              SimpleDialogOption(
                child: InputField(
                  labelText: "Password",
                  text: tmpUser!.password,
                  enabled: widget.action == ManageUserDialogActions.edit,
                ),
              ),
              SimpleDialogOption(
                child: DatePickerButton(
                  initialValue: tmpUser!.birthdate!,
                  text: "Data di nascita: ",
                ),
              ),
              SimpleDialogOption(
                child: DropdownButtonFormField<Gender>(
                  decoration: const InputDecoration(
                    label: Text("Sesso"),
                  ),
                  value: tmpUser!.gender,
                  items: Gender.values
                      .map<DropdownMenuItem<Gender>>((Gender gender) {
                    return DropdownMenuItem<Gender>(
                      value: gender,
                      child: Text(gender.label),
                    );
                  }).toList(),
                  onChanged: null,
                ),
              ),
              if(widget.action == ManageUserDialogActions.edit)...{
                SimpleDialogOption(
                child: FormButton(
                  text: "Modifica",
                  onPressed: () async {
                    await addUser(tmpUser!);
                    if(widget.onSubmitted != null) widget.onSubmitted!();
                    if(mounted) Navigator.pop(context);
                  },
                  )
                )
              }
              
            ],
          );
  }
}
