import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/questions.dart';

class QA {
  final String question;
  final List<String> answers;

  const QA({
    required this.question,
    required this.answers
    });
}

const List<String> answersHowMuch = ["Per niente.", "Poco.", "Abbastanza.", "Molto."];
const List<String> answersHowDifficult = ["Molto difficile.", "Abbastanza difficile.", "Abbastanza facile.", "Facile."];
const List<String> answersHowTired = ["Molto stanco.", "Abbastanza stanco.", "Abbastanza riposato.", "Molto riposato."];
const List<String> answersHowEarlyLate = ["Mai (o quasi mai) più tardi del solito.", "Meno di un'ora dopo.", "Una o due ore dopo.", "Più di due ore dopo."];

const List<QA> questions = [
  QA(
    question: "A che ora preferiresti alzarti, più o meno, se fossi completamente libero di programmare la tua giornata?", 
    answers: [
      "Tra le 5 e le 6.30 del mattino.",
      "Tra le 6.30 e le 7.45 del mattino.",
      "Tra le 7.45 e le 9.45 del mattino.",
      "Tra le 9.45 e le 11 del mattino.",
      "Tra le 11 e mezzogiorno.",
      ]),
    QA(
    question: "A che ora preferiresti andare a letto, più o meno, se fossi completamente libero di programmare la tua serata?", 
    answers: [
      "Tra le 8 e le 9 di sera.",
      "Tra le 9 e le 10.15 di sera.",
      "Tra le 10.15 e le 00.30.",
      "Tra le 00.30 e la 1.45 di notte.",
      "Tra le 1.45 e le 3 di notte.",
      ]),
    QA(question: "Se di solito ti devi alzare ad una cera ora del mattino, hai proprio bisogno di sentire la sveglia per svegliarti?", answers: answersHowMuch),
    QA(question: "Normalmente, quando non vieni risvegliato in modo inaspettato, trovi facile o difficile alzarti la mattina?", answers: answersHowDifficult),
    QA(question: "Al mattino, nella prima mezz'ora che ti sei svegliato, quanto ti senti sveglio?", answers: answersHowMuch),
    QA(question: "Nella prima mezz'ora che ti sei svegliato, hai fame?", answers: answersHowMuch),
    QA(question: "Come ti senti nella prima mezz'ora dopo che ti sei svegliato?", answers: answersHowTired),
    QA(question: "Rispetto allì orario in cui vai a letto di solito, a che ora andresti a letto se il giorno dopo non avessi impegni?", answers: answersHowEarlyLate),
    QA(question: "Hai deciso di fare ginnastica insieme ad un amico, un'ora per due volte la settimana. Il tuo amico è disponibile dalle 7 alle 8 del mattino. Tenendo presente i tuoi ritmi, come te la caverai?", answers: [
      "Sarò in ottima forma.",
      "Sarò abbastanza in forma.",
      "Sarà dura.",
      "Sarò molto dura.",
    ]),
    QA(
    question: "Alla sera, a che ora più o meno ti senti stanco e hai bisogno di dormire?", 
    answers: [
      "Tra le 8 e le 9 di sera.",
      "Tra le 9 e le 10.15 di sera.",
      "Tra le 10.15 e le 00.45.",
      "Tra le 00.45 e le 2 di notte.",
      "Tra le 2 e le 3 di notte.",
    ]),
    QA(
    question: "Devi fare un test, sai che durerà due ore, sai che sarà mentalmente molto faticoso, e vuoi essere al massimo della forma per farlo bene. Considerando i tuoi ritmi, quale orario sceglieresti?", 
    answers: [
      "Dalle 8 e le 10 di sera.",
      "Dalle 11 del mattino all' una.",
      "Dalle 3 alle 5 del pomeriggio.",
      "Dalle 7 alle 9 di sera.",
    ]),
    QA(question: "Se dovessi andare a letto alle 11 di sera, quanto saresti stanco?", answers: answersHowMuch),
    QA(
      question: "Sei andato a letto alcune ore più tardi del solito, ma il giorno dopo non ti devi alzare ad un'ora particolare. Che cosa farai?",
      answers: [
        "Mi sveglierò alla solita ora e non mi riaddormenterò.",
        "Mi sveglierò alla solita ora e poi starò lì a sonnecchiare.",
        "Mi sveglierò alla solita ora e poi mi riaddormenterò.",
        "Mi sveglierò più tardi del solito.",
      ] 
    ),
    // QA(
    //   question: "Sei andato a letto alcune ore più tardi del solito, ma il giorno dopo non ti devi alzare ad un'ora particolare. Che cosa farai?",
    //   answers: [
    //     "Mi sveglierò alla solita ora e non mi riaddormenterò.",
    //     "Mi sveglierò alla solita ora e poi starò lì a sonnecchiare.",
    //     "Mi sveglierò alla solita ora e poi mi riaddormenterò.",
    //     "Mi sveglierò più tardi del solito.",
    //   ] 
    // ),
];





class ChronoType extends StatefulWidget {
  const ChronoType({super.key});
  @override
  State<ChronoType> createState() => _ChronoTypeState();
}

class _ChronoTypeState extends State<ChronoType> {
  int _current = 1;
  final CarouselController _controller = CarouselController();
  
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Cronotipo"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // SizedBox(height: screenHeight * .1),
              CarouselSlider(
                items: List<MultipleChoiceQuestion>.generate(questions.length, (index) {
                  return MultipleChoiceQuestion(question: questions[index].question, answers: questions[index].answers,);
                }),
                
                
                // [
                //   MultipleChoiceQuestion(question: "A che ora preferiresti alzarti, più o meno, se fossi", answers: ["boh1", "boh2"])
                // ],
                options: CarouselOptions(
                  enlargeCenterPage: false,
                  height: screenHeight / 1.3,
                  enableInfiniteScroll: false,
                  autoPlay: false,
                  onPageChanged: (index, reason) {
                    _current = index + 1;
                    setState((){});
                  },
                  ),
                carouselController: _controller,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    child: ElevatedButton(
                      onPressed: _current > 1 ? () {
                        _controller.previousPage();
                      } : null,
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  Flexible(child: Text("${_current}/19")),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        _controller.nextPage();
                        },
                      child: _current < 19 ? const Icon(Icons.arrow_forward)  : const Icon(Icons.check),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

}