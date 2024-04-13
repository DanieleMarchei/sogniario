import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_picker/picker.dart';
import 'package:frontend/utils.dart';

class DatePickerButton extends StatefulWidget {

  DatePickerButton({
    super.key,
    required this.text,
    this.onSelectedDate,
    this.helpText = "Seleziona data"
  });

  final String text;
  final String helpText;
  final void Function(DateTime)? onSelectedDate;

  @override
  State<DatePickerButton> createState() => _DatePickerState();
  
}

class _DatePickerState extends State<DatePickerButton> {

  DateTime? selectedValue;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Picker(
              adapter: DateTimePickerAdapter(
                months: ["Gen", "Feb", "Mar", "Apr", "Mag", "Giu", "Lug", "Ago", "Set", "Ott", "Nov", "Dic"],
                maxValue: DateTime.now(),
                type: PickerDateTimeType.kYMD,
              ),
              changeToFirst: false,
              hideHeader: true,
              confirmText: 'Conferma',
              cancelText: "Cancella",
              title: Text("Data di nascita"),
              backgroundColor: Color.fromARGB(255, 238, 232, 244),
              onConfirm: (Picker picker, List value) {
                int day = value[2] + 1;
                int month = value[1] + 1;
                int year = value[0] + (picker.adapter as DateTimePickerAdapter).yearBegin;
                DateTime selected = DateTime(year, month, day);
                setState(() {
                  selectedValue = selected;
                });
                if(widget.onSelectedDate != null) widget.onSelectedDate!(selected);
              },
          ).showDialog(context);
      },
      child: Text(
        selectedValue != null 
        ? '${widget.text}${selectedValue!.day}/${selectedValue!.month}/${selectedValue!.year}'
        : '${widget.text}${widget.helpText}'
      ),
    );
  }

}

class TimeOfDayPickerButton extends StatefulWidget {
  TimeOfDayPickerButton({
    super.key,
    required this.text,
    this.onSelectedTimeOfDay,
    this.helpText = "Seleziona un orario"
  });

  final String text;
  final String helpText;
  final void Function(TimeOfDay)? onSelectedTimeOfDay;
  
  @override
  State<TimeOfDayPickerButton> createState() => _TimeOfDayState();
}

class _TimeOfDayState extends State<TimeOfDayPickerButton>{

  TimeOfDay? selectedValue;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        TimeOfDay? selected = await showTimePicker(context: context, 
          initialTime: TimeOfDay.now(),
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
          if(widget.onSelectedTimeOfDay != null) widget.onSelectedTimeOfDay!(selected);
        }
      },
      child: Text(
        selectedValue != null
        ? '${widget.text}${timeOfDaytoString(selectedValue!)}'
        : '${widget.text}${widget.helpText}'
      ),
    );
  }
}

class IntegerPickerButton extends StatefulWidget {
  IntegerPickerButton({
    super.key,
    required this.text,
    this.minValue = 0,
    this.maxValue = 120,
    this.increment = 1,
    this.onSelectedInteger,
    this.helpText = "Seleziona"
  });

  final String text;
  final String helpText;
  final int minValue;
  final int maxValue;
  final int increment;
  final void Function(int)? onSelectedInteger;

  @override
  State<IntegerPickerButton> createState() => _IntegerPickerButtonState();
  
}

class _IntegerPickerButtonState extends State<IntegerPickerButton> {

  int? selectedValue;

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
                });
                if(widget.onSelectedInteger != null) widget.onSelectedInteger!(selectedValue!);
              },
          ).showDialog(context);
      },
      child: Text(
        selectedValue != null
        ? '${widget.text}${selectedValue}'
        : '${widget.helpText}'
        ),
    );
  }
}

class DoubleIntegerPickerButton extends StatefulWidget {
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
    this.helpText = "Seleziona"
    });

  final String text1;
  final String text2;
  final String helpText;
  final int minValue1;
  final int maxValue1;
  final int minValue2;
  final int maxValue2;
  final int increment1;
  final int increment2;
  final void Function(int, int)? onIntegersSelected;

  @override
  State<DoubleIntegerPickerButton> createState() => _DoubleIntegerPickerButtonState();
  
}


class _DoubleIntegerPickerButtonState extends State<DoubleIntegerPickerButton> {

  int? selectedValue1;
  int? selectedValue2;

  @override
  Widget build(BuildContext context) {
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
                });
                if(widget.onIntegersSelected != null) widget.onIntegersSelected!(selectedValue1!, selectedValue2!);
              },
          ).showDialog(context);
      },
      child: Text(
          (selectedValue1 == null) || (selectedValue2 == null) 
          ? '${selectedValue1} ${widget.text1} e ${selectedValue2} ${widget.text2}'
          : '${widget.helpText}'
        ),
    );
  }
}