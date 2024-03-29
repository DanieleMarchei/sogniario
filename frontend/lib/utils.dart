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
  DateTime? createdAt;

  @override
  String toString() {
    return "${dreamText}\n${report}";
  }
}

double mapValueFromInterval(double value, List<(double, double, double)> intervalsWithResults){
  for (var e in intervalsWithResults) {
    double from, to, result;
    (from, to, result) = e;
    if(from <= value && value <= to) return result;
  }

  throw Exception("Not enough interval to cover all possibilities.");
}

class PSQIData {
  // 23 values because there are 19 questions and 3 of them have multiple values
  // which are spanned through different columns in the database
  List<dynamic> report = List<dynamic>.generate(23, (index) => null);

  @override
  String toString() {
    return report.toString();
  }

  double score(){
    double ninf = double.negativeInfinity;
    double inf = double.infinity;
    // 9th score
    double c1 = (report.last as int).toDouble();

    // #2 Score (<=15min (0), 16-30min (1), 31-60 min (2), >60min (3))
    // + #5a Score (if sum is equal 0=0; 1-2=1; 3-4=2; 5-6=3) 
    late double c2;
    late double two = mapValueFromInterval((report[1] as int).toDouble(), [
      (ninf, 15, 0),
      (16, 30, 1),
      (31, 60, 2),
      (60, inf, 3),
    ]);

    double fiveA = (report[5] as int).toDouble();
    c2 = mapValueFromInterval(fiveA + two, [
      (0, 0, 0),
      (1, 2, 1),
      (3, 4, 2),
      (4, 6, 3),
    ]);


    // #4 Score (>7(0), 6-7 (1), 5-6 (2), <5 (3)
    double c3;
    double hoursAsleep = report[3] + report[4] / 10;
    c3 = mapValueFromInterval(hoursAsleep, [
      (7.05, inf, 0), // 7.05 instead of 7.1 just to be on the safe side. Comparing floats is tricky
      (6, 7, 1),
      (5, 6, 2),
      (ninf, 5, 3),
    ]);


    // (total # of hours asleep)/(total # of hours in bed) x 100
    // >85%=0, 75%-84%=1, 65%-74%=2, <65%=3
    double c4;
    double hoursInBed = report[5] + report[6] / 10;
    double fraction = (hoursAsleep / hoursInBed) * 100;
    c4 = mapValueFromInterval(fraction, [
      (85, inf, 0),
      (75, 84, 1),
      (65, 74, 2),
      (ninf, 64, 3),
    ]);

    // Sum of Scores #5b to #5j (0=0; 1-9=1; 10-18=2; 19-27=3).
    double c5;
    int? r18 = report[18];
    double r18Val = r18 == null ? 0.0 : r18.toDouble();
    double sumBtoJ = report
                      .sublist(7, 16)
                      .reduce((value, element) => value + element) + r18Val;
    c5 = mapValueFromInterval(sumBtoJ, [
      (0, 0, 0),
      (1, 9, 1),
      (10, 18, 2),
      (19, 27, 3),
    ]);

    // #6 Score
    double c6 = (report[19] as int).toDouble();

    // #7 Score + #8 Score (0=0; 1-2=1; 3-4=2; 5-6=3)
    double c7;
    double sum7and8 = (report[20] as int).toDouble() + report[21];
    c7 = mapValueFromInterval(sum7and8, [
      (0, 0, 0),
      (1, 2, 1),
      (3, 4, 2),
      (5, 6, 3),
    ]);


    return c1 + c2 + c3 + c4 + c5 + c6 + c7;

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