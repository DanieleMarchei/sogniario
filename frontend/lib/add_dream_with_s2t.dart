import 'dart:async';
import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:record/record.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';

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
  QA(
      question:
          "Quanto controllo volontario avevi sul contenuto e sullo svolgimento del sogno?",
      answers: [
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
  final dreamKey = GlobalKey<AddDreamWithS2TTextState>();

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
          minValue: 1,
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
      homeButtonTooltip:
          "Vuoi annullare il racconto di questo sogno e tornare alla schermata principale?",
      onPageChanged: (pageNumber) async {
        print(pageNumber);
        if (pageNumber != 1) {
          await dreamKey.currentState?._stopRecording();
        }
      },
      onExit: () async{
        await dreamKey.currentState?._closeConnection();
      },
      onSubmitted: () async {
        await dreamKey.currentState?._closeConnection();
        await addDream(dream);
        context.goNamed(Routes.homeUser.name);
      },
      unansweredQuestions: () {
        List<int> uq = [];
        if (dream.dreamText.split(" ").length < 1) {
          uq.add(0);
        }
        for (var i = 0; i < dream.report.length; i++) {
          if (dream.report[i] == null) uq.add(i + 1);
        }

        return uq;
      },
    );

    return responsiveReport;
  }
}

class AddDreamWithS2TText extends QuestionWithDirection {
  final Function? onTextChanged;

  AddDreamWithS2TText({super.key, this.onTextChanged})
      : super(canChangeDirection: false, direction: Axis.vertical);

  @override
  State<AddDreamWithS2TText> createState() => AddDreamWithS2TTextState();
}

class AddDreamWithS2TTextState
    extends QuestionWithDirectionState<AddDreamWithS2TText> {
  String? textError;

  @override
  bool get wantKeepAlive => true;

  final AudioRecorder _record = AudioRecorder();
  bool _isRecording = false;

  String _partialText = "";
  String _finalText = "";
  String _lastPartialText = "";

  StreamSubscription? subscription;
  late StreamController<String> _streamController;

  TextSelection selection = TextSelection(baseOffset: 0, extentOffset: 0);

  WebSocketChannel? _channel;

  TextEditingController dreamController = TextEditingController();
  ScrollController dreamScrollController = ScrollController();

  void _connectWebSocket() {
    String protocol = "wss";
    if(isDevelopment) protocol = "ws";
    
    String jwt = tokenBox.get(HiveBoxes.jwt.label);
    _channel = WebSocketChannel.connect(
      Uri.parse('$protocol://$wsAuthority/?auth=$jwt'),
    );
  }

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
    _streamController = StreamController<String>();

    _channel!.stream.listen((message) {
      _streamController.add(message);
    });
    dreamController.addListener(() => widget.onTextChanged!(dreamController.text));
  }

  Future<void> _startRecording() async {
    bool hasPermission = await _record.hasPermission();
    if (!hasPermission) {
      print('Permission denied.');
      return;
    }

    // var config = RecordConfig(encoder: AudioEncoder.pcm16bits, sampleRate: 44100, numChannels: 1);
    var config = const RecordConfig(
        encoder: AudioEncoder.pcm16bits, sampleRate: 44100, numChannels: 1);
    // await recordStream(_record, config);

    var stream = await _record.startStream(config);
    stream.listen((audioBuffer) async {
      if (!await _record.isRecording()) {
        return;
      }

      if (audioBuffer.isNotEmpty && _channel != null) {
        _channel!.sink.add(audioBuffer);
      }
      await Future.delayed(const Duration(milliseconds: 200));
    });

    subscription ??= _streamController.stream.listen((message) {        
        var receivedJson = jsonDecode(message);
        _lastPartialText = _partialText;
        if (receivedJson.containsKey('partial')) {
          setState(() {
            _partialText = receivedJson['partial'];
            _finalText = "";

          });
        } else if (receivedJson.containsKey('text')) {
          setState(() {
            _partialText = "";
            _finalText = receivedJson['text'] + " ";
          });
        }
        _updateTextField();

      });

    setState(() {
      _isRecording = true;
    });
  }


  void _updateTextField() {
    final cursorPosition = dreamController.selection.baseOffset;
    final text = dreamController.text;

    final textToAdd = _finalText != "" ? _finalText : _partialText;

    if (cursorPosition < 0 || cursorPosition > text.length) {
      // If the cursor position is invalid, place it at the end
      dreamController.value = dreamController.value.copyWith(
        text: text + textToAdd,
        selection: TextSelection.collapsed(offset: (text + textToAdd).length),
      );
    } else {
      final newText = text.substring(0, cursorPosition - _lastPartialText.length) + textToAdd + text.substring(cursorPosition);
      dreamController.value = dreamController.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: cursorPosition - _lastPartialText.length + textToAdd.length),
      );
    }

    // if (widget.onTextChanged != null) widget.onTextChanged!(dreamController.text);
    // dreamController.text = dreamController.text.trim();
  }

  void resetErrorText() {
    setState(() {
      textError = null;
    });
  }

  Future<void> _closeConnection() async {
    if (await _record.isRecording()) {
      await _stopRecording();
    }
    _channel?.sink.close(status.normalClosure);
  }

  Future<void> _stopRecording() async {
    await _record.stop();
    _partialText = "";
    _lastPartialText = "";
    // await subscription!.cancel();
    setState(() {
      _isRecording = false;
    });
  }

  // void _onSpeechResult(SpeechRecognitionResult result) {
  //   setState(() {
  //     _currentWords = result.recognizedWords;
  //     dreamController.text = "$_lastWords $_currentWords";
  //     dreamScrollController.animateTo(
  //       dreamScrollController.position.maxScrollExtent,
  //       duration: Duration(milliseconds: 300), curve: Curves.ease);
  //   });
  //   if (widget.onTextChanged != null) widget.onTextChanged!(dreamController.text);

  // }

  bool validate() {
    resetErrorText();

    if (dreamController.text.isEmpty) {
      setState(() {
        textError = 'Testo non presente';
      });
      return false;
    }
    RegExp whiteSpaces = RegExp(r'\s+', multiLine: true);
    if (dreamController.text.trim().split(whiteSpaces).length < 1) {
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
        tooltip: _isRecording
            ? "Premi per interrompere la trascrizione."
            : "Premi per trascrivere il tuo sogno.",
        onPressed: () {
          if (_isRecording) {
            _stopRecording();
          } else {
            _startRecording();
          }
        },
        child: Icon(_isRecording ? Icons.mic : Icons.mic_off));

    // FloatingActionButton recordBtnNoSpeech = const FloatingActionButton(
    //   shape: CircleBorder(),
    //   backgroundColor:  Colors.grey,
    //   tooltip: "Trascrizione audio non disponibile.",
    //   onPressed: null,
    //   child: Icon(Icons.mic_off)
    // );

    AvatarGlow glowRecordBtn = AvatarGlow(
        animate: _isRecording,
        glowColor: Colors.red,
        duration: const Duration(seconds: 2),
        repeat: true,
        child: recordBtn);

    return Column(
            children: [
              SizedBox(
                height: screenHeight * 0.01,
              ),
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
                    resetErrorText();
                    if (widget.onTextChanged != null) {
                      widget.onTextChanged!(value);
                    }
                  });
                },
                autoFocus: false,
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Text(
                "⚠️ Avviso: ricontrolla che il testo registrato sia corretto!",
                style: TextStyle(color: Colors.grey.shade900, fontSize: 12),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              glowRecordBtn
            ],
          );
  }

  @override
  void dispose() {
    _closeConnection();
    super.dispose();
  }
}
