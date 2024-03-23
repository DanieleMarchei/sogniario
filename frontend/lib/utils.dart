double widthConstraint = 1080;
double halfWidthConstraint = widthConstraint / 2;

class QA {
  final String question;
  final List<String> answers;

  const QA({
    required this.question,
    required this.answers
    });
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
}