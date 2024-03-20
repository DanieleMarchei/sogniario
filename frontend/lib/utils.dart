class QA {
  final String question;
  final List<String> answers;

  const QA({
    required this.question,
    required this.answers
    });
}

class Dream {
  String dreamText = "";
  List<int> report = [0,0,0,0,0,0];

  Dream ();

  @override
  String toString() {
    return "${dreamText}\n${report}";
  }
}