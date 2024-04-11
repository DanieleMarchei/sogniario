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


class MultipleChoiceQuestion extends QuestionWithDirection with WithInitialValue<int> {
  
  final String question;
  final List<String> answers;

  final void Function(int)? onSelected;
  
  MultipleChoiceQuestion(
    {
      super.key,
      required this.question,
      required this.answers,
      this.onSelected,
      int? initialValue
    }) : super(direction: Axis.vertical, canChangeDirection : false) {
      if(initialValue == null){
        this.initialValue = 0;
      }else{
        this.initialValue = initialValue;
      }
      assert(0 <= this.initialValue && this.initialValue <= (this.answers.length - 1), "initialValue must be between 0 and ${this.answers.length - 1}.");
    }
    
  @override
  State<MultipleChoiceQuestion> createState() => _MultipleChoiceQuestionState();
  
  @override
  late final int initialValue;
  

}

class _MultipleChoiceQuestionState extends QuestionWithDirectionState<MultipleChoiceQuestion>{

  late String selectedAnswer;

  @override
  void initState() {
    super.initState();
    selectedAnswer = widget.answers[widget.initialValue];
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



class SelectHourQuestion extends QuestionWithDirection with WithInitialValue<TimeOfDay>{
  
  final String question;
  final void Function(TimeOfDay)? onSelected;
  
  SelectHourQuestion(
    {
      super.key,
      required this.question,
      @override
      super.direction,
      super.canChangeDirection,
      this.onSelected,
      TimeOfDay? initialValue
    }){
      if(initialValue == null){
        this.initialValue = TimeOfDay.now();
      }else{
        this.initialValue = initialValue;
      }
    }

  @override
  State<SelectHourQuestion> createState() => _SelectHourQuestionState();
  
  @override
  late final TimeOfDay initialValue;
}

class _SelectHourQuestionState extends QuestionWithDirectionState<SelectHourQuestion>{

  late TimeOfDay selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Flex(
      direction: widget.direction,
        children: [
          Text(widget.question),
          widget.direction == Axis.horizontal ? Spacer() : SizedBox(),
          TimeOfDayPickerButton(
            text: "Ora: ",
            onSelectedTimeOfDay: widget.onSelected,
            initialValue: widget.initialValue,
            )
        ],
      );
  }

}


class SelectIntQuestion extends QuestionWithDirection with WithInitialValue<int>{
  
  final String question;
  final String text;
  final int maxValue;
  final int minValue;
  final void Function(int)? onSelected;
  
  @override
  late final int initialValue; 
  
  SelectIntQuestion(
    {
      super.key,
      required this.question,
      required this.text,
      this.minValue = 0,
      this.maxValue = 120,
      super.direction,
      super.canChangeDirection,
      this.onSelected,
      int? initialValue
    }){
      if(initialValue == null){
        this.initialValue = minValue;
      }else{
        this.initialValue = initialValue;
      }
      assert(minValue <= this.initialValue && this.initialValue <= maxValue, "initialValue must be between minValue and maxValue.");
    }

  @override
  State<SelectIntQuestion> createState() => _SelectIntQuestionState();
  
}

class _SelectIntQuestionState extends QuestionWithDirectionState<SelectIntQuestion>{

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Flex(
      direction: widget.direction,
        children: [
          Text(widget.question),
          widget.direction == Axis.horizontal ? Spacer() : SizedBox(),
          IntegerPickerButton(
            text: widget.text,
            minValue: widget.minValue,
            maxValue: widget.maxValue,
            onSelectedInteger: widget.onSelected,
            initialValue: widget.initialValue,
            )
        ],
      );
  }

}


class SelectTwoIntsQuestion extends QuestionWithDirection with WithInitialValue<(int, int)>{
  
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
      this.onSelected,
      (int, int)? initialValue
    }){
      if(initialValue == null){
        this.initialValue = (minValue1, minValue2);
      }else{
        this.initialValue = initialValue;
      }
      assert(minValue1 <= this.initialValue.$1 && this.initialValue.$1 <= maxValue1, "initialValue.\$1 must be between minValue1 and maxValue1.");
      assert(minValue2 <= this.initialValue.$2 && this.initialValue.$2 <= maxValue2, "initialValue.\$2 must be between minValue2 and maxValue2.");
    }

  @override
  State<SelectTwoIntsQuestion> createState() => _SelectTwoIntsQuestionState();
  
  @override
  late final (int, int) initialValue;
}

class _SelectTwoIntsQuestionState extends QuestionWithDirectionState<SelectTwoIntsQuestion>{

  late (int, int) selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
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
            onIntegersSelected: widget.onSelected,
            initialValue: widget.initialValue,
            ),
        ],
      );
  }

}


class SpecifyIfYesQuestion extends QuestionWithDirection with WithInitialValue<(bool, String?, int?)>{
  
  final String question1;
  final String question2;
  final List<String> answers;
  final void Function(bool, String?, int?)? onSelected;
  
  SpecifyIfYesQuestion(
    {
      super.key,
      required this.question1,
      required this.question2,
      required this.answers,
      super.direction,
      super.canChangeDirection = false,
      this.onSelected,
      (bool, String?, int?)? initialValue
    }){
      if(initialValue == null){
        this.initialValue = (false, null, null);
      }else{
        this.initialValue = initialValue;
      }

      assert(!(this.initialValue.$1 == true) || (this.initialValue.$2 != null && this.initialValue.$3 != null), "if initialValue.\$1 is true, then the other two values must be non-null.");
      assert(!(this.initialValue.$1 == false) || (this.initialValue.$2 == null && this.initialValue.$3 == null), "if initialValue.\$1 is false, then the other two values must be null.");

    }

  @override
  State<SpecifyIfYesQuestion> createState() => _SpecifyIfYesQuestionState();
  
  @override
  late final (bool, String?, int?) initialValue;
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
    idxFirstQuestion = widget.initialValue.$1 ? 1 : 0;
    _firstQuestionAnswer = no_yes[idxFirstQuestion];

    _optionalAnswer1 = widget.initialValue.$2;
    idxOptionalAnswer2 = widget.initialValue.$3;
    if(idxOptionalAnswer2 != null){
      _optionalAnswer2 = widget.answers[idxOptionalAnswer2!];
    }
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
                            idxOptionalAnswer2 = 0;
                            _optionalAnswer2 = widget.answers[idxOptionalAnswer2!];
                          }
                          else{
                            _optionalAnswer2 = null;
                            idxOptionalAnswer2 = null;
                          }

                          _optionalAnswer1 = null;

                        });

                        if(widget.onSelected != null){
                          widget.onSelected!(idxFirstQuestion == 1, _optionalAnswer1, idxOptionalAnswer2);
                        } 
                      }
                    ),
                  ),)
                ),
          if (_firstQuestionAnswer == no_yes[1])
          ...[
            SizedBox(height: 10,),
            Flexible(child:InputField(labelText : "Quale?", onChanged: (String newText) {
              setState(() {
                _optionalAnswer1 = newText;
                if(widget.onSelected != null){
                  widget.onSelected!(idxFirstQuestion == 1, _optionalAnswer1, idxOptionalAnswer2);
                } 
              });
            },),),
            SizedBox(height: 10,),
            Flexible(child: Text(widget.question2)),
            SizedBox(height: 10,),
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
                                        widget.onSelected!(idxFirstQuestion == 1, _optionalAnswer1, idxOptionalAnswer2);
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
