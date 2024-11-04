import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

String currentVersion = "4 Novembre 2024";

double widthConstraint = 1080;
double halfWidthConstraint = widthConstraint / 2;

enum HiveBoxes{
  jwt(label: "jwt"),
  hasGeneralInfo(label: "hasGeneralInfo"),
  hasChronotype(label: "hasChronotype"),
  lastTimeCheckedVersion(label: "lastTimeCheckedVersion");

  const HiveBoxes({required this.label});
  final String label;

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
        this.scores = List<int>.generate(answers.length, (index) => index);
      }else{
        this.scores = scores;
      }
    }
}

enum DreamType {
  dreamed(id: 0, text: ""),
  notDreamed(id: 1, text: "Non ho sognato"),
  dontRemember(id: 2, text: "Ho sognato ma non ricordo cosa");

  const DreamType({required this.id, required this.text});
  final int id;
  final String text;
}

class DreamData {
  String? dreamText = "";
  DreamType type = DreamType.dreamed;

  List<dynamic> report = List<dynamic>.generate(7, (index) => null);
  DateTime? createdAt;
  bool deleted = false;

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

  TimeOfDay? timeToBed;
  int? minutesToFallAsleep;
  TimeOfDay? timeWokeUp;
  Duration? timeAsleep;

  int? notFallAsleepWithin30Minutes;
  int? wakeUpWithoutFallingAsleepAgain;
  int? goToTheBathroom;
  int? notBreethingCorrectly;
  int? coughOrSnort;
  int? tooCold;
  int? tooHot;
  int? badDreams;
  int? havingPain;

  bool? otherProblems;
  String? optionalText;
  int? otherProblemsFrequency;

  int? sleepQuality;
  int? drugs;
  int? difficultiesBeingAwake;
  int? enoughEnergies;

  DateTime? compiled_date;
  
  Duration? get hoursInBed {
    if(timeToBed == null || timeWokeUp == null) return null;

    DateTime d1 = DateTime(2020, 1, 1, timeToBed!.hour, timeToBed!.minute);
    DateTime d2 = DateTime(2020, 1, 2, timeWokeUp!.hour, timeWokeUp!.minute);

    return d2.difference(d1);
  }

  double score(){
    double ninf = double.negativeInfinity;
    double inf = double.infinity;
    // #9 score
    double c1 = sleepQuality!.toDouble();

    // #2 Score (<=15min (0), 16-30min (1), 31-60 min (2), >60min (3))
    // + #5a Score (if sum is equal 0=0; 1-2=1; 3-4=2; 5-6=3) 
    late double c2;
    late double two = mapValueFromInterval(minutesToFallAsleep!.toDouble(), [
      (ninf, 15, 0),
      (16, 30, 1),
      (31, 60, 2),
      (60, inf, 3),
    ]);

    double fiveA = notFallAsleepWithin30Minutes!.toDouble();
    c2 = mapValueFromInterval(fiveA + two, [
      (0, 0, 0),
      (1, 2, 1),
      (3, 4, 2),
      (4, 6, 3),
    ]);


    // #4 Score (>7(0), 6-7 (1), 5-6 (2), <5 (3)
    double c3;
    double hoursOfSleep = timeAsleep!.inHours + timeAsleep!.inMinutes.remainder(60);
    c3 = mapValueFromInterval(hoursOfSleep.toDouble(), [
      (7.05, inf, 0), // 7.05 instead of 7.1 just to be on the safe side. Comparing floats is tricky
      (6, 7, 1),
      (5, 6, 2),
      (ninf, 5, 3),
    ]);


    // (total # of hours asleep)/(total # of hours in bed) x 100
    // >85%=0, 75%-84%=1, 65%-74%=2, <65%=3
    double c4;
    double hib = hoursInBed!.inHours + hoursInBed!.inMinutes.remainder(60);
    double fraction = (hoursOfSleep / hib) * 100;
    c4 = mapValueFromInterval(fraction, [
      (85, inf, 0),
      (75, 84, 1),
      (65, 74, 2),
      (ninf, 64, 3),
    ]);

    // Sum of Scores #5b to #5j (0=0; 1-9=1; 10-18=2; 19-27=3).
    double c5;
    int opf = otherProblemsFrequency ?? 0;
    int sumBtoJ = wakeUpWithoutFallingAsleepAgain! + 
                  goToTheBathroom! + 
                  notBreethingCorrectly! + 
                  coughOrSnort! + 
                  tooCold! + 
                  tooHot! + 
                  badDreams! + 
                  havingPain! + 
                  opf;
    c5 = mapValueFromInterval(sumBtoJ.toDouble(), [
      (0, 0, 0),
      (1, 9, 1),
      (10, 18, 2),
      (19, 27, 3),
    ]);

    // #6 Score
    double c6 = drugs!.toDouble();

    // #7 Score + #8 Score (0=0; 1-2=1; 3-4=2; 5-6=3)
    double c7;
    double sum7and8 = difficultiesBeingAwake!.toDouble() + enoughEnergies!.toDouble();
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
  List<int?> report = List<int?>.generate(19, (index) => null);

  @override
  String toString() {
    return report.toString();
  }

  int score(){
    return report.reduce((value, element){
      return value! + element!;})!;
  }
}

enum Sex {
  male(label: "Maschio", id: 0),
  female(label: "Femmina", id: 1),
  notSpecified(label: "Non specificato", id: 2);

  const Sex({required this.label, required this.id});
  final String label;
  final int id;
}

enum Time {
  seconds(label: "Secondi", id: 0),
  minutes(label: "Minuti", id: 1),
  hours(label: "Ore", id: 2),
  days(label: "Giorni", id: 3),
  months(label: "Mesi", id: 4),
  years(label: "Anni", id: 5);

  const Time({required this.label, required this.id});
  final String label;
  final int id;
}

class UserData {
  int id = 0;
  String username = "", password = "";
  DateTime? birthdate = null;
  Sex? sex = null;
  int? organizationId;
  String? organizationName;
  bool? deleted;

  @override
  bool operator ==(other){
    if(other is! UserData) return false;

    return other.id == id && 
          other.username == username &&
          other.password == password &&
          other.birthdate == birthdate &&
          other.sex == sex &&
          other.organizationId == organizationId &&
          other.organizationName == organizationName;
  }

  UserData copy(){
    UserData user = UserData();
    user.id = id;
    user.username = username;
    user.password = password;
    user.birthdate = birthdate;
    user.sex = sex;
    user.organizationId = organizationId;
    user.organizationName = organizationName;
    user.deleted = deleted;

    return user;
  }

  @override
  String toString() {
    return (id, username, password, birthdate, sex, organizationId, organizationName).toString();
  }
  

}

var userDataBox = Hive.box('userData');

bool isTimeToCheckVersion(){
  DateTime? lastTimeChecked = userDataBox.get(HiveBoxes.lastTimeCheckedVersion.label);

  if(lastTimeChecked == null) return true;

  Duration difference = DateTime.now().difference(lastTimeChecked);
  return difference.inDays >= 10;
}