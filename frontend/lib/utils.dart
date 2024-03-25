double widthConstraint = 1080;
double halfWidthConstraint = widthConstraint / 2;

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
  notSpecified(label: "Non specificato", id: 2),
  other(label: "Altro", id: 3);

  const Gender({required this.label, required this.id});
  final String label;
  final int id;
}

class UserData {
  String username = "", password = "";
  DateTime? birthdate = null;
  Gender? gender = null;

}