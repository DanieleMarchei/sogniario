import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

// from: https://api.flutter.dev/flutter/material/showDatePicker.html
class DatePickerButton extends StatefulWidget {

  const DatePickerButton({
    super.key,
    this.restorationId,
    required this.text,
    this.onSelectedDate,
    });

  final String? restorationId;
  final String text;
  final void Function(DateTime)? onSelectedDate;

  @override
  State<DatePickerButton> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePickerButton> with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(BuildContext context, Object? arguments) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          cancelText: "Cancella",
          confirmText: "Conferma",
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(_restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        if(widget.onSelectedDate != null) widget.onSelectedDate!(newSelectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        _restorableDatePickerRouteFuture.present();
      },
      child: Text(
          '${widget.text}${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
    );
  }
}

class TimeOfDayPickerButton extends StatefulWidget {
  const TimeOfDayPickerButton({
    super.key,
    this.restorationId,
    required this.text,
    this.onSelectedTimeOfDay,
    });

  final String? restorationId;
  final String text;
  final void Function(TimeOfDay)? onSelectedTimeOfDay;

  @override
  State<TimeOfDayPickerButton> createState() => _TimeOfDayState();
}

class _TimeOfDayState extends State<TimeOfDayPickerButton>
    with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;

  final RestorableTimeOfDay _selectedTimeOfDay = RestorableTimeOfDay(TimeOfDay.now());

  late final RestorableRouteFuture<TimeOfDay?> _restorableTimeOfDayRouteFuture =
      RestorableRouteFuture<TimeOfDay?>(
    onComplete: _selectTimeOfDay,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _timeOfDayRoute,
        arguments: _selectedTimeOfDay.value.hashCode,
      );
    },
  );

  @pragma('vm:entry-point')
  static Route<TimeOfDay> _timeOfDayRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return TimePickerDialog(
          restorationId: 'timeofday_picker_dialog',
          initialTime: TimeOfDay.now(),
          cancelText: "Cancella",
          confirmText: "Conferma",
          initialEntryMode: TimePickerEntryMode.dial,
          hourLabelText: "Ore",
          minuteLabelText: "Minuti",
          errorInvalidText: "Orario non valido",
          helpText: "Seleziona un orario",
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedTimeOfDay, 'selected_timeofday');
    registerForRestoration(_restorableTimeOfDayRouteFuture, 'timeofday_picker_route_future');
  }

  void _selectTimeOfDay(TimeOfDay? newSelectedTimeOfDay) {
    if (newSelectedTimeOfDay != null) {
      setState(() {
        _selectedTimeOfDay.value = newSelectedTimeOfDay;
        if(widget.onSelectedTimeOfDay != null) widget.onSelectedTimeOfDay!(newSelectedTimeOfDay);
      });
    }
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
      onPressed: () {
        _restorableTimeOfDayRouteFuture.present();
      },
      child: Text('${widget.text}${timeOfDaytoString(_selectedTimeOfDay.value)}'),
    );
  }
}

class IntegerPickerButton extends StatefulWidget {
  const IntegerPickerButton({
    super.key,
    this.restorationId,
    required this.text,
    this.minValue = 0,
    this.maxValue = 120,
    this.increment = 1,
    this.onSelectedInteger
    });

  final String? restorationId;
  final String text;
  final int minValue;
  final int maxValue;
  final int increment;
  final void Function(int)? onSelectedInteger;

  @override
  State<IntegerPickerButton> createState() => _IntegerPickerButtonState();
}

class _IntegerPickerButtonState extends State<IntegerPickerButton> {

  late int selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.minValue;
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

class DoubleIntegerPickerButton extends StatefulWidget {
  const DoubleIntegerPickerButton({
    super.key,
    this.restorationId,
    required this.text1,
    required this.text2,
    this.minValue1 = 0,
    this.maxValue1 = 100,
    this.minValue2 = 0,
    this.maxValue2 = 100,
    this.increment1 = 1,
    this.increment2 = 1,
    this.onIntegersSelected
    });

  final String? restorationId;
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
}


class _DoubleIntegerPickerButtonState extends State<DoubleIntegerPickerButton> {

  late int selectedValue1;
  late int selectedValue2;

  @override
  void initState() {
    super.initState();
    selectedValue1 = widget.minValue1;
    selectedValue2 = widget.minValue2;
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