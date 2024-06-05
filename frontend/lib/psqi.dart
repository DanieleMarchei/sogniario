import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/api.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/pickers.dart';
import 'package:frontend/questions.dart';
import 'package:frontend/responsive_report.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/utils.dart';
import 'package:go_router/go_router.dart';

const List<String> answersHowMany = [
  "Non durante l'ultimo mese",
  "Meno di una volta a settimana",
  "Una o due volte a settimana",
  "Tre o più volte a settimana"
];
const List<String> answersQuality = [
  "Molto buona",
  "Abbastanza buona",
  "Abbastanza cattiva",
  "Molto cattiva"
];
const List<String> answersHowMuch = [
  "Per niente",
  "Poco",
  "Abbastanza",
  "Molto"
];

class PSQI extends StatefulWidget {
  const PSQI({super.key});
  @override
  State<PSQI> createState() => _PSQIState();
}

class _PSQIState extends State<PSQI> {
  PSQIData psqi = PSQIData();
  late List<QuestionWithDirection> psqiQuestions;

  bool showScore = false;

  @override
  void initState() {
    super.initState();
    psqiQuestions = [
      // 1
      SelectHourQuestion(
        question:
            "Nell' ultimo mese, di solito, a che ora sei andato/a a letto la sera?",
        onSelected: (TimeOfDay t) {
          setState(() {
            psqi.timeToBed = t;
          });
        },
      ),

      // 2
      SelectIntQuestion(
        question:
            "Nell' ultimo mese, di solito, quanto tempo (in minuti) hai impiegato ad addormentarti ogni notte?",
        text: "",
        maxValue: 120,
        onSelected: (int i, int option) {
          setState(() {
            psqi.minutesToFallAsleep = i;
          });
        },
      ),

      // 3
      SelectHourQuestion(
        question:
            "Nell' ultimo mese, di solito, a che ora ti sei alzato/a al mattino?",
        onSelected: (TimeOfDay t) {
          setState(() {
            psqi.timeWokeUp = t;
          });
        },
      ),

      // 4A
      SelectTwoIntsQuestion(
        question: "Nell' ultimo mese, quante ore hai dormito effettivamente per notte? (potrebbero essere diverse dal numero di ore passate a letto)",
        text1: "ore",
        text2: "minuti",
        minValue1: 4,
        maxValue1: 14,
        maxValue2: 55,
        increment2: 5,
        onSelected: (int i1, int i2) {
          setState(() {
            psqi.timeAsleep = Duration(hours: i1, minutes: i2);
          });
        },
      ),

      // 5A
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese, quanto spesso ti capita di non riuscire ad addormentarti entro 30 minuti?",
        answers: answersHowMany,
        onSelected: (int i) {
          setState(() {
            psqi.notFallAsleepWithin30Minutes = i;
          });
        },
      ),

      // 5B
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese, quanto spesso ti capita di svegliarti nel mezzo della notte o al mettino presto senza riaddormentarsi?",
        answers: answersHowMany,
        onSelected: (int i) {
          setState(() {
            psqi.wakeUpWithoutFallingAsleepAgain = i;
          });
        },
      ),
      
      // 5C
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese, quanto spesso ti capita di alzarti nel mezzo della notte per andare in bagno?",
        answers: answersHowMany,
        onSelected: (int i) {
          setState(() {
            psqi.goToTheBathroom = i;
          });
        },
      ),

      // 5D
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese, quanto spesso ti capita di non riuscire a respirare bene?",
        answers: answersHowMany,
        onSelected: (int i) {
          setState(() {
            psqi.notBreethingCorrectly = i;
          });
        },
      ),

      // 5E
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese, quanto spesso ti capita di tossire o russare forte?",
        answers: answersHowMany,
        onSelected: (int i) {
          setState(() {
            psqi.coughOrSnort = i;
          });
        },
      ),

      // 5F
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese, quanto spesso ti capita di sentire troppo freddo?",
        answers: answersHowMany,
        onSelected: (int i) {
          setState(() {
            psqi.tooCold = i;
          });
        },
      ),

      // 5G
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese, quanto spesso ti capita di sentire troppo caldo?",
        answers: answersHowMany,
        onSelected: (int i) {
          setState(() {
            psqi.tooHot = i;
          });
        },
      ),

      // 5H
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese, quanto spesso ti capita di fare brutti sogni?",
        answers: answersHowMany,
        onSelected: (int i) {
          setState(() {
            psqi.badDreams = i;
          });
        },
      ),

      // 5I
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese, quanto spesso ti capita di avere dolori?",
        answers: answersHowMany,
        onSelected: (int i) {
          setState(() {
            psqi.havingPain = i;
          });
        },
      ),

      // 5J
      SpecifyIfYesQuestion(
        question1: "C'è qualche altro problema che può aver disturbato il tuo sonno?",
        question2:
            "E quanto spesso hai avuto problemi a dormire per questo motivo?",
        answers: answersHowMany,
        onSelected: (bool b, String? s, int? i2) {
          setState(() {
            psqi.otherProblems = b;
            psqi.optionalText = s;
            psqi.otherProblemsFrequency = i2;
          });
        },
      ),

      // 9
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese, come valuti complessivamente la qualità del tuo sonno?",
        answers: answersQuality,
        onSelected: (int i) {
          setState(() {
            psqi.sleepQuality = i;
          });
        }
      ),

      // 6
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese, quanto spesso hai preso farmaci (prescritti dal medico o meno) per aiutarti a dormire?",
        answers: answersHowMany,
        onSelected: (int i) {
          setState(() {
            psqi.drugs = i;
          });
        }
      ),

      // 7
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese, quanto spesso hai avuto difficoltà a rimanere sveglio/a alla guida o nel corso di attività sociali?",
        answers: answersHowMany,
        onSelected: (int i) {
          setState(() {
            psqi.difficultiesBeingAwake = i;
          });
        }
      ),
      
      // 8
      MultipleChoiceQuestion(
        question:
            "Nell' ultimo mese, hai avuto problemi ad avere energie sufficienti per concludere le tue normali attività?",
        answers: answersHowMuch,
        onSelected: (int i) {
          setState(() {
            psqi.enoughEnergies = i;
          });
        }
      ),


    ];

    // psqi.report[0] = (psqiQuestions[0] as WithInitialValue).initialValue;
    // psqi.report[1] = (psqiQuestions[1] as WithInitialValue).initialValue;
    // psqi.report[2] = (psqiQuestions[2] as WithInitialValue).initialValue;

    // (int, int) r3 = (psqiQuestions[3] as WithInitialValue).initialValue;
    // psqi.report[3] = r3.$1 + r3.$2 / 100;

    // (int, int) r4 = (psqiQuestions[4] as WithInitialValue).initialValue;
    // psqi.report[4] = r4.$1 + r4.$2 / 100;
    
    // psqi.report[5] = (psqiQuestions[5] as WithInitialValue).initialValue;
    // psqi.report[6] = (psqiQuestions[6] as WithInitialValue).initialValue;
    // psqi.report[7] = (psqiQuestions[7] as WithInitialValue).initialValue;
    // psqi.report[8] = (psqiQuestions[8] as WithInitialValue).initialValue;
    // psqi.report[9] = (psqiQuestions[9] as WithInitialValue).initialValue;
    // psqi.report[10] = (psqiQuestions[10] as WithInitialValue).initialValue;
    // psqi.report[11] = (psqiQuestions[11] as WithInitialValue).initialValue;
    // psqi.report[12] = (psqiQuestions[12] as WithInitialValue).initialValue;
    // psqi.report[13] = (psqiQuestions[13] as WithInitialValue).initialValue;

    // (bool, String?, int?) r14 = (psqiQuestions[14] as WithInitialValue).initialValue as (bool, String?, int?);
    // psqi.report[14] = [null, 0, 1, 2].indexOf(r14.$3);
    // psqi.optionalText = r14.$2;
    
    // psqi.report[15] = (psqiQuestions[15] as WithInitialValue).initialValue;
    // psqi.report[16] = (psqiQuestions[16] as WithInitialValue).initialValue;
    // psqi.report[17] = (psqiQuestions[17] as WithInitialValue).initialValue;
    // psqi.report[18] = (psqiQuestions[18] as WithInitialValue).initialValue;

  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    
    return !showScore ? ResponsiveReport(
      questionWidgets: psqiQuestions,
      homeButtonTooltip: "Vuoi annullare la compilazione del PSQI e tornare alla schermata principale?",
      title: "PSQI", 
      onSubmitted: () async {
        bool success = await addMyPSQI(psqi);
        if(!success){
          Fluttertoast.showToast(
            msg: "Errore: impossibile inviare il questionario.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 12.0);
        }
        setState(() {
          showScore = true;
        });
      },
      unansweredQuestions: () { 
        List<int> uq = [];
        if(psqi.timeToBed == null){
          uq.add(0);
        }
        if(psqi.minutesToFallAsleep == null){
          uq.add(1);
        }
        if(psqi.timeWokeUp == null){
          uq.add(2);
        }
        if(psqi.timeAsleep == null){
          uq.add(3);
        }
        if(psqi.notFallAsleepWithin30Minutes == null){
          uq.add(4);
        }
        if(psqi.wakeUpWithoutFallingAsleepAgain == null){
          uq.add(5);
        }
        if(psqi.goToTheBathroom == null){
          uq.add(6);
        }
        if(psqi.notBreethingCorrectly == null){
          uq.add(7);
        }
        if(psqi.coughOrSnort == null){
          uq.add(8);
        }
        if(psqi.tooCold == null){
          uq.add(9);
        }
        if(psqi.tooHot == null){
          uq.add(10);
        }
        if(psqi.badDreams == null){
          uq.add(11);
        }
        if(psqi.havingPain == null){
          uq.add(12);
        }

        if(psqi.otherProblems == null){
          uq.add(13);
        }else{
          if(psqi.otherProblems! && (psqi.optionalText == null || psqi.optionalText!.isEmpty || psqi.otherProblemsFrequency == null)){
            uq.add(13);
          }
        }
        
        if(psqi.sleepQuality == null){
          uq.add(14);
        }
        if(psqi.drugs == null){
          uq.add(15);
        }
        if(psqi.difficultiesBeingAwake == null){
          uq.add(16);
        }
        if(psqi.enoughEnergies == null){
          uq.add(17);
        }

        return uq;
      },
    ) : Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    const Text(
                      "Il tuo PSQI",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Punteggio",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("${psqi.score()}"),
                    SizedBox(height: screenHeight * 0.01,),
                    FormButton(
                      text: "Torna alla home",
                      onPressed: () {
                        context.goNamed(Routes.homeUser.name);
                      },
                    ),
                  ]
                )
              )
            )
    );
  }

  
}
