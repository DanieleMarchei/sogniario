import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/home.dart';
import 'package:frontend/questions.dart';
import 'package:frontend/responsiveReport.dart';
import 'package:frontend/utils.dart';

const List<String> answersHowMany = [
  "Non durante l'ultimo mese.",
  "Meno di una volta a settimana.",
  "Una o due volte a settimana.",
  "Tre o più volte a settimana."
];
const List<String> answersQuality = [
  "Molto buona.",
  "Abbastanza buona.",
  "Abbastanza cattiva.",
  "Molto cattiva."
];
const List<String> answersHowMuch = [
  "Per niente.",
  "Poco.",
  "Abbastanza.",
  "Molto."
];

// class PSQI extends StatefulWidget {
//   const PSQI({super.key});
//   @override
//   State<PSQI> createState() => _PSQIState();
// }

// class _PSQIState extends State<PSQI> {
//   int _current = 1;
//   final CarouselController _controller = CarouselController();
//   PSQIData psqi = PSQIData();
//   late List<Widget> psqiQuestions;

//   @override
//   List<Widget> buildQuestions(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     bool showMobileLayout = screenWidth < widthConstraint;
//     Axis direction = showMobileLayout ? Axis.vertical : Axis.horizontal;

//     return [
//       SelectHourQuestion(
//         question:
//             "Nell' ultimo mese, di solito, a che ora sei andato a dormire la sera?",
//         onSelected: (TimeOfDay t) {
//           setState(() {
//             psqi.report[0] = t;
//           });
//         },
//         direction: direction,
//       ),
//       SelectIntQuestion(
//         question:
//             "Nell' ultimo mese, di solito, quanto tempo (in minuti) hai impiegato ad addormentarti?",
//         maxValue: 120,
//         onSelected: (int i) {
//           setState(() {
//             psqi.report[1] = i;
//           });
//         },
//         direction: direction,
//       ),
//       SelectHourQuestion(
//         question:
//             "Nell' ultimo mese, di solito, a che ora ti sei alzato al mattino?",
//         onSelected: (TimeOfDay t) {
//           setState(() {
//             psqi.report[2] = t;
//           });
//         },
//         direction: direction,
//       ),
//       SelectTwoIntsQuestion(
//         question:
//             "Nell' ultimo mese, quante ore hai dormito effettivamente per notte?",
//         onSelected: (int i1, int i2) {
//           setState(() {
//             psqi.report[3] = (i1, i2);
//           });
//         },
//         direction: direction,
//       ),
//       SelectTwoIntsQuestion(
//         question: "Quante ore hai passato nel letto?",
//         onSelected: (int i1, int i2) {
//           setState(() {
//             psqi.report[4] = (i1, i2);
//           });
//         },
//         direction: direction,
//       ),
//       MultipleChoiceQuestion(
//         question:
//             "Nell' ultimo mese quanto frequentemente ti capita di non riuscire ad addormentarti entro 30 minuti?",
//         answers: answersHowMany,
//         onSelected: (int i) {
//           setState(() {
//             psqi.report[5] = i;
//           });
//         },
//       ),
//       MultipleChoiceQuestion(
//         question:
//             "Nell' ultimo mese quanto frequentemente ti capita di svegliarti nel mezzo della notte o al mettino presto senza riaddormentarsi?",
//         answers: answersHowMany,
//         onSelected: (int i) {
//           setState(() {
//             psqi.report[6] = i;
//           });
//         },
//       ),
//       MultipleChoiceQuestion(
//         question:
//             "Nell' ultimo mese quanto frequentemente ti capita di alzarti nel mezzo della notte per andare in bagno?",
//         answers: answersHowMany,
//         onSelected: (int i) {
//           setState(() {
//             psqi.report[7] = i;
//           });
//         },
//       ),
//       MultipleChoiceQuestion(
//         question:
//             "Nell' ultimo mese quanto frequentemente ti capita di non riuscire a respirare bene?",
//         answers: answersHowMany,
//         onSelected: (int i) {
//           setState(() {
//             psqi.report[8] = i;
//           });
//         },
//       ),
//       MultipleChoiceQuestion(
//         question:
//             "Nell' ultimo mese quanto frequentemente ti capita di tossire o russare forte?",
//         answers: answersHowMany,
//         onSelected: (int i) {
//           setState(() {
//             psqi.report[9] = i;
//           });
//         },
//       ),
//       MultipleChoiceQuestion(
//         question:
//             "Nell' ultimo mese quanto frequentemente ti capita di sentire troppo freddo?",
//         answers: answersHowMany,
//         onSelected: (int i) {
//           setState(() {
//             psqi.report[10] = i;
//           });
//         },
//       ),
//       MultipleChoiceQuestion(
//         question:
//             "Nell' ultimo mese quanto frequentemente ti capita di sentire troppo caldo?",
//         answers: answersHowMany,
//         onSelected: (int i) {
//           setState(() {
//             psqi.report[11] = i;
//           });
//         },
//       ),
//       MultipleChoiceQuestion(
//         question:
//             "Nell' ultimo mese quanto frequentemente ti capita di fare brutti sogni?",
//         answers: answersHowMany,
//         onSelected: (int i) {
//           setState(() {
//             psqi.report[12] = i;
//           });
//         },
//       ),
//       MultipleChoiceQuestion(
//         question:
//             "Nell' ultimo mese quanto frequentemente ti capita di avere dolori?",
//         answers: answersHowMany,
//         onSelected: (int i) {
//           setState(() {
//             psqi.report[13] = i;
//           });
//         },
//       ),
//       SpecifyIfYesQuestion(
//         question1: "Qualche altro problema può aver disturbato il tuo sonno?",
//         question2:
//             "Quanto spesso hai avuto problemi a dormire per questo motivo?",
//         answers: answersHowMany.sublist(1),
//         onSelected: (int i1, String? s, int? i2) {
//           setState(() {
//             psqi.report[14] = (i1, s, i2);
//           });
//         },
//       ),
//       MultipleChoiceQuestion(
//           question:
//               "Nell' ultimo mese, come valuti complessivamente la qualità del tuo sonno?",
//           answers: answersQuality,
//           onSelected: (int i) {
//             setState(() {
//               psqi.report[15] = i;
//             });
//           }),
//       MultipleChoiceQuestion(
//           question:
//               "Nell' ultimo mese, quanto spesso hai preso farmaci (prescritti dal medico o meno) per facilitare il sonno?",
//           answers: answersHowMany,
//           onSelected: (int i) {
//             setState(() {
//               psqi.report[16] = i;
//             });
//           }),
//       MultipleChoiceQuestion(
//           question:
//               "Nell' ultimo mese, quanto spesso hai avuto difficoltà a rimanere sveglio alla guida o nel corso di attività sociali?",
//           answers: answersHowMany,
//           onSelected: (int i) {
//             setState(() {
//               psqi.report[17] = i;
//             });
//           }),
//       MultipleChoiceQuestion(
//           question:
//               "Nell' ultimo mese, hai avuto problemi ad avere energie sufficienti per concludere le tue normali attività?",
//           answers: answersHowMuch,
//           onSelected: (int i) {
//             setState(() {
//               psqi.report[18] = i;
//             });
//           })
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     bool showMobileLayout = screenWidth < widthConstraint;

//     psqiQuestions = buildQuestions(context);

//     late Widget widgetToShow;
//     if (showMobileLayout) {
//       widgetToShow = mobileWidgets(context);
//     } else {
//       widgetToShow = desktopWidgets(context);
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: Text("PSQI"),
//       ),
//       body: Center(
//         child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 50),
//               child: ConstrainedBox(
//                       constraints: BoxConstraints.tightFor(width: min(screenWidth, widthConstraint)),
//                       child: widgetToShow
//                   )
//               ),
//       )
//     );
//   }

//   Widget desktopWidgets(BuildContext context) {
//     SizedBox spacingBox = SizedBox(height: 15,);
//     List<Widget> desktopQuestions = [spacingBox];

//     for (var question in psqiQuestions) {
//       desktopQuestions.add(question);
//       desktopQuestions.add(spacingBox);
//     }

//     FormButton sendPsqi = FormButton(text: "Conferma", onPressed: () {Navigator.pop(context);},);
//     desktopQuestions.add(sendPsqi);
//     return ListView(
//         children: desktopQuestions,
//       );
//   }

//   Widget mobileWidgets(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Center(
//       child: SingleChildScrollView(
//             child: Column(
//               children: 
//         [SizedBox(height: screenHeight * .01),
//         CarouselSlider(
//           items: psqiQuestions,
//           options: CarouselOptions(
//             viewportFraction: 1,
//             enlargeCenterPage: false,
//             height: screenHeight / 1.3,
//             enableInfiniteScroll: false,
//             autoPlay: false,
//             onPageChanged: (index, reason) {
//               setState(() {
//                 _current = index + 1;
//               });
//             },
//           ),
//           carouselController: _controller,
//         ),
//         Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
//           Flexible(
//             child: ElevatedButton(
//               onPressed: _current > 1
//                   ? () {
//                       setState(() {
//                         _current -= 1;
//                         _controller.previousPage();
//                       });
//                     }
//                   : null,
//               child: const Icon(Icons.arrow_back),
//             ),
//           ),
//           Flexible(child: Text("${_current}/19")),
//           Flexible(
//             child: ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _current += 1;
//                   _controller.nextPage();
//                   if (_current == 19) {
//                     Navigator.pop(context);
//                   }
//                 });
//               },
//               child: _current < 19
//                   ? const Icon(Icons.arrow_forward)
//                   : const Icon(Icons.check),
//             ),
//           )
//         ])
//       ])),
//     );
//   }
// }








class PSQI extends StatefulWidget {
  const PSQI({super.key});
  @override
  State<PSQI> createState() => _PSQIState();
}

class _PSQIState extends State<PSQI> {
  PSQIData psqi = PSQIData();
  late List<QuestionWithDirection> psqiQuestions;

  @override
  void initState() {
    super.initState();

    psqiQuestions = [
      SelectHourQuestion(
        question:
            "Nell' ultimo mese, di solito, a che ora sei andato a dormire la sera?",
        onSelected: (TimeOfDay t) {
          setState(() {
            psqi.report[0] = t;
          });
        },
      ),
      SelectIntQuestion(
        question:
            "Nell' ultimo mese, di solito, quanto tempo (in minuti) hai impiegato ad addormentarti?",
        maxValue: 120,
        onSelected: (int i) {
          setState(() {
            psqi.report[1] = i;
          });
        },
      ),
      SelectHourQuestion(
        question:
            "Nell' ultimo mese, di solito, a che ora ti sei alzato al mattino?",
        onSelected: (TimeOfDay t) {
          setState(() {
            psqi.report[2] = t;
          });
        },
      ),
      SelectTwoIntsQuestion(
        question:
            "Nell' ultimo mese, quante ore hai dormito effettivamente per notte?",
        onSelected: (int i1, int i2) {
          setState(() {
            psqi.report[3] = (i1, i2);
          });
        },
      ),
      SelectTwoIntsQuestion(
        question: "Quante ore hai passato nel letto?",
        onSelected: (int i1, int i2) {
          setState(() {
            psqi.report[4] = (i1, i2);
          });
        },
      ),
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese quanto frequentemente ti capita di non riuscire ad addormentarti entro 30 minuti?",
        answers: answersHowMany,
        onSelected: (int i) {
          setState(() {
            psqi.report[5] = i;
          });
        },
      ),
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese quanto frequentemente ti capita di svegliarti nel mezzo della notte o al mettino presto senza riaddormentarsi?",
        answers: answersHowMany,
        onSelected: (int i) {
          setState(() {
            psqi.report[6] = i;
          });
        },
      ),
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese quanto frequentemente ti capita di alzarti nel mezzo della notte per andare in bagno?",
        answers: answersHowMany,
        onSelected: (int i) {
          setState(() {
            psqi.report[7] = i;
          });
        },
      ),
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese quanto frequentemente ti capita di non riuscire a respirare bene?",
        answers: answersHowMany,
        onSelected: (int i) {
          setState(() {
            psqi.report[8] = i;
          });
        },
      ),
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese quanto frequentemente ti capita di tossire o russare forte?",
        answers: answersHowMany,
        onSelected: (int i) {
          setState(() {
            psqi.report[9] = i;
          });
        },
      ),
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese quanto frequentemente ti capita di sentire troppo freddo?",
        answers: answersHowMany,
        onSelected: (int i) {
          setState(() {
            psqi.report[10] = i;
          });
        },
      ),
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese quanto frequentemente ti capita di sentire troppo caldo?",
        answers: answersHowMany,
        onSelected: (int i) {
          setState(() {
            psqi.report[11] = i;
          });
        },
      ),
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese quanto frequentemente ti capita di fare brutti sogni?",
        answers: answersHowMany,
        onSelected: (int i) {
          setState(() {
            psqi.report[12] = i;
          });
        },
      ),
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese quanto frequentemente ti capita di avere dolori?",
        answers: answersHowMany,
        onSelected: (int i) {
          setState(() {
            psqi.report[13] = i;
          });
        },
      ),
      SpecifyIfYesQuestion(
        question1: "Qualche altro problema può aver disturbato il tuo sonno?",
        question2:
            "Quanto spesso hai avuto problemi a dormire per questo motivo?",
        answers: answersHowMany.sublist(1),
        onSelected: (int i1, String? s, int? i2) {
          setState(() {
            psqi.report[14] = (i1, s, i2);
          });
        },
      ),
      MultipleChoiceQuestion(
          question:
              "Nell' ultimo mese, come valuti complessivamente la qualità del tuo sonno?",
          answers: answersQuality,
          onSelected: (int i) {
            setState(() {
              psqi.report[15] = i;
            });
          }),
      MultipleChoiceQuestion(
          question:
              "Nell' ultimo mese, quanto spesso hai preso farmaci (prescritti dal medico o meno) per facilitare il sonno?",
          answers: answersHowMany,
          onSelected: (int i) {
            setState(() {
              psqi.report[16] = i;
            });
          }),
      MultipleChoiceQuestion(
          question:
              "Nell' ultimo mese, quanto spesso hai avuto difficoltà a rimanere sveglio alla guida o nel corso di attività sociali?",
          answers: answersHowMany,
          onSelected: (int i) {
            setState(() {
              psqi.report[17] = i;
            });
          }),
      MultipleChoiceQuestion(
          question:
              "Nell' ultimo mese, hai avuto problemi ad avere energie sufficienti per concludere le tue normali attività?",
          answers: answersHowMuch,
          onSelected: (int i) {
            setState(() {
              psqi.report[18] = i;
            });
          })
    ];
  }

  @override
  Widget build(BuildContext context) {


    return ResponsiveReport(
      questionWidgets: psqiQuestions, 
      title: "PSQI", 
      onSubmitted: () {Navigator.pop(context);}
    );
  }

  
}
