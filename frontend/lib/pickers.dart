// from: https://api.flutter.dev/flutter/material/showDatePicker.html
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
    this.maxValue = 100,
    this.onSelectedInteger
    });

  final String? restorationId;
  final String text;
  final int maxValue;
  final void Function(int)? onSelectedInteger;

  @override
  State<IntegerPickerButton> createState() => _IntegerPickerButtonState();
}

class _IntegerPickerButtonState extends State<IntegerPickerButton> {
  int _selectedInt = 0;

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: DefaultTextStyle(
        style: TextStyle(
          color: CupertinoColors.label.resolveFrom(context),
          fontSize: 22.0,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlinedButton(
                child: Text("${widget.text} ${_selectedInt}"),
                onPressed: () => _showDialog(
                  CupertinoPicker(
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: false,
                    itemExtent: 32.0,
                    // This sets the initial item.
                    scrollController: FixedExtentScrollController(
                      initialItem: _selectedInt,
                    ),
                    // This is called when selected item is changed.
                    onSelectedItemChanged: (int selectedItem) {
                      setState(() {
                        _selectedInt = selectedItem;
                        if(widget.onSelectedInteger != null) widget.onSelectedInteger!(selectedItem);
                      });
                    },
                    children: List<Widget>.generate(widget.maxValue+1, (int index) {
                      return Center(child: Text("${index}"));
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// from: https://stackoverflow.com/a/74700812
class DoubleIntegerPickerButton extends StatefulWidget {
  const DoubleIntegerPickerButton({
    super.key,
    this.restorationId,
    required this.text1,
    required this.text2,
    this.maxValue = 100,
    this.onIntegersSelected
    });

  final String? restorationId;
  final String text1;
  final String text2;
  final int maxValue;
  final void Function(int, int)? onIntegersSelected;

  @override
  State<DoubleIntegerPickerButton> createState() => _DoubleIntegerPickerButtonState();
}

class _DoubleIntegerPickerButtonState extends State<DoubleIntegerPickerButton> {
  int _selectedInt1 = 0;
  int _selectedInt2 = 0;

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 2.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    Widget doublePicker = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: CupertinoPicker.builder(
                    childCount: 10,
                    itemExtent: 32.0,
                    onSelectedItemChanged: (itemIndex) {
                      setState(() {
                        _selectedInt1 = itemIndex;
                        if(widget.onIntegersSelected != null) widget.onIntegersSelected!(_selectedInt1, _selectedInt2);
                      });
                    },
                    itemBuilder: (context, index) {
                      return Center(
                        child: Text("${index}",textAlign: TextAlign.center),
                      );
                    },
                  ),
              ),
            Expanded(
              child: CupertinoPicker.builder(
                childCount: 20,
                itemExtent: 32.0,
                onSelectedItemChanged: (itemIndex) {
                  setState(() {
                    _selectedInt2 = itemIndex; 
                    if(widget.onIntegersSelected != null) widget.onIntegersSelected!(_selectedInt1, _selectedInt2);
                  });
                },
                itemBuilder: (context, index) {
                  return Center(
                    child: Text(
                      "${index}",
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ],
        );


    return CupertinoPageScaffold(
      child: DefaultTextStyle(
        style: TextStyle(
          color: CupertinoColors.label.resolveFrom(context),
          fontSize: 22.0,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlinedButton(
                child: Text("${_selectedInt1} ${widget.text1} e ${_selectedInt2} ${widget.text2}"),
                onPressed: () => _showDialog(doublePicker),
              ),
            ],
          ),
        ),
      ),
    );
  }
}