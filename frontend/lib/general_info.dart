import 'package:flutter/material.dart';
import 'package:frontend/formbutton.dart';
import 'package:frontend/inputfield.dart';
import 'package:frontend/pickers.dart';

enum Gender {
  female(label: "Femmina"),
  male(label: "Maschio"),
  NOT_SPECIFIED(label: "Non specificato"),
  OTHER(label: "Altro");

  const Gender({required this.label});
  final String label;
}

class GeneralInfo extends StatefulWidget {
  const GeneralInfo({Key? key}) : super(key: key);
  @override
  State<GeneralInfo> createState() => _GeneralInfoState();
}

class _GeneralInfoState extends State<GeneralInfo> {
  DateTime selectedDate = DateTime.now();
  Gender gender = Gender.female;

  void submit() {
    Navigator.pushNamed(context, "/home");
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
              onChanged: (Gender? value) {},
            ),
            SizedBox(height: screenHeight * .025),
            DatePickerButton(text : "Data di nascita: "),
            SizedBox(
              height: screenHeight * .075,
            ),
            FormButton(
              text: 'Accetta',
              onPressed: submit,
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

