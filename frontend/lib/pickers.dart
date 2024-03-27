import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_picker/picker.dart';

mixin WithInitialValue<T> {
  abstract T initialValue;
}

class DatePickerButton extends StatefulWidget with WithInitialValue<DateTime> {

  DatePickerButton({
    super.key,
    required this.text,
    this.onSelectedDate,
    DateTime? initialValue,
    }){
      if(initialValue == null){
        this.initialValue = DateTime.now();
      }else{
        this.initialValue = initialValue;

      }
      
    }

  final String text;
  final void Function(DateTime)? onSelectedDate;

  @override
  State<DatePickerButton> createState() => _DatePickerState();
  
  @override
  late final DateTime initialValue;
}

class _DatePickerState extends State<DatePickerButton> {

  late DateTime selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Picker(
              adapter: DateTimePickerAdapter(
                months: ["Gen", "Feb", "Mar", "Apr", "Mag", "Giu", "Lug", "Ago", "Set", "Ott", "Nov", "Dic"],
                maxValue: DateTime.now(),
                type: PickerDateTimeType.kDMY,
                value: widget.initialValue
              ),
              changeToFirst: false,
              hideHeader: true,
              confirmText: 'Conferma',
              cancelText: "Cancella",
              title: Text("Data di nascita"),
              backgroundColor: Color.fromARGB(255, 238, 232, 244),
              onConfirm: (Picker picker, List value) {
                int day = value[0] + 1;
                int month = value[1] + 1;
                int year = value[2] + (picker.adapter as DateTimePickerAdapter).yearBegin;
                DateTime selected = DateTime(year, month, day);
                setState(() {
                  selectedValue = selected;
                  if(widget.onSelectedDate != null) widget.onSelectedDate!(selectedValue);
                });
              },
          ).showDialog(context);
      },
      child: Text(
          '${widget.text}${selectedValue.day}/${selectedValue.month}/${selectedValue.year}'),
    );
  }

}

class TimeOfDayPickerButton extends StatefulWidget with WithInitialValue<TimeOfDay> {
  TimeOfDayPickerButton({
    super.key,
    required this.text,
    this.onSelectedTimeOfDay,
    TimeOfDay? initialValue
    }){
      if(initialValue == null){
        this.initialValue = TimeOfDay.now();
      }
      else{
        this.initialValue = initialValue;
      }
    }

  final String text;
  final void Function(TimeOfDay)? onSelectedTimeOfDay;
  
  @override
  late final TimeOfDay initialValue;

  @override
  State<TimeOfDayPickerButton> createState() => _TimeOfDayState();
}

class _TimeOfDayState extends State<TimeOfDayPickerButton>{

  late TimeOfDay selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }


  String timeOfDaytoString(TimeOfDay tod) {
    String addLeadingZeroIfNeeded(int value) {
      if (value < 10) {
        return '0$value';
      }
      return value.toString();
    }

    final String hourLabel = addLeadingZeroIfNeeded(tod.hour);
    final String minuteLabel = addLeadingZeroIfNeeded(tod.minute);

    return "${hourLabel}:${minuteLabel}";
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        TimeOfDay? selected = await showTimePicker(context: context, 
          initialTime: widget.initialValue,
          cancelText: "Cancella",
          confirmText: "Conferma",
          initialEntryMode: TimePickerEntryMode.dial,
          hourLabelText: "Ore",
          minuteLabelText: "Minuti",
          errorInvalidText: "Orario non valido",
          helpText: "Seleziona un orario",
        );
        if(selected != null){
          setState(() {
            selectedValue = selected;
          });
        }
      },
      child: Text('${widget.text}${timeOfDaytoString(selectedValue)}'),
    );
  }
}

class IntegerPickerButton extends StatefulWidget with WithInitialValue<int> {
  IntegerPickerButton({
    super.key,
    required this.text,
    this.minValue = 0,
    this.maxValue = 120,
    this.increment = 1,
    this.onSelectedInteger,
    int? initialValue
    }){
      if(initialValue == null){
        this.initialValue = minValue;
      }else{
        this.initialValue = initialValue;
      }
      assert(minValue <= this.initialValue && this.initialValue <= maxValue, "initialValue must be between minValue and maxValue.");
    }

  final String text;
  final int minValue;
  final int maxValue;
  final int increment;
  final void Function(int)? onSelectedInteger;

  @override
  State<IntegerPickerButton> createState() => _IntegerPickerButtonState();
  
  @override
  late final int initialValue;
}

class _IntegerPickerButtonState extends State<IntegerPickerButton> {

  late int selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Picker(
              adapter: PickerDataAdapter<String>(
                  pickerData: [
                    List.generate((widget.maxValue - widget.minValue) ~/ widget.increment + 1, (index) => index*(widget.increment) + widget.minValue),
                  ],
                  isArray: true
              ),
              changeToFirst: false,
              hideHeader: true,
              confirmText: 'Conferma',
              cancelText: "Cancella",
              title: Text("Minuti"),
              backgroundColor: Color.fromARGB(255, 238, 232, 244),
              onConfirm: (Picker picker, List value) {
                setState(() {
                  selectedValue = int.parse(picker.getSelectedValues()[0]);
                  if(widget.onSelectedInteger != null) widget.onSelectedInteger!(selectedValue);
                });
              },
          ).showDialog(context);
      },
      child: Text(
          '${widget.text}${selectedValue}'),
    );
  }
}

class DoubleIntegerPickerButton extends StatefulWidget with WithInitialValue<(int, int)> {
  DoubleIntegerPickerButton({
    super.key,
    required this.text1,
    required this.text2,
    this.minValue1 = 0,
    this.maxValue1 = 100,
    this.minValue2 = 0,
    this.maxValue2 = 100,
    this.increment1 = 1,
    this.increment2 = 1,
    this.onIntegersSelected,
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
  final String text1;
  final String text2;
  final int minValue1;
  final int maxValue1;
  final int minValue2;
  final int maxValue2;
  final int increment1;
  final int increment2;
  final void Function(int, int)? onIntegersSelected;

  @override
  State<DoubleIntegerPickerButton> createState() => _DoubleIntegerPickerButtonState();
  
  @override
  late final (int, int) initialValue;
}


class _DoubleIntegerPickerButtonState extends State<DoubleIntegerPickerButton> {

  late int selectedValue1;
  late int selectedValue2;

  @override
  void initState() {
    super.initState();
    selectedValue1 = widget.initialValue.$1;
    selectedValue2 = widget.initialValue.$2;
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.increment);
    return OutlinedButton(
      onPressed: () {
        Picker(
              adapter: PickerDataAdapter<String>(
                  pickerData: [
                    List.generate((widget.maxValue1 - widget.minValue1) ~/ widget.increment1 + 1, (index) => index*(widget.increment1) + widget.minValue1),
                    List.generate((widget.maxValue2 - widget.minValue2) ~/ widget.increment2 + 1, (index) => index*(widget.increment2) + widget.minValue2),
                  ],
                  isArray: true
              ),
              changeToFirst: false,
              hideHeader: true,
              confirmText: 'Conferma',
              cancelText: "Cancella",
              title: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [ Text('Ore'), Text(':'), Text('Minuti') ]
              ),
              backgroundColor: Color.fromARGB(255, 238, 232, 244),
              onConfirm: (Picker picker, List value) {
                setState(() {
                  selectedValue1 = int.parse(picker.getSelectedValues()[0]);
                  selectedValue2 = int.parse(picker.getSelectedValues()[1]);
                  if(widget.onIntegersSelected != null) widget.onIntegersSelected!(selectedValue1, selectedValue2);
                });
              },
          ).showDialog(context);
      },
      child: Text(
          '${selectedValue1} ${widget.text1} e ${selectedValue2} ${widget.text2}'),
    );
  }
}