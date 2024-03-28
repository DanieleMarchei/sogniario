import 'package:flutter/material.dart';

double widthConstraint = 1080;
double halfWidthConstraint = widthConstraint / 2;

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

class QA {
  final String question;
  final List<String> answers;
  late final List<int> scores;

  QA({
    required this.question,
    required this.answers,
    List<int>? scores
    }){
      if(scores == null){
        this.scores = List<int>.generate(answers.length, (index) => index + 1);
      }else{
        this.scores = scores;
      }
    }
}

class DreamData {
  String dreamText = "";
  List<int> report = List<int>.generate(6, (index) => 0);

  @override
  String toString() {
    return "${dreamText}\n${report}";
  }
}

class PSQIData {
  List<dynamic> report = List<dynamic>.generate(19, (index) => null);

  @override
  String toString() {
    return report.toString();
  }
}

class ChronoTypeData {
  List<int> report = List<int>.generate(19, (index) => 0);

  @override
  String toString() {
    return report.toString();
  }

  int score(){
    return report.reduce((value, element){
      return value + element;});
  }
}

enum Gender {
  male(label: "Maschio", id: 0),
  female(label: "Femmina", id: 1),
  notSpecified(label: "Non specificato", id: 2);
  // other(label: "Altro", id: 3);

  const Gender({required this.label, required this.id});
  final String label;
  final int id;
}

class UserData {
  int id = 0;
  String username = "", password = "";
  DateTime? birthdate = null;
  Gender? gender = null;

}