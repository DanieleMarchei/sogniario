import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/questions.dart';
import 'package:frontend/responsive_report.dart';
import 'package:frontend/utils.dart';

List<QA> questions = [
  QA(question: "Come giudichi il contenuto emotivo del sogno?", answers: [
    "Non emotivo.",
    "Parzialmente emotivo.",
    "Nella media.",
    "Emotivo.",
    "Molto emotivo."
  ]),
  QA(question: "Eri coscente che stavi sognando?", answers: ["Si.", "No."]),
  QA(question: "Avevi il controllo del sogno?", answers: [
    "Nessun controllo.",
    "Riuscivo a controllare solo alcune cose.",
    "Controllo totale."
  ]),
  QA(question: "Quanto tempo pensi sia passato nel tuo sogno?", answers: [
    "Pochi secondi.",
    "Qualche minuto.",
    "Qualche ora.",
    "Qualche giorno."
  ]),
  QA(question: "Quanto hai dormito?", answers: [
    "Meno di 6 ore.",
    "6 - 7 ore.",
    "7 - 8 ore.",
    "8 - 9 ore.",
    "Più di 9 ore."
  ]),
  QA(
      question: "Come giudichi la qualità del sonno?",
      answers: ["Molto scarsa.", "Scarsa.", "Buona.", "Molto buona."]),
];

class AddDream extends StatefulWidget {
  const AddDream({super.key});
  @override
  State<AddDream> createState() => _AddDreamState();
}

class _AddDreamState extends State<AddDream> {
  DreamData dream = DreamData();
  late List<QuestionWithDirection> dreamQuestions;

  @override
  void initState() {
    super.initState();
    dreamQuestions = [
        AddDreamText(
          onTextChanged: (value) {
            setState(() {
              dream.dreamText = value;
            });
          },
        ),
      ...List<MultipleChoiceQuestion>.generate(questions.length, (index) {
        var q = questions[index].question;
        var a = questions[index].answers;
        var s = questions[index].scores;
        return MultipleChoiceQuestion(
          question: q,
          answers: a,
          onSelected: (value) {
            setState(() {
              dream.report[index] = s[value];
            });
          },
        );
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    int id = arguments["id"];

    return ResponsiveReport(
      questionWidgets: dreamQuestions,
      title: "Racconta un sognio",
      onSubmitted: () async {
        await addDream(id, dream);
        Navigator.pop(context);
      }
    );
  }
}






class AddDreamText extends QuestionWithDirection {
  final Function? onTextChanged;

  AddDreamText({
    super.key, this.onTextChanged
  }) : super(canChangeDirection: false, direction: Axis.vertical);

  @override
  State<AddDreamText> createState() => _AddDreamTextState();
}


class _AddDreamTextState extends QuestionWithDirectionState<AddDreamText> {
  late String text;
  String? textError;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    text = '';
  }

  void resetErrorText() {
    setState(() {
      textError = null;
    });
  }

  bool validate() {
    resetErrorText();

    if (text.isEmpty) {
      setState(() {
        textError = 'Testo non presente';
      });
      return false;
    }
    RegExp whiteSpaces = RegExp(r'\s+', multiLine: true);
    if (text.trim().split(whiteSpaces).length <= 2) {
      setState(() {
        textError = 'Testo troppo corto. Scrivi almeno tre parole.';
      });
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenHeight = MediaQuery.of(context).size.height;

    return MultilineInputField(
            labelText: "Racconta il tuo sogno",
            maxLines: 10,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            errorText: textError,
            onChanged: (value) {
              setState(() {
                text = value;
                resetErrorText();
                if (widget.onTextChanged != null) widget.onTextChanged!(value);
              });
            },
            autoFocus: false,
          );
  }
  

}
