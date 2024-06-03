import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/api.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/questions.dart';
import 'package:frontend/responsive_report.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

List<QA> questions = [
  QA(question: "Come valuti la valenza emotiva del sogno?", answers: [
    "Molto negativa",
    "Piuttosto negativa",
    "Neutra",
    "Piuttosto positiva",
    "Molto positiva"
  ]),
  QA(question: "Come valuti l’intensità emotiva del sogno?", answers: [
    "Molto debole",
    "Piuttosto debole",
    "Né debole né forte",
    "Piuttosto forte",
    "Molto forte"
  ]),
  QA(question: "Quanto eri consapevole di star sognando?", answers: [
    "Per nulla consapevole", 
    "Parzialmente consapevole",
    "Completamente consapevole"
  ]),
  QA(question: "Quanto controllo volontario avevi sul contenuto e sullo svolgimento del sogno?", answers: [
    "Nessun controllo",
    "Parziale controllo",
    "Completo controllo"
  ]),
];

class AddDreamWithS2T extends StatefulWidget {
  const AddDreamWithS2T({super.key});
  @override
  State<AddDreamWithS2T> createState() => _AddDreamWithS2TState();
}

class _AddDreamWithS2TState extends State<AddDreamWithS2T> {
  DreamData dream = DreamData();
  final dreamKey = GlobalKey();

  late List<QuestionWithDirection> dreamQuestions;

  @override
  void initState() {
    super.initState();
    dreamQuestions = [
        AddDreamWithS2TText(
          key: dreamKey,
          onTextChanged: (value) {
            setState(() {
              dream.dreamText = value;
            });
          },
        ),
      ...List.generate(questions.length, (index) {
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
        return mcq;
      }),
      ...[
        SelectIntQuestion(
          question: "Quanto tempo pensi sia trascorso nel tuo sogno?",
          text: "Tempo: ",
          options: [Time.minutes.label, Time.hours.label, Time.days.label],
          onSelected: (answer, idxOption) {
            setState(() {
              Time t = [Time.minutes, Time.hours, Time.days][idxOption];
              late Duration d;
              switch (t) {
                case Time.minutes:
                  d = Duration(minutes: answer);
                  break;
                
                case Time.hours:
                  d = Duration(hours: answer);
                  break;

                case Time.days:
                  d = Duration(days: answer);
                  break;

                default:
              }
              dream.report[4] = d;
            });
          },
        ),
        SelectIntQuestion(
          question: "Quante ore hai dormito?",
          text: "Tempo: ",
          options: const ["Ore"],
          onSelected: (answer, idxOption) {
            setState(() {
              dream.report[5] = Duration(hours: answer);
            });
          },
        ),
        MultipleChoiceQuestion(
          question: "Come giudichi la qualità del sonno?",
          answers: ["Molto scarsa", "Scarsa", "Buona", "Molto buona"],
          onSelected: (value) {
            setState(() {
              dream.report[6] = value;
            });
          },
        ),
      ]
    ];
  }

  @override
  Widget build(BuildContext context) {

    var responsiveReport = ResponsiveReport(
      questionWidgets: dreamQuestions,
      title: "Racconta un sogno",
      homeButtonTooltip: "Vuoi annullare il racconto di questo sogno e tornare alla schermata principale?",
      onSubmitted: () async {
        await addDream(dream);
        context.goNamed(Routes.homeUser.name);
      }, unansweredQuestions: () { 
        List<int> uq = [];
        if(dream.dreamText.split(" ").length < 1){
          uq.add(0);
        }
        for (var i = 0; i < dream.report.length; i++) {
          if(dream.report[i] == null) uq.add(i +1);
        }

        return uq;
      },
    );

    return responsiveReport;
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

// continuos s2t from https://gist.github.com/jsrimr/09af9516ee1c5907453635b03ce885ae
class _AddDreamWithS2TTextState extends QuestionWithDirectionState<AddDreamWithS2TText> {
  late String text;
  String? textError;

  @override
  bool get wantKeepAlive => true;

  String _currentLocaleId = '';
  bool _speechAvailable = false;
  String _lastWords = '';
  String _currentWords = '';
  bool stoppedByUser = false;

  final SpeechToText speech = SpeechToText();
  TextEditingController dreamController = TextEditingController();
  ScrollController dreamScrollController = ScrollController();

  Future<void> initSpeechState() async {
    _speechAvailable = await speech.initialize(
        onStatus: statusListener,
        debugLogging: false,
        finalTimeout: Duration(milliseconds: 100)
      );
    
    if (_speechAvailable) {
      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale?.localeId ?? '';
    }

    if (!mounted) return;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initSpeechState();
    text = '';
    stoppedByUser = false;
  }
  
  void statusListener(String status) async {
    print((status, stoppedByUser));
    // print(mounted);
    // if (!mounted) return;
    if (status == "done" && !stoppedByUser) {
      if (_currentWords.isNotEmpty) {
        setState(() {
          _lastWords += " $_currentWords";
          _currentWords = "";
        });
      } else {
        // wait 50 mil seconds and try again
        await Future.delayed(Duration(milliseconds: 50));
      }
      await _startListening();
    }
  }

  void resetErrorText() {
    setState(() {
      textError = null;
    });
  }

  Future _startListening() async {
    await _stopListening();
    await Future.delayed(const Duration(milliseconds: 50));
    speech.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(minutes: 5),
        // pauseFor: const Duration(seconds: 5),
        localeId: _currentLocaleId,
        listenOptions: SpeechListenOptions(
          // listenMode: ListenMode.confirmation,
          cancelOnError: false,
          partialResults: true,
        )
    );

    if (!mounted) return;

    setState(() {});
  }

    /// listen method.
  Future _stopListening() async {
    if (!mounted) return;
  
    setState(() {});
    await speech.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _currentWords = result.recognizedWords;
      dreamController.text = "$_lastWords $_currentWords";
      dreamScrollController.animateTo(
        dreamScrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
    });
    if (widget.onTextChanged != null) widget.onTextChanged!(dreamController.text);

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
    if (text.trim().split(whiteSpaces).length < 1) {
      setState(() {
        textError = 'Testo troppo corto. Scrivi almeno una parola.';
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

    bool isMobile = !kIsWeb;

    FloatingActionButton recordBtn = FloatingActionButton(
      shape: CircleBorder(),
      backgroundColor: Colors.red,
      tooltip: speech.isListening ? "Premi per interrompere la trascrizione." : "Premi per trascrivere il tuo sogno.",
      onPressed: () {
        if(speech.isListening){
          stoppedByUser = true;
          _stopListening();
        }else{
          stoppedByUser = false;
          _startListening();
        }
      },
      child: Icon(speech.isListening ? Icons.mic : Icons.mic_off)
    );

    FloatingActionButton recordBtnNoSpeech = const FloatingActionButton(
      shape: CircleBorder(),
      backgroundColor:  Colors.grey,
      tooltip: "Trascrizione audio non disponibile.",
      onPressed: null,
      child: Icon(Icons.mic_off)
    );

    AvatarGlow glowRecordBtn = AvatarGlow(
      animate: speech.isListening,
      glowColor: Colors.red,
      duration: const Duration(seconds: 2),
      repeat: true,
      child: _speechAvailable ? recordBtn : recordBtnNoSpeech
    );
    
    return Column(
            children: [
              SizedBox(height: screenHeight * 0.01,),
              MultilineInputField(
                controller: dreamController,
                scrollController: dreamScrollController,
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
                  "⚠️ Avviso: ricontrolla che il testo registrato sia corretto!",
                  style: TextStyle(
                    color: Colors.grey.shade900,
                    fontSize: 12
                  ),
                ),
              },
              SizedBox(height: screenHeight * 0.05,),
              glowRecordBtn
          
            ],
          );
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }



  

}
