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
  Gender gender = Gender.notSpecified;

  void submit(int id) async {
    bool updateDone = await updateUserGeneralInfo(id, gender, selectedDate);
    if(updateDone){
      Navigator.pushNamed(context, "/home_user", arguments: {"id": id});
    }
  }

  @override
  Widget build(BuildContext context) {

    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    int id = arguments["id"];

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
            DropdownButtonFormField<Gender>(
              decoration: const InputDecoration(
                label: Text("Sesso"),
              ),
              value: gender,
              items:
                  Gender.values.map<DropdownMenuItem<Gender>>((Gender gender) {
                return DropdownMenuItem<Gender>(
                  value: gender,
                  child: Text(gender.label),
                );
              }).toList(),
              onChanged: (Gender? value) {
                setState(() {
                  gender = value!;
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
              onPressed: () => submit(id),
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


