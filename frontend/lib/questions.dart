import 'package:flutter/material.dart';
import 'package:frontend/inputfield.dart';
import 'package:frontend/pickers.dart';

class MultipleChoiceQuestion extends StatefulWidget{
  
  final String question;
  final List<String> answers;
  final void Function(int)? onSelected;

  
  const MultipleChoiceQuestion(
    {
      super.key,
      required this.question,
      required this.answers,
      this.onSelected
    });
  @override
  State<MultipleChoiceQuestion> createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> with AutomaticKeepAliveClientMixin{

  late String selectedAnswer;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    selectedAnswer = widget.answers[0];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
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
                        if(widget.onSelected != null) widget.onSelected!(idx);
                      });
                    }
                  ),
                ),
              ),
      ],
    );
  }

}



class SelectHourQuestion extends StatefulWidget{
  
  final String question;
  final void Function(TimeOfDay)? onSelected;


  
  const SelectHourQuestion(
    {
      super.key,
      required this.question,
      this.onSelected
    });
  @override
  State<SelectHourQuestion> createState() => _SelectHourQuestionState();
}

class _SelectHourQuestionState extends State<SelectHourQuestion> with AutomaticKeepAliveClientMixin{
  late TimeOfDay answer;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    answer = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
        children: [
          Text(widget.question),
          TimeOfDayPickerButton(text: "Ora: ", onSelectedTimeOfDay: widget.onSelected,)
        ],
      );
  }

}


class SelectIntQuestion extends StatefulWidget{
  
  final String question;
  final int maxValue;
  final void Function(int)? onSelected;
  
  const SelectIntQuestion(
    {
      super.key,
      required this.question,
      this.maxValue = 120,
      this.onSelected
    });
  @override
  State<SelectIntQuestion> createState() => _SelectIntQuestionState();
}

class _SelectIntQuestionState extends State<SelectIntQuestion> with AutomaticKeepAliveClientMixin{
  late int answer;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    answer = 0;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
        children: [
          Text(widget.question),
          IntegerPickerButton(text: "Minuti: ", maxValue: widget.maxValue, onSelectedInteger: widget.onSelected)
        ],
      );
  }

}


class SelectTwoIntsQuestion extends StatefulWidget{
  
  final String question;
  final int maxValue1 = 120;
  final int maxValue2 = 120;
  final void Function(int, int)? onSelected;
  
  const SelectTwoIntsQuestion(
    {
      super.key,
      required this.question,
      this.onSelected
    });
  @override
  State<SelectTwoIntsQuestion> createState() => _SelectTwoIntsQuestionState();
}

class _SelectTwoIntsQuestionState extends State<SelectTwoIntsQuestion> with AutomaticKeepAliveClientMixin{
  late TimeOfDay answer;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    answer = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
        children: [
          Text(widget.question),
          DoubleIntegerPickerButton(
            text1: "ore", 
            text2: "minuti", 
            maxValue: widget.maxValue1, 
            onIntegersSelected: widget.onSelected,),
        ],
      );
  }

}


class SpecifyIfYesQuestion extends StatefulWidget{
  
  final String question1;
  final String question2;
  final List<String> answers;
  final void Function(int, String?, int?)? onSelected;
  
  const SpecifyIfYesQuestion(
    {
      super.key,
      required this.question1,
      required this.question2,
      required this.answers,
      this.onSelected
    });

  @override
  State<SpecifyIfYesQuestion> createState() => _SpecifyIfYesQuestionState();
}

class _SpecifyIfYesQuestionState extends State<SpecifyIfYesQuestion> with AutomaticKeepAliveClientMixin{


  List<String> no_yes = ["No.", "Si."];
  late String _firstQuestionAnswer;
  late int idxFirstQuestion;
  String? _optionalAnswer1;
  String? _optionalAnswer2;
  int? idxOptionalAnswer2;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _firstQuestionAnswer = no_yes[0];
    idxFirstQuestion = 0;
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);


    return Column(
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
                          idxFirstQuestion = idx;
                          if (_firstQuestionAnswer == no_yes[1]){
                            _optionalAnswer2 = widget.answers[0];
                          }
                          else{
                            _optionalAnswer2 = null;
                            idxOptionalAnswer2 = null;
                          }

                          _optionalAnswer1 = null;

                          if(widget.onSelected != null){
                            widget.onSelected!(idxFirstQuestion, _optionalAnswer1, idxOptionalAnswer2);
                          } 
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
            InputField(labelText : "Quale?", onChanged: (String newText) {
              setState(() {
                _optionalAnswer1 = newText;
                if(widget.onSelected != null){
                  widget.onSelected!(idxFirstQuestion, _optionalAnswer1, idxOptionalAnswer2);
                } 
              });
            },),
            ...Iterable<int>.generate(widget.answers.length).map(
                              (int idx) => ListTile(
                                title: Text(widget.answers[idx]),
                                leading: Radio<String>(
                                  value: widget.answers[idx],
                                  groupValue: _optionalAnswer2,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _optionalAnswer2 = value!;
                                      idxOptionalAnswer2 = idx;
                                      if(widget.onSelected != null){
                                        widget.onSelected!(idxFirstQuestion, _optionalAnswer1, idxOptionalAnswer2);
                                      } 
                                    });
                                  }
                                ),
                              ),
            )
            ]
          )
          else SizedBox()
        ],
      );
  }

}
