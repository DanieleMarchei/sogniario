// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_picker/picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/utils.dart';
import 'package:go_router/go_router.dart';


class DatePickerButton extends StatefulWidget {
  DatePickerButton(
      {super.key,
      required this.text,
      this.onSelectedDate,
      this.helpText = "Seleziona data"});

  final String text;
  final String helpText;
  final void Function(DateTime)? onSelectedDate;

  @override
  State<DatePickerButton> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePickerButton> {
  List<int?> selectedValue = [null, null, null];

  final List<(String, String, int)> months = [
    ("Gen", "Gennaio", 1),
    ("Feb", "Febbraio", 2),
    ("Mar", "Marzo", 3),
    ("Apr", "Aprile", 4),
    ("Mag", "Maggio", 5),
    ("Giu", "Giugno", 6),
    ("Lug", "Luglio", 7),
    ("Ago", "Agosto", 8),
    ("Set", "Settembre", 9),
    ("Ott", "Ottobre", 10),
    ("Nov", "Novembre", 11),
    ("Dic", "Dicembre", 12)
  ];

  final List<int> years = List.generate(DateTime.now().year - 1900 + 1, (index) => 1900 + index);
  final List<int> days = List.generate(31, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool showMobileLayout = screenWidth < 850;
    return OutlinedButton(
      onPressed: () {
        if (showMobileLayout) {
          showMobile(context);
        } else {
          showDesktop(context);
        }
      },
      child: Text(selectedValue.any((element) => element == null)
          ? '${widget.text}${widget.helpText}'
          : '${widget.text}${selectedValue[0]}/${months[selectedValue[1]! - 1].$1}/${selectedValue[2]}'
      )
    );
  }

  void showDesktop(BuildContext conrtext) {
    List<int?> originalValue = List.from(selectedValue);
    List<int?> tmpValue = List.from(selectedValue);

    setState(() {
      if(selectedValue.any((element) => element == null)){
        selectedValue = [null, null, null];
      }
    });
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              const Text("Seleziona"),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  tooltip: "Annulla",
                  icon: const Icon(Icons.close))
            ]),
            children: [
              SimpleDialogOption(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          label: Text("Giorno"),
                        ),
                        value: originalValue[0],
                        items: days.map<DropdownMenuItem<int>>((int i) {
                          return DropdownMenuItem<int>(
                            value: i,
                            child: Text(
                              "$i",
                            ),
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          setState(() {
                            tmpValue[0] = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          label: Text("Mese"),
                        ),
                        value: originalValue[1],
                        items: months.map<DropdownMenuItem<int>>(((String, String, int) m_i) {
                          return DropdownMenuItem<int>(
                            value: m_i.$3,
                            child: Text(
                              "${m_i.$2}",
                            ),
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          setState(() {
                            tmpValue[1] = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          label: Text("Anno"),
                        ),
                        value: originalValue[2],
                        items: years.map<DropdownMenuItem<int>>((int i) {
                          return DropdownMenuItem<int>(
                            value: i,
                            child: Text(
                              "$i",
                            ),
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          setState(() {
                            tmpValue[2] = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                child: Row(
                  children: [
                    TextButton(
                      child: const Text('Cancella'),
                      onPressed: () {
                        setState(() {
                          selectedValue = originalValue;
                        });
                        context.pop();
                      },
                    ),
                    TextButton(
                      child: Text('Conferma'),
                      onPressed: () {
                        if(tmpValue.any((element) => element == null)){
                          Fluttertoast.showToast(
                            msg: "Data non valida!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 12.0
                          );
                          return;
                        }

                        DateTime selected = DateTime(tmpValue[2]!, tmpValue[1]!, tmpValue[0]!);
                        // selected != tmpValue iff the date was invalid (like 31 feb)
                        if(selected.year != tmpValue[2] || selected.month != tmpValue[1] || selected.day != tmpValue[0]){
                          Fluttertoast.showToast(
                            msg: "Data non valida!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 12.0
                          );
                          return;
                        }
                        

                        if(selected.isAfter(DateTime.now())){
                          Fluttertoast.showToast(
                            msg: "Inserire una data antecedente ad oggi.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 12.0
                          );
                          return;
                        }

                        setState(() {
                          selectedValue = tmpValue;
                        });
                        
                        if (widget.onSelectedDate != null) {
                          widget.onSelectedDate!(selected);
                        }
                        context.pop();
                      },
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  void showMobile(BuildContext conrtext) {
    Picker(
      adapter: DateTimePickerAdapter(
        months: List<String>.generate(12, (index) => months[index].$2),
        maxValue: DateTime.now(),
        type: PickerDateTimeType.kYMD,
      ),
      changeToFirst: false,
      hideHeader: true,
      confirmText: 'Conferma',
      cancelText: "Cancella",
      title: const Text("Data di nascita"),
      backgroundColor: const Color.fromARGB(255, 238, 232, 244),
      onConfirm: (Picker picker, List value) {
        int day = value[2] + 1;
        int month = value[1] + 1;
        int year =
            value[0] + (picker.adapter as DateTimePickerAdapter).yearBegin;
        DateTime selected = DateTime(year, month, day);
        setState(() {
          selectedValue = [day, month, year];
        });
        if (widget.onSelectedDate != null) widget.onSelectedDate!(selected);
      },
    ).showDialog(context);
  }
}

class TimeOfDayPickerButton extends StatefulWidget {
  TimeOfDayPickerButton(
      {super.key,
      required this.text,
      this.onSelectedTimeOfDay,
      this.helpText = "Seleziona un orario"});

  final String text;
  final String helpText;
  final void Function(TimeOfDay)? onSelectedTimeOfDay;

  @override
  State<TimeOfDayPickerButton> createState() => _TimeOfDayState();
}

class _TimeOfDayState extends State<TimeOfDayPickerButton> {
  TimeOfDay? selectedValue;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        TimeOfDay? selected = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          cancelText: "Cancella",
          confirmText: "Conferma",
          initialEntryMode: TimePickerEntryMode.dial,
          hourLabelText: "Ore",
          minuteLabelText: "Minuti",
          errorInvalidText: "Orario non valido",
          helpText: "Seleziona un orario",
          builder: (_, Widget? child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );
        if (selected != null) {
          setState(() {
            selectedValue = selected;
          });
          if (widget.onSelectedTimeOfDay != null)
            widget.onSelectedTimeOfDay!(selected);
        }
      },
      child: Text(selectedValue != null
          ? '${widget.text}${timeOfDaytoString(selectedValue!)}'
          : '${widget.text}${widget.helpText}'),
    );
  }
}

class IntegerPickerButton extends StatefulWidget {
  IntegerPickerButton(
      {super.key,
      required this.text,
      this.minValue = 0,
      this.maxValue = 120,
      this.increment = 1,
      this.onSelectedInteger,
      this.helpText = "Seleziona",
      this.options = const ["Minuti"]
      });

  final String text;
  final String helpText;
  final int minValue;
  final int maxValue;
  final int increment;
  final void Function(int, int)? onSelectedInteger;
  final List<String> options;
  @override
  State<IntegerPickerButton> createState() => _IntegerPickerButtonState();
}

class _IntegerPickerButtonState extends State<IntegerPickerButton> {
  int? selectedValue;
  int? selectedOption;
  String? tmpSelected;
  String? tmpOption;

  late var data;

  @override
  void initState() {
    super.initState();
    data = [
      List.generate((widget.maxValue - widget.minValue) ~/ widget.increment + 1,
          (index) => index * (widget.increment) + widget.minValue).map((e) => e.toString()).toList(),
    ];
    if(widget.options.length > 1){
      data.add(widget.options);
    }
    tmpSelected = data[0][0];
    if(widget.options.length == 1){
      tmpOption = widget.options[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool showMobileLayout = screenWidth < 850;
    return OutlinedButton(
      onPressed: () {
        if (showMobileLayout) {
          showMobile(context);
        } else {
          showDesktop(context);
        }
      },
      child: Text(selectedValue != null && selectedOption != null
          ? '${widget.text}${selectedValue} ${widget.options[selectedOption!]}'
          : '${widget.helpText}'),
    );
  }

  void showMobile(BuildContext context) {
    Picker(
      adapter: PickerDataAdapter<String>(pickerData: data, isArray: true),
      changeToFirst: false,
      hideHeader: true,
      title: Text(widget.options.length > 1 ? "Seleziona" : widget.options[0]),
      confirmText: 'Conferma',
      cancelText: "Cancella",
      backgroundColor: const Color.fromARGB(255, 238, 232, 244),
      onConfirm: (Picker picker, List value) {
        setState(() {
          print(picker.getSelectedValues());
          selectedValue = int.parse(picker.getSelectedValues()[0]);
          if(widget.options.length == 1){
            selectedOption = widget.options.indexOf(widget.options[0]);
          }else{
            selectedOption = widget.options.indexOf(picker.getSelectedValues()[1]);
          }
        });
        if (widget.onSelectedInteger != null)
          widget.onSelectedInteger!(selectedValue!, selectedOption!);
      },
    ).showDialog(context);
  }

  void showDesktop(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              const Text("Seleziona"),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  tooltip: "Annulla",
                  icon: const Icon(Icons.close))
            ]),
            children: [
              SimpleDialogOption(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          label: Text(widget.options.length > 1 ? "Tempo" : widget.options[0]),
                        ),
                        value: tmpSelected,
                        items: data[0].map<DropdownMenuItem<String>>((String i) {
                          return DropdownMenuItem<String>(
                            value: i,
                            child: Text("$i"),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            tmpSelected = value!;
                          });

                        },
                      ),
                    ),
                    if(widget.options.length > 1)...{
                      SizedBox(width: 5,),
                      SizedBox(
                        width: 200,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            label: Text("Minuti/Ore/Giorni"),
                          ),
                          value: tmpOption,
                          items: data[1].map<DropdownMenuItem<String>>((String i) {
                            return DropdownMenuItem<String>(
                              value: i,
                              child: Text("$i"),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              tmpOption = value!;
                            });
                          },
                        ),
                      ),
                    }
                  ],
                ),
              ),
              SimpleDialogOption(
                child: Row(
                  children: [
                    TextButton(
                      child: const Text('Cancella'),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                    TextButton(
                      child: Text('Conferma'),
                      onPressed: () {
                        if(tmpSelected == null || tmpOption == null){
                          Fluttertoast.showToast(
                            msg: "Tutti i campi devono essere compilati.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 12.0
                          );
                          return;
                        }
                        if(widget.options.length > 1 && tmpOption == null){
                          Fluttertoast.showToast(
                            msg: "Tutti i campi devono essere compilati.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 12.0
                          );
                          return;
                        }
                        setState(() {
                          selectedValue = int.parse(tmpSelected!);
                          selectedOption = widget.options.indexOf(tmpOption!);
                        });
                        if (widget.onSelectedInteger != null) {
                          widget.onSelectedInteger!(selectedValue!, selectedOption!);
                        }
                        context.pop();
                      },
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }
}

class DoubleIntegerPickerButton extends StatefulWidget {
  DoubleIntegerPickerButton(
      {super.key,
      required this.text1,
      required this.text2,
      this.minValue1 = 0,
      this.maxValue1 = 100,
      this.minValue2 = 0,
      this.maxValue2 = 100,
      this.increment1 = 1,
      this.increment2 = 1,
      this.onIntegersSelected,
      this.helpText = "Seleziona"});

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
  State<DoubleIntegerPickerButton> createState() =>
      _DoubleIntegerPickerButtonState();
}

class _DoubleIntegerPickerButtonState extends State<DoubleIntegerPickerButton> {
  int? selectedValue1;
  int? selectedValue2;
  late List<List<int>> data;

  int? tmpSelected1;
  int? tmpSelected2;

  @override
  void initState() {
    super.initState();
    data = [
      List.generate(
          (widget.maxValue1 - widget.minValue1) ~/ widget.increment1 + 1,
          (index) => index * (widget.increment1) + widget.minValue1),
      List.generate(
          (widget.maxValue2 - widget.minValue2) ~/ widget.increment2 + 1,
          (index) => index * (widget.increment2) + widget.minValue2),
    ];

    tmpSelected1 = data[0][0];
    tmpSelected2 = data[1][0];
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        if (kIsWeb) {
          showDesktop(context);
        } else {
          showMobile(context);
        }
      },
      child: Text((selectedValue1 != null) && (selectedValue2 != null)
          ? '${selectedValue1} ${widget.text1} e ${selectedValue2} ${widget.text2}'
          : '${widget.helpText}'),
    );
  }

  void showMobile(BuildContext context) {
    Picker(
      adapter: PickerDataAdapter<String>(pickerData: data, isArray: true),
      changeToFirst: false,
      hideHeader: true,
      confirmText: 'Conferma',
      cancelText: "Cancella",
      title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [Text('Ore'), Text(':'), Text('Minuti')]),
      backgroundColor: const Color.fromARGB(255, 238, 232, 244),
      onConfirm: (Picker picker, List value) {
        setState(() {
          selectedValue1 = int.parse(picker.getSelectedValues()[0]);
          selectedValue2 = int.parse(picker.getSelectedValues()[1]);
        });
        if (widget.onIntegersSelected != null) {
          widget.onIntegersSelected!(selectedValue1!, selectedValue2!);
        }
      },
    ).showDialog(context);
  }

  void showDesktop(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              const Text("Seleziona"),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  tooltip: "Annulla",
                  icon: const Icon(Icons.close))
            ]),
            children: [
              SimpleDialogOption(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 100,
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          label: Text("Ore"),
                        ),
                        value: tmpSelected1,
                        items: data[0].map<DropdownMenuItem<int>>((int i) {
                          return DropdownMenuItem<int>(
                            value: i,
                            child: Text(
                              "$i",
                            ),
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          setState(() {
                            tmpSelected1 = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                      child: Text(":"),
                    ),
                    SizedBox(
                      width: 100,
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          label: Text("Minuti"),
                        ),
                        value: tmpSelected2,
                        items: data[1].map<DropdownMenuItem<int>>((int i) {
                          return DropdownMenuItem<int>(
                            value: i,
                            child: Text("$i"),
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          setState(() {
                            tmpSelected2 = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                child: Row(
                  children: [
                    TextButton(
                      child: const Text('Cancella'),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                    TextButton(
                      child: Text('Conferma'),
                      onPressed: () {
                        setState(() {
                          selectedValue1 = tmpSelected1;
                          selectedValue2 = tmpSelected2;
                        });
                        if (widget.onIntegersSelected != null) {
                          widget.onIntegersSelected!(
                              selectedValue1!, selectedValue2!);
                        }
                        context.pop();
                      },
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }
}
