import 'package:flutter/material.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/pickers.dart';

class QuestionWithDirection extends StatefulWidget{
  Axis direction;
  bool canChangeDirection;

  QuestionWithDirection({
    super.key,
    this.direction = Axis.horizontal,
    this.canChangeDirection = true,
  }){
      if(!canChangeDirection) direction = Axis.vertical;
    }
  
  @override
  State<StatefulWidget> createState() => QuestionWithDirectionState();
  
}
// AutomaticKeepAliveClientMixin prevents the automatic disposal of the widget when 
// the current page of the carousel does not display it
class QuestionWithDirectionState<T extends QuestionWithDirection> extends State<T> with AutomaticKeepAliveClientMixin {
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container();
  }
  
  @override
  bool get wantKeepAlive => true;

}


class MultipleChoiceQuestion extends QuestionWithDirection{
  
  final String question;
  final List<String> answers;

  final void Function(int)? onSelected;

  
  MultipleChoiceQuestion(
    {
      super.key,
      required this.question,
      required this.answers,
      // super.direction,
      // super.canChangeDirection,
      this.onSelected
    }) : super(direction: Axis.vertical, canChangeDirection : false);
    
  @override
  State<MultipleChoiceQuestion> createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends QuestionWithDirectionState<MultipleChoiceQuestion>{

  late String selectedAnswer;

  @override
  void initState() {
    super.initState();
    selectedAnswer = widget.answers[0];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(child: Text(widget.question,),),
        widget.direction == Axis.horizontal ? Spacer() : SizedBox(),
        ...Iterable<int>.generate(widget.answers.length).map(
                (int idx) => Flexible(
                  child: ListTile(
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
                ),),
              ),
      ],
    );
  }

}



class SelectHourQuestion extends QuestionWithDirection{
  
  final String question;
  final void Function(TimeOfDay)? onSelected;
  
  SelectHourQuestion(
    {
      super.key,
      required this.question,
      @override
      super.direction,
      super.canChangeDirection,
      this.onSelected
    });

  @override
  State<SelectHourQuestion> createState() => _SelectHourQuestionState();
}

class _SelectHourQuestionState extends QuestionWithDirectionState<SelectHourQuestion>{
  late TimeOfDay answer;

  @override
  void initState() {
    super.initState();
    answer = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Flex(
      direction: widget.direction,
        children: [
          Text(widget.question),
          widget.direction == Axis.horizontal ? Spacer() : SizedBox(),
          TimeOfDayPickerButton(text: "Ora: ", onSelectedTimeOfDay: widget.onSelected,)
        ],
      );
  }

}


class SelectIntQuestion extends QuestionWithDirection{
  
  final String question;
  final String text;
  final int maxValue;
  final void Function(int)? onSelected;
  
  SelectIntQuestion(
    {
      super.key,
      required this.question,
      required this.text,
      this.maxValue = 120,
      super.direction,
      super.canChangeDirection,
      this.onSelected
    });
  @override
  State<SelectIntQuestion> createState() => _SelectIntQuestionState();
}

class _SelectIntQuestionState extends QuestionWithDirectionState<SelectIntQuestion>{
  late int answer;

  @override
  void initState() {
    super.initState();
    answer = 0;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Flex(
      direction: widget.direction,
        children: [
          Text(widget.question),
          widget.direction == Axis.horizontal ? Spacer() : SizedBox(),
          IntegerPickerButton(text: widget.text, maxValue: widget.maxValue, onSelectedInteger: widget.onSelected)
        ],
      );
  }

}


class SelectTwoIntsQuestion extends QuestionWithDirection{
  
  final String question;
  final String text1;
  final String text2;
  final int minValue1;
  final int maxValue1;
  final int minValue2;
  final int maxValue2;
  final int increment1;
  final int increment2;

  final void Function(int, int)? onSelected;
  
  SelectTwoIntsQuestion(
    {
      super.key,
      required this.question,
      required this.text1,
      required this.text2,
      this.minValue1 = 0,
      this.maxValue1 = 120,
      this.minValue2 = 0,
      this.maxValue2 = 120,
      this.increment1 = 1,
      this.increment2 = 1,
      super.direction,
      super.canChangeDirection,
      this.onSelected
    });
  @override
  State<SelectTwoIntsQuestion> createState() => _SelectTwoIntsQuestionState();
}

class _SelectTwoIntsQuestionState extends QuestionWithDirectionState<SelectTwoIntsQuestion>{
  late TimeOfDay answer;

  @override
  void initState() {
    super.initState();
    answer = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Flex(
      direction: widget.direction,
        children: [
          Text(widget.question),
          widget.direction == Axis.horizontal ? Spacer() : SizedBox(),
          DoubleIntegerPickerButton(
            text1: widget.text1, 
            text2: widget.text2, 
            minValue1: widget.minValue1, 
            minValue2: widget.minValue2, 
            maxValue1: widget.maxValue1, 
            maxValue2: widget.maxValue2, 
            increment1: widget.increment1,
            increment2: widget.increment2,
            onIntegersSelected: widget.onSelected,),
        ],
      );
  }

}


class SpecifyIfYesQuestion extends QuestionWithDirection{
  
  final String question1;
  final String question2;
  final List<String> answers;
  final void Function(int, String?, int?)? onSelected;
  
  SpecifyIfYesQuestion(
    {
      super.key,
      required this.question1,
      required this.question2,
      required this.answers,
      super.direction,
      super.canChangeDirection = false,
      this.onSelected
    });

  @override
  State<SpecifyIfYesQuestion> createState() => _SpecifyIfYesQuestionState();
}

class _SpecifyIfYesQuestionState extends QuestionWithDirectionState<SpecifyIfYesQuestion>{


  List<String> no_yes = ["No.", "Si."];
  late String _firstQuestionAnswer;
  late int idxFirstQuestion;
  String? _optionalAnswer1;
  String? _optionalAnswer2;
  int? idxOptionalAnswer2;

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
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(child: Text(widget.question1)),
          widget.direction == Axis.horizontal ? Spacer() : SizedBox(),
          ...Iterable<int>.generate(no_yes.length).map(
                  (int idx) => Flexible(
                    child: ListTile(
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
                  ),)
                ),
          if (_firstQuestionAnswer == no_yes[1])
          ...[
            Flexible(child: Text(widget.question1)),
            SizedBox(height: 20,),
            Flexible(child:InputField(labelText : "Quale?", onChanged: (String newText) {
              setState(() {
                _optionalAnswer1 = newText;
                if(widget.onSelected != null){
                  widget.onSelected!(idxFirstQuestion, _optionalAnswer1, idxOptionalAnswer2);
                } 
              });
            },),),
            ...Iterable<int>.generate(widget.answers.length).map(
                              (int idx) => Flexible( child: ListTile(
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
                              ),)
            )
            ]
          else SizedBox()
        ],
      );
  }

}
