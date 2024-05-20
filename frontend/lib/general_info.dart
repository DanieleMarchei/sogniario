import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/api.dart';
import 'package:frontend/decorations.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/pickers.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/utils.dart';
import 'package:go_router/go_router.dart';

final List<String> months = [
  "Gen",
  "Feb",
  "Mar",
  "Apr",
  "Mag",
  "Giu",
  "Lug",
  "Ago",
  "Set",
  "Ott",
  "Nov",
  "Dic",
];

class GeneralInfo extends StatefulWidget {
  const GeneralInfo({Key? key}) : super(key: key);
  @override
  State<GeneralInfo> createState() => _GeneralInfoState();
}

class _GeneralInfoState extends State<GeneralInfo> {
  DateTime? selectedDate;
  Sex? sex;

  void submit() async {
    bool updateDone = await updateMyGeneralInfo(sex!, selectedDate!);
    if(updateDone){
        context.goNamed(Routes.homeUser.name);
    }else{
      Fluttertoast.showToast(
          msg: "Errore: impossibile aggiornare i dati personali.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: getMyGeneralInfo(),
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


        
        DateTime? retreivedBday = snapshot.data!.$1; 
        Sex? retreivedSex = snapshot.data!.$2;

        if(retreivedBday != null){
          retreivedBday = retreivedBday.toLocal();
          selectedDate = DateTime(retreivedBday.year, retreivedBday.month, retreivedBday.day);
        }
        if(retreivedSex != null){
          sex = Sex.values[retreivedSex.id];
        }

        String bdayStr = "Seleziona data";
        if(selectedDate != null){
          selectedDate = selectedDate!.toLocal();
          String month = months[selectedDate!.month - 1];
          bdayStr = "${selectedDate!.day}/${month}/${selectedDate!.year}";
        }

        var homeBtn = doIHaveGeneralInfo() 
          ?  AppBar(
                backgroundColor: Colors.blue,
                title: Text("I miei dati"),
                leading: IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () async {
                    if(retreivedSex != sex || 
                        retreivedBday!.day != selectedDate!.day ||
                        retreivedBday.month != selectedDate!.month ||
                        retreivedBday.year != selectedDate!.year){
                      bool pop = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: Text("Canellare le modifiche?"),
                                        insetPadding: EdgeInsets.all(16),
                                        content: Text("Tutte le modifiche saranno cancellate. Tornare alla schermata iniziale?", textAlign: TextAlign.justify,),
                                        actions: <Widget>[
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
                                        ],);
                                  }
                      );
                      if(pop){
                        context.goNamed(Routes.homeUser.name);
                      }
                    }else{
                      context.goNamed(Routes.homeUser.name);
                    }
                  },
                  tooltip: "Torna alla pagina iniziale",
                ),
              ) 
          : null;

        return ScaffoldWithCircles(
          context: context,
          appBar: homeBtn,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: min(screenWidth, halfWidthConstraint)),
                child: ListView(
                  children: [
                    SizedBox(height: screenHeight * .12),
                    DropdownButtonFormField<Sex>(
                      decoration: InputDecoration(
                        label: Text("Sesso"),
                        helperText: sex == null ? "Seleziona il tuo sesso" : null,
                      ),
                      value: sex,
                      items:
                          Sex.values.map<DropdownMenuItem<Sex>>((Sex sex) {
                        return DropdownMenuItem<Sex>(
                          value: sex,
                          child: Text(sex.label),
                        );
                      }).toList(),
                      onChanged: (Sex? value) {
                          sex = value!;
                      },
                    ),
                    SizedBox(height: screenHeight * .025),
                    DatePickerButton(
                      text : "Data di nascita: ",
                      helpText: bdayStr,
                      onSelectedDate: (DateTime newDate) {
                        selectedDate = newDate;
                      },  
                    ),
                    SizedBox(
                      height: screenHeight * .075,
                    ),
                    FormButton(
                      text: 'Conferma',
                      onPressed: () {
                        if(sex != null && selectedDate != null){
                          submit();
                          return;
                        }
                        if(sex == null){
                          
                        }
                        if(selectedDate == null){
        
                        }
                      },
                    ),
                    SizedBox(
                      height: screenHeight * .15,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}


