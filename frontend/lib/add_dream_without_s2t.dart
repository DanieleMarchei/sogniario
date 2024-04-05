import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
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

class AddDreamWithoutS2T extends StatefulWidget {
  const AddDreamWithoutS2T({super.key});
  @override
  State<AddDreamWithoutS2T> createState() => _AddDreamWithoutS2TState();
}

class _AddDreamWithoutS2TState extends State<AddDreamWithoutS2T> {
  DreamData dream = DreamData();
  late List<QuestionWithDirection> dreamQuestions;

  @override
  void initState() {
    super.initState();
    dreamQuestions = [
        AddDreamWithoutS2TText(
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
        var mcq = MultipleChoiceQuestion(
          question: q,
          answers: a,
          onSelected: (value) {
            setState(() {
              dream.report[index] = s[value];
            });
          },
        );
        dream.report[index] = s[mcq.initialValue];
        return mcq;
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {

    return ResponsiveReport(
      questionWidgets: dreamQuestions,
      title: "Racconta un sogno",
      onSubmitted: () async {
        await addDream(dream);
        Navigator.pop(context);
      }
    );
  }
  
}


class AddDreamWithoutS2TText extends QuestionWithDirection {
  final Function? onTextChanged;

  AddDreamWithoutS2TText({
    super.key, this.onTextChanged
  }) : super(canChangeDirection: false, direction: Axis.vertical);

  @override
  State<AddDreamWithoutS2TText> createState() => _AddDreamWithoutS2TTextState();
}


class _AddDreamWithoutS2TTextState extends QuestionWithDirectionState<AddDreamWithoutS2TText> {
  late String text;
  String? textError;

  @override
  bool get wantKeepAlive => true;

  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String _currentLocaleId = '';
  int resultListened = 0;

  TextEditingController dreamController = TextEditingController();

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
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
          children: [
            SizedBox(height: screenHeight * 0.01,),
            MultilineInputField(
              controller: dreamController,
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
            ),
          ],
        );
  }  

}
