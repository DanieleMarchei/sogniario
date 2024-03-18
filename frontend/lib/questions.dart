import 'package:flutter/material.dart';
import 'package:frontend/inputfield.dart';
import 'package:frontend/pickers.dart';

class MultipleChoiceQuestion extends StatefulWidget{
  
  final String question;
  final List<String> answers;

  
  const MultipleChoiceQuestion(
    {
      super.key,
      required this.question,
      required this.answers
    });
  @override
  State<MultipleChoiceQuestion> createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion>{

  late String selectedAnswer;

  @override
  void initState() {
    super.initState();
    selectedAnswer = widget.answers[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(widget.question),
          ...Iterable<int>.generate(widget.answers.length).map(
                  (int idx) => ListTile(
                    title: Text(widget.answers[idx]),
                    leading: Radio<String>(
                      value: widget.answers[idx],
                      groupValue: selectedAnswer,
                      onChanged: (String? value) {
                        setState(() {
                          selectedAnswer = value!;
                        });
                      }
                    ),
                  ),
                ),
        ],
      )
    );
  }

}



class SelectHourQuestion extends StatefulWidget{
  
  final String question;

  
  const SelectHourQuestion(
    {
      super.key,
      required this.question,
    });
  @override
  State<SelectHourQuestion> createState() => _SelectHourQuestionState();
}

class _SelectHourQuestionState extends State<SelectHourQuestion>{
  late TimeOfDay answer;

  @override
  void initState() {
    super.initState();
    answer = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(widget.question),
          TimeOfDayPickerButton(text: "Ora: ")
        ],
      )
    );
  }

}


class SelectIntQuestion extends StatefulWidget{
  
  final String question;
  final int maxValue;
  
  const SelectIntQuestion(
    {
      super.key,
      required this.question,
      this.maxValue = 120
    });
  @override
  State<SelectIntQuestion> createState() => _SelectIntQuestionState();
}

class _SelectIntQuestionState extends State<SelectIntQuestion>{
  late int answer;

  @override
  void initState() {
    super.initState();
    answer = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(widget.question),
          IntegerPickerButton(text: "Minuti: ", maxValue: widget.maxValue)
        ],
      )
    );
  }

}


class SelectTwoIntsQuestion extends StatefulWidget{
  
  final String question;
  final int maxValue1 = 120;
  final int maxValue2 = 120;
  
  const SelectTwoIntsQuestion(
    {
      super.key,
      required this.question,
    });
  @override
  State<SelectTwoIntsQuestion> createState() => _SelectTwoIntsQuestionState();
}

class _SelectTwoIntsQuestionState extends State<SelectTwoIntsQuestion>{
  late TimeOfDay answer;

  @override
  void initState() {
    super.initState();
    answer = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(widget.question),
          DoubleIntegerPickerButton(text1: "ore", text2: "minuti", maxValue: widget.maxValue1),
        ],
      )
    );
  }

}


class SpecifyIfYesQuestion extends StatefulWidget{
  
  final String question1;
  final String question2;
  final List<String> answers;
  
  const SpecifyIfYesQuestion(
    {
      super.key,
      required this.question1,
      required this.question2,
      required this.answers,
    });

  @override
  State<SpecifyIfYesQuestion> createState() => _SpecifyIfYesQuestionState();
}

class _SpecifyIfYesQuestionState extends State<SpecifyIfYesQuestion>{


  List<String> no_yes = ["No.", "Si."];
  late String _firstQuestionAnswer;
  String _secondQuestionAnswer = '';


  @override
  void initState() {
    super.initState();
    _firstQuestionAnswer = no_yes[0];
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Column(
        children: [
          Text(widget.question1),
          ...Iterable<int>.generate(no_yes.length).map(
                  (int idx) => ListTile(
                    title: Text(no_yes[idx]),
                    leading: Radio<String>(
                      value: no_yes[idx],
                      groupValue: _firstQuestionAnswer,
                      onChanged: (String? value) {
                        setState(() {
                          _firstQuestionAnswer = value!;
                          if (_firstQuestionAnswer == no_yes[1])
                            _secondQuestionAnswer = widget.answers[0];
                          else  
                            _secondQuestionAnswer = "";
                        });
                      }
                    ),
                  ),
                ),
          if (_firstQuestionAnswer == no_yes[1])
          Column(
            children: [
            Text(widget.question1),
            SizedBox(height: 20,),
            InputField(labelText : "Quale?"),
            ...Iterable<int>.generate(widget.answers.length).map(
                              (int idx) => ListTile(
                                title: Text(widget.answers[idx]),
                                leading: Radio<String>(
                                  value: widget.answers[idx],
                                  groupValue: _secondQuestionAnswer,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _secondQuestionAnswer = value!;
                                    });
                                  }
                                ),
                              ),
            )
            ]
          )
          else SizedBox()
        ],
      )
    );
  }

}
