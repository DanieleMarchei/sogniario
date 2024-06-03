import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/api.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/pickers.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/utils.dart';
import 'package:go_router/go_router.dart';

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

    bool showMobileLayout = screenWidth < widthConstraint;

    onPressedAddUser() async {
      await showDialog(
          context: context,
          builder: (context) {
            return ManageUserDialog(
              action: ManageUserDialogActions.create,
              showMobileLayout: showMobileLayout,
            );
          });
      setState(() {});
    }

    return FutureBuilder(
      future: getAllUsersOfMyOrganization(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<UserData> users = snapshot.data!;
        users.sort((a, b) {
          return a.username.compareTo(b.username);
        });
        return Scaffold(
          backgroundColor: Colors.orange.shade50,
          floatingActionButton: showMobileLayout
              ? FloatingActionButton(
                  onPressed: onPressedAddUser,
                  tooltip: "Aggiungi utente",
                  child: const Icon(Icons.person_add_alt_1_rounded),
                  // backgroundColor: Colors.orange.shade300,
                  backgroundColor: Colors.white,
                )
              : null,
          appBar: AppBar(
            centerTitle: showMobileLayout,
            title: const Text("Gestisci utenti"),
            backgroundColor: Colors.orange,
            leading: IconButton(
              icon: Icon(Icons.home),
              onPressed: () => context.goNamed(Routes.homeResearcher.name),
              tooltip: "Torna alla pagina iniziale",
            ),
            bottom: showMobileLayout ? PreferredSize(
              preferredSize: Size(100, 30),
              child: Column(
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
                  SizedBox(height: 10,)
                ],
              ),
            ) : null,
            actions: [
              if (!showMobileLayout) ...{
                Row(children: [
                  IconButton(
                    onPressed: onPressedAddUser,
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                    tooltip: "Aggiungi utente",
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ]),
                SizedBox(
                  width: showMobileLayout ? 150 : 250,
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
                const SizedBox(
                  width: 10,
                ),
              },
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
                              .where((user) => matchUsername(user.username))
                              .map((user) => UserCardWidget(
                                    user: user,
                                    onActionPerformed: () {
                                      setState(() {});
                                    },
                                    showMobileLayout: showMobileLayout
                                  )),
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
  final bool showMobileLayout;

  const UserCardWidget({
    super.key,
    required this.user,
    this.onActionPerformed,
    this.showMobileLayout = false});

  @override
  State<StatefulWidget> createState() => _UserCardWidgetState();
}

class _UserCardWidgetState extends State<UserCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.orange,
          boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 10),
            blurRadius: 10,
            spreadRadius: 5
          )],
          borderRadius: BorderRadius.circular(10)
        ),
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: widget.showMobileLayout ? mobileLayout(context) : desktopLayout(context)
    );
  }

  Widget desktopLayout(BuildContext context){
    return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(widget.user.username),
            const Spacer(),
            ...getButtons(context)
          ],
        );
  }

  Widget mobileLayout(BuildContext context){
    return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SelectableText(widget.user.username),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: getButtons(context),
            )
          ],
        );
  }

  List<Widget> getButtons(BuildContext context){
    return [
      IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ManageUserDialog(
                        action: ManageUserDialogActions.visualize,
                        user: widget.user,
                        showMobileLayout: widget.showMobileLayout,
                      );
                    });
              },
              icon: const Icon(Icons.visibility),
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
                        showMobileLayout: widget.showMobileLayout,
                      );
                    });
              },
              icon: const Icon(Icons.edit),
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
                        showMobileLayout: widget.showMobileLayout,
                      );
                    });
              },
              icon: const Icon(Icons.delete),
              tooltip: "Elimina",
            ),
    ];
  }
}

enum ManageUserDialogActions { visualize, edit, create, delete }

class ManageUserDialog extends StatefulWidget {
  final UserData? user;
  final ManageUserDialogActions action;
  final Function? onSubmitted;
  final bool showMobileLayout;

  ManageUserDialog({
    super.key,
    this.user,
    required this.action,
    this.onSubmitted,
    this.showMobileLayout = false
    }) {
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

  String getRandomString(int length){
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    Random rnd = Random.secure();
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  @override
  void initState() {
    super.initState();
    if (widget.action == ManageUserDialogActions.edit ||
        widget.action == ManageUserDialogActions.visualize ||
        widget.action == ManageUserDialogActions.delete) {
      tmpUser = widget.user!.copy();
    } else {
      tmpUser = UserData();
    }

    if (widget.action == ManageUserDialogActions.edit &&
        tmpUser!.birthdate == null) {
      tmpUser!.birthdate = DateTime.now();
    }

    controllerUsername.text = tmpUser!.username;
    controllerUsername.addListener(_onUsernameChanged);
    if (widget.action == ManageUserDialogActions.edit ||
        widget.action == ManageUserDialogActions.create) {
      controllerPassword.text = "";
      controllerPassword.addListener(_onPasswordChanged);
    }

    if(widget.action == ManageUserDialogActions.create){
      controllerUsername.text = getRandomString(8);
      controllerPassword.text = getRandomString(8);
    }
  }

  void _onUsernameChanged() {
    setState(() {
      tmpUser!.username = controllerUsername.text;
    });
  }

  void _onPasswordChanged() {
    setState(() {
      tmpUser!.password = controllerPassword.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.action) {
      case ManageUserDialogActions.create:
        return create(context);

      case ManageUserDialogActions.visualize:
        return visualize(context);

      case ManageUserDialogActions.edit:
        return edit(context);

      case ManageUserDialogActions.delete:
        return delete(context);
    }
  }

  Widget delete(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(16),
      content: Container(
        height: 100,
        child: Column(
          children: [
            Flexible(
              child: Text("Confermi di voler eliminare questo utente?", overflow: TextOverflow.visible,)
            ),
            SizedBox(height: 10,),
            Text(widget.user!.username, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
          ]
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            bool deleted = await deleteUser(widget.user!.id);
            if(!deleted){
              Fluttertoast.showToast(
                msg: "Eliminazione non riuscita.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 12.0
              );
              return;
            }
            if (widget.onSubmitted != null) widget.onSubmitted!();
            Fluttertoast.showToast(
              msg: "Utente cancellato!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 12.0
            );
            if (mounted) context.pop();
          },
          child: const Text("Elimina")),
        TextButton(
          onPressed: () async {
            if (mounted) context.pop();
          },
          child: const Text("Non eliminare"))
      ],
    );
  }

  Widget create(BuildContext context) {

    return SimpleDialog(
      insetPadding: EdgeInsets.all(16),
      title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(widget.showMobileLayout ? "Aggiungi\nutente" : "Aggiungi utente"),
        const Spacer(),
        IconButton(
            onPressed: () {
              context.pop();
            },
            tooltip: "Annulla",
            icon: const Icon(Icons.close))
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
            customAction: () {
              setState(() {
                controllerUsername.text = getRandomString(8);
              });
            },
            customActionIcon: Icon(FontAwesomeIcons.dice, size: 20),
            customActionTooltip: "Genera casuale",
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
            customAction: () {
              setState(() {
                controllerPassword.text = getRandomString(8);
              });
            },
            customActionIcon: Icon(FontAwesomeIcons.dice, size: 20,),
            customActionTooltip: "Genera casuale",
          ),
        ),
        SimpleDialogOption(
            child: FormButton(
          text: "Aggiungi",
          onPressed: (tmpUser!.password.isEmpty || tmpUser!.username.isEmpty) ? null : () async {
            bool added = await addUser(tmpUser!);
            if(!added){
              Fluttertoast.showToast(
                msg: "Impossibile create l'utente.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 12.0
              );
              return;
            }
            if (widget.onSubmitted != null) widget.onSubmitted!();
            Fluttertoast.showToast(
              msg: "Utente creato con successo!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 12.0
            );
            if (mounted) context.pop();
          },
        )),
      ],
    );
  }

  Widget visualize(BuildContext context) {
    return SimpleDialog(
      insetPadding: EdgeInsets.all(16),
      title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        FittedBox(child: Text(tmpUser!.username, style: TextStyle(fontSize: 18),), fit: BoxFit.scaleDown,),
        const Spacer(),
        IconButton(
            onPressed: () {
              context.pop();
            },
            tooltip: "Chiudi",
            icon: const Icon(Icons.close))
      ]),
      children: [
        SimpleDialogOption(
          child: OutlinedButton(
            onPressed: null,
            child: Text(tmpUser!.birthdate == null
                ? "Data di nascita non selezionata"
                : "Data di nascita: ${tmpUser!.birthdate!.day}/${tmpUser!.birthdate!.month}/${tmpUser!.birthdate!.year}"),
          ),
        ),
        SimpleDialogOption(
          child: DropdownButtonFormField<Sex>(
            decoration: const InputDecoration(
              label: Text("Sesso"),
            ),
            value: tmpUser!.sex,
            items: Sex.values.map<DropdownMenuItem<Sex>>((Sex sex) {
              return DropdownMenuItem<Sex>(
                value: sex,
                child: Text(sex.label),
              );
            }).toList(),
            onChanged: null,
          ),
        ),
      ],
    );
  }

  Widget edit(BuildContext context) {
    return SimpleDialog(
      insetPadding: EdgeInsets.all(16),
      title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                FittedBox(child: Text(tmpUser!.username, style: TextStyle(fontSize: 18),), fit: BoxFit.scaleDown,),
        const Spacer(),
        IconButton(
            onPressed: () {
              context.pop();
            },
            tooltip: "Annulla",
            icon: const Icon(Icons.close))
      ]),
      children: [
        SimpleDialogOption(
          child: InputField(
            labelText: "Nuova password",
            enabled: true,
            toggleObscure: true,
            obscureText: true,
            controller: controllerPassword,
            onChanged: (String password) {
              setState(() {
                if(password.isNotEmpty){
                  tmpUser!.password = password;
                }else{
                  tmpUser!.password = widget.user!.password;
                }

              });
            },
          ),
        ),
        SimpleDialogOption(
          child: DatePickerButton(
          text: "Data di nascita: ",
          helpText: "Data non selezionata.",
          onSelectedDate: (DateTime newDate) {
            setState(() {
              tmpUser!.birthdate = newDate;
            });
          },
        )),
        SimpleDialogOption(
          child: DropdownButtonFormField<Sex>(
            decoration: const InputDecoration(
              label: Text("Sesso"),
            ),
            value: tmpUser!.sex,
            items: Sex.values.map<DropdownMenuItem<Sex>>((Sex sex) {
              return DropdownMenuItem<Sex>(
                value: sex,
                child: Text(sex.label),
              );
            }).toList(),
            onChanged: (Sex? newValue) {
              setState(() {
                tmpUser!.sex = newValue;
              });
            },
          ),
        ),
        SimpleDialogOption(
            child: FormButton(
          text: "Modifica",
          onPressed: (widget.user == tmpUser || tmpUser!.password.isEmpty) ? null :() async {
            bool updated = await updateUserPassword(tmpUser!.username, tmpUser!.password);
            if(!updated){
              Fluttertoast.showToast(
                msg: "Modifica non riuscita.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 12.0
              );
              return;
            }
            
            updated = await updateUserGeneralInfo(
                tmpUser!.id, tmpUser!.sex!, tmpUser!.birthdate!);
            if(!updated){
              Fluttertoast.showToast(
                msg: "Modifica non riuscita.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 12.0
              );
              return;
            }
            if (widget.onSubmitted != null) widget.onSubmitted!();
            Fluttertoast.showToast(
              msg: "Modifica effettuata!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 12.0
            );
            if (mounted) context.pop();
          },
        ))
      ],
    );
  }
}
