import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/questions.dart';
import 'package:frontend/responsive_report.dart';
import 'package:frontend/utils.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

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

class AddDreamWithS2T extends StatefulWidget {
  const AddDreamWithS2T({super.key});
  @override
  State<AddDreamWithS2T> createState() => _AddDreamWithS2TState();
}

class _AddDreamWithS2TState extends State<AddDreamWithS2T> {
  DreamData dream = DreamData();
  late List<QuestionWithDirection> dreamQuestions;

  @override
  void initState() {
    super.initState();
    dreamQuestions = [
        AddDreamWithS2TText(
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


class AddDreamWithS2TText extends QuestionWithDirection {
  final Function? onTextChanged;

  AddDreamWithS2TText({
    super.key, this.onTextChanged
  }) : super(canChangeDirection: false, direction: Axis.vertical);

  @override
  State<AddDreamWithS2TText> createState() => _AddDreamWithS2TTextState();
}


class _AddDreamWithS2TTextState extends QuestionWithDirectionState<AddDreamWithS2TText> {
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

  final SpeechToText speech = SpeechToText();
  TextEditingController dreamController = TextEditingController();

  Future<void> initSpeechState() async {
    var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: true,
        finalTimeout: Duration(milliseconds: 0));
    if (hasSpeech) {
      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale?.localeId ?? '';
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  void initState() {
    super.initState();
    initSpeechState();
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
    bool isMobile = screenWidth < widthConstraint;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _hasSpeech && isMobile 
        ? AvatarGlow(
          animate: speech.isListening,
          glowColor: Colors.red,
          duration: const Duration(seconds: 2),
          repeat: true,
          child: FloatingActionButton(
            shape: CircleBorder(),
            backgroundColor: Colors.red,
            onPressed: () {
              if(speech.isListening){
                cancelListening();
              }else{
                startListening();
              }
            },
            child: Icon(speech.isListening ? Icons.mic : Icons.mic_off)
          ),
        ) 
        : null,
      body: Column(
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
          if(isMobile)...{
            SizedBox(height: screenHeight * 0.01,),
            Text(
              "💡 Suggerimento: puoi trascrivere il tuo sogno a voce utilizzando il microfono della tua tastiera!",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12
              ),
            ),

            // TextButton(
            //   onPressed: speech.isListening ? cancelListening : null,
            //   child: Text('Cancella', style: TextStyle(fontSize: 17)),
            // ),
            // TextButton(
            //   onPressed: !_hasSpeech || speech.isListening ? null : startListening,
            //   child: Text(speech.isListening ? 'In ascolto..' : 'Racconta', style: TextStyle(fontSize: 17)),
            // ),
          }
      
        ],
      ),
    );
  }


    void startListening() {
    speech.listen(
        onResult: resultListener,
        listenFor: const Duration(minutes: 5),
        pauseFor: const Duration(seconds: 5),
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        listenOptions: SpeechListenOptions(
          listenMode: ListenMode.dictation,
          cancelOnError: false,
          partialResults: true,
        )
    );

    setState(() {});
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    ++resultListened;

    if (result.finalResult) {
      setState(() {
        if (dreamController.text.endsWith(' ')) {
          dreamController.text += result.recognizedWords;
        } else {
          dreamController.text += ' ' + result.recognizedWords;
        }
      });
    }
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);

    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {});
    
    try {
      print(error);
    } catch (Exception) {
      speech.stop();
    }
  }

  void statusListener(String status) {
    setState(() {});
  }
  

}
