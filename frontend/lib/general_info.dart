import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/pickers.dart';
import 'package:frontend/utils.dart';



class GeneralInfo extends StatefulWidget {
  const GeneralInfo({Key? key}) : super(key: key);
  @override
  State<GeneralInfo> createState() => _GeneralInfoState();
}

class _GeneralInfoState extends State<GeneralInfo> {
  DateTime selectedDate = DateTime.now();
  Sex sex = Sex.notSpecified;

  void submit() async {
    bool updateDone = await updateMyGeneralInfo(sex, selectedDate);
    if(updateDone){
      ChronoTypeData? chronotype = await getMyChronotype();
      if (chronotype == null){
        Navigator.pushNamed(context, "/chronotype");
      }else{
        Navigator.pushNamed(context, "/home_user");
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
              decoration: const InputDecoration(
                label: Text("Sesso"),
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
              initialValue: selectedDate,
              onSelectedDate: (DateTime newDate) {
                selectedDate = newDate;
              },  
            ),
            SizedBox(
              height: screenHeight * .075,
            ),
            FormButton(
              text: 'Conferma',
              onPressed: () => submit(),
            ),
            SizedBox(
              height: screenHeight * .15,
            )
          ],
        ),
      ),
    );
  }
}


