import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/pickers.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/utils.dart';
import 'package:go_router/go_router.dart';



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
      ChronoTypeData? chronotype = await getMyChronotype();
      if (chronotype == null){
        context.goNamed(Routes.chronotype.name);
      }else{
        context.goNamed(Routes.homeUser.name);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: min(screenWidth, halfWidthConstraint)),
            child: ListView(
              children: [
                SizedBox(height: screenHeight * .05),
                Text(
                  'Informazioni generali',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                    setState(() {
                      sex = value!;
                    });
                  },
                ),
                SizedBox(height: screenHeight * .025),
                DatePickerButton(
                  text : "Data di nascita: ",
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
}


