import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/questions.dart';
import 'package:frontend/responsive_report.dart';
import 'package:frontend/utils.dart';

const List<String> answersHowMuch = [
  "Per niente.",
  "Poco.",
  "Abbastanza.",
  "Molto."
];
const List<String> answersHowDifficult = [
  "Molto difficile.",
  "Abbastanza difficile.",
  "Abbastanza facile.",
  "Facile."
];
const List<String> answersHowTired = [
  "Molto stanco.",
  "Abbastanza stanco.",
  "Abbastanza riposato.",
  "Molto riposato."
];
const List<String> answersHowEarlyLate = [
  "Mai (o quasi mai) più tardi del solito.",
  "Meno di un'ora dopo.",
  "Una o due ore dopo.",
  "Più di due ore dopo."
];

const List<int> dec5 = [5, 4, 3, 2, 1];
const List<int> dec4 = [4, 3, 2, 1];
const List<int> inc4 = [1, 2, 3, 4];

List<QA> questions = [
  QA(
      question:
          "A che ora preferiresti alzarti, più o meno, se fossi completamente libero di programmare la tua giornata?",
      answers: [
        "Tra le 5 e le 6.30 del mattino.",
        "Tra le 6.30 e le 7.45 del mattino.",
        "Tra le 7.45 e le 9.45 del mattino.",
        "Tra le 9.45 e le 11 del mattino.",
        "Tra le 11 e mezzogiorno.",
      ],
      scores: dec5),
  QA(
      question:
          "A che ora preferiresti andare a letto, più o meno, se fossi completamente libero di programmare la tua serata?",
      answers: [
        "Tra le 8 e le 9 di sera.",
        "Tra le 9 e le 10.15 di sera.",
        "Tra le 10.15 e le 00.30.",
        "Tra le 00.30 e la 1.45 di notte.",
        "Tra le 1.45 e le 3 di notte.",
      ],
      scores: dec5),
  QA(
      question:
          "Se di solito ti devi alzare ad una certa ora del mattino, hai proprio bisogno di sentire la sveglia per svegliarti?",
      answers: answersHowMuch,
      scores: dec4),
  QA(
      question:
          "Normalmente, quando non vieni risvegliato in modo inaspettato, trovi facile o difficile alzarti la mattina?",
      answers: answersHowDifficult,
      scores: inc4),
  QA(
      question:
          "Al mattino, nella prima mezz'ora che ti sei svegliato, quanto ti senti sveglio?",
      answers: answersHowMuch,
      scores: inc4),
  QA(
      question: "Nella prima mezz'ora che ti sei svegliato, hai fame?",
      answers: answersHowMuch,
      scores: inc4),
  QA(
      question: "Come ti senti nella prima mezz'ora dopo che ti sei svegliato?",
      answers: answersHowTired,
      scores: inc4),
  QA(
      question:
          "Rispetto all' orario in cui vai a letto di solito, a che ora andresti a letto se il giorno dopo non avessi impegni?",
      answers: answersHowEarlyLate,
      scores: dec4),
  QA(
      question:
          "Hai deciso di fare ginnastica insieme ad un amico, un'ora per due volte la settimana. Il tuo amico è disponibile dalle 7 alle 8 del mattino. Tenendo presente i tuoi ritmi, come te la caverai?",
      answers: [
        "Sarò in ottima forma.",
        "Sarò abbastanza in forma.",
        "Sarà dura.",
        "Sarò molto dura.",
      ],
      scores: dec4),
  QA(
      question:
          "Alla sera, a che ora più o meno ti senti stanco e hai bisogno di dormire?",
      answers: [
        "Tra le 8 e le 9 di sera.",
        "Tra le 9 e le 10.15 di sera.",
        "Tra le 10.15 e le 00.45.",
        "Tra le 00.45 e le 2 di notte.",
        "Tra le 2 e le 3 di notte.",
      ],
      scores: dec5),
  QA(
      question:
          "Devi fare un test, sai che durerà due ore, sai che sarà mentalmente molto faticoso, e vuoi essere al massimo della forma per farlo bene. Considerando i tuoi ritmi, quale orario sceglieresti?",
      answers: [
        "Dalle 8 e le 10 del mattino.",
        "Dalle 11 del mattino all' una.",
        "Dalle 3 alle 5 del pomeriggio.",
        "Dalle 7 alle 9 di sera.",
      ],
      scores: [
        6,
        4,
        2,
        0
      ]),
  QA(
      question:
          "Se dovessi andare a letto alle 11 di sera, quanto saresti stanco?",
      answers: answersHowMuch,
      scores: [0, 2, 3, 5]),
  QA(
      question:
          "Sei andato a letto alcune ore più tardi del solito, ma il giorno dopo non ti devi alzare ad un'ora particolare. Che cosa farai?",
      answers: [
        "Mi sveglierò alla solita ora e non mi riaddormenterò.",
        "Mi sveglierò alla solita ora e poi starò lì a sonnecchiare.",
        "Mi sveglierò alla solita ora e poi mi riaddormenterò.",
        "Mi sveglierò più tardi del solito.",
      ],
      scores: dec4),
  QA(
      question:
          "Questa notte dovrai stare sveglio per lavoro dalle 4 alle 6 del mattino. Il giorno dopo non hai alcun impegno. Che cosa farai?",
      answers: [
        "Non andrò a letto finchè non avrò finito di lavorare.",
        "Farò un pisolino prima e uno dopo.",
        "Farò una buona dormita prima e un pisolino dopo.",
        "Dormirò solo prima di lavorare.",
      ],
      scores: inc4),
  QA(
      question:
          "Devi fare due ore di lavoro fisicamente pesante e sei libero di pianificare la tua giornata. Considerando i tuoi ritmi, quale orario sceglieresti?",
      answers: [
        "Dalle 8 e le 10 del mattino.",
        "Dalle 11 del mattino all' una.",
        "Dalle 3 alle 5 del pomeriggio.",
        "Dalle 7 alle 9 di sera.",
      ],
      scores: dec4),
  QA(
      question:
          "Hai deciso di fare ginnastica insieme ad un amico, un'ora per due volte la settimana. Il tuo amico è disponibile dalle 10 alle 11 di sera. Tenendo presente i tuoi ritmi, come te la caverai?",
      answers: [
        "Sarò in ottima forma.",
        "Sarò abbastanza in forma.",
        "Sarà dura.",
        "Sarò molto dura.",
      ],
      scores: inc4),
  QA(
      question:
          "Supponiamo che tu possa sciegliere il tuo orario di lavoro. Sai che devi lavorare per cinque ore al giorno, sai che il tuo lavoro è interessante e vieni pagato a seconda di quanto rendi. A che ora, più o meno, sceglieresti di iniziare a lavorare?",
      answers: [
        "Tra le 4 e le 8 del mattino.",
        "Tra le 8 e le 9 del mattino.",
        "Tra le 9 del mattino e le 2 del pomeriggio.",
        "Tra le 2 e le 5 del pomeriggio.",
        "Tra le 5 del pomeriggio e le 4 di notte.",
      ],
      scores: dec5),
  QA(
      question: "A che ora del giorno, più o meno, ti senti al massimo?",
      answers: [
        "Tra le 5 e le 8 del mattino.",
        "Tra le 8 e le 10 del mattino.",
        "Tra le 10 del mattino e le 5 del pomeriggio.",
        "Tra le 5 del pomerigigo e le 10 di sera.",
        "Tra le 10 di sera e le 5 del mattino.",
      ],
      scores: dec5),
  QA(
      question:
          "Ci sono dei tipi mattutini, che sono più in forma al mattino, e tipi serotini, che sono più in forma la sera. Tu che tipo sei?",
      answers: [
        "Decisamente un tipo mattutino.",
        "Più mattutino che serotino.",
        "Più serotino che matuttino.",
        "Decisamente un tipo serotino.",
      ],
      scores: [
        6,
        4,
        2,
        1
      ])
];

(String, (String, String)) getChronotypeFromScore(int score){
  if(16 <= score && score <= 30) return ("Decisamente serotino", ("2:00-3:00","10:00-11:30"));
  if(31 <= score && score <= 41) return ("Moderatamente serotino",("00:45-2:00","8:30-10:00"));
  if(42 <= score && score <= 58) return ("Intermedio", ("22:45-00:45","6:30-8:30"));
  if(59 <= score && score <= 69) return ("Moderatamente mattutino",("21:30-22:45","5:00-6:30"));
  if(70 <= score && score <= 86) return ("Decisamente mattutino", ("21:00-21:30","4:00-5:00"));

  throw Exception("Error during the calcualtion of the chronotype.");
}


class ChronoType extends StatefulWidget {
  const ChronoType({super.key});
  @override
  State<ChronoType> createState() => _ChronoTypeState();
}

class _ChronoTypeState extends State<ChronoType> {
  ChronoTypeData chronoType = ChronoTypeData();
  late List<QuestionWithDirection> chronoTypeQuestions;
  bool showScore = false;

  @override
  void initState() {
    super.initState();
    chronoTypeQuestions =
        List<MultipleChoiceQuestion>.generate(questions.length, (index) {
      var q = questions[index].question;
      var a = questions[index].answers;
      List<int> s = questions[index].scores;
      var mcq = MultipleChoiceQuestion(
        question: q,
        answers: a,
        onSelected: (value) {
          setState(() {
            chronoType.report[index] = s[value];
          });
        },
      );
      chronoType.report[index] = s[mcq.initialValue];
      return mcq;
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;

    return !showScore
        ? ResponsiveReport(
            questionWidgets: chronoTypeQuestions,
            title: "Cronotipo",
            onSubmitted: () async{
              await addMyChronotype(chronoType);
              setState(()  {
                showScore = true;
              });
            })
        : Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    const Text(
                      "Il tuo cronotipo",
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
                    Text("${chronoType.score()}"),
                    SizedBox(height: screenHeight * 0.01,),
                    const Text(
                      "Il tuo risultato è",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("${getChronotypeFromScore(chronoType.score()).$1}"),
                    SizedBox(height: screenHeight * 0.01,),
                    Container(
                      width: 500,
                      child: const Text(
                        "Per verificare l'attendibilità del risulato, confronta se gli orari qui riportati rispecchiano approssimativamente l'orario di risveglio e addormentamento",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            Text("Addormentamento", style: TextStyle(fontWeight: FontWeight.bold),),
                            Text("${getChronotypeFromScore(chronoType.score()).$2.$1}"),
                          ],
                        ),
                        SizedBox(width: 10,),
                        Column(
                          children: [
                            Text("Risveglio", style: TextStyle(fontWeight: FontWeight.bold),),
                            Text("${getChronotypeFromScore(chronoType.score()).$2.$2}"),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01,),
                    FormButton(
                      text: "Iniziamo!",
                      onPressed: () => Navigator.pushNamed(context, "/home_user"),
                    ),
                  ],
                ),
              )
              
            ),
          );
  }
}

