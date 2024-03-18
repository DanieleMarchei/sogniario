import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/formbutton.dart';
import 'package:frontend/home.dart';
import 'package:frontend/multiline_input_field.dart';
import 'package:frontend/questions.dart';

String question1 = "Come giudichi il contenuto emotivo del sogno?";
List<String> answers1 = ["Non emotivo.", "Parzialmente emotivo.", "Nella media.", "Emotivo.", "Molto emotivo."];

String question2 = "Eri coscente che stavi sognando?";
List<String> answers2 = ["Si.", "No."];

String question3 = "Avevi il controllo del sogno?";
List<String> answers3 = ["Nessun controllo.", "Riuscivo a controllare solo alcune cose.", "Controllo totale."];

String question4 = "Quanto tempo pensi sia passato nel tuo sogno?";
List<String> answers4 = ["Pochi secondi.", "Qualche minuto.", "Qualche ora.", "Qualche giorno."];

String question5 = "Quanto hai dormito?";
List<String> answers5 = ["Meno di 6 ore.", "6 - 7 ore.", "7 - 8 ore.", "8 - 9 ore.", "Più di 9 ore."];

String question6 = "Come giudichi la qualità del sonno?";
List<String> answers6 = ["Molto scarsa.", "Scarsa.", "Buona.", "Molto buona."];



class AddDream extends StatefulWidget {
  const AddDream({super.key});
  @override
  State<AddDream> createState() => _AddDreamState();
}

class _AddDreamState extends State<AddDream> {
  int _current = 1;
  final CarouselController _controller = CarouselController();
  
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Racconta un sogno"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // SizedBox(height: screenHeight * .1),
              CarouselSlider(
                items: [
                  const AddDreamText(),
                  MultipleChoiceQuestion(
                    question: question1,
                    answers: answers1,
                  ),
                  MultipleChoiceQuestion(
                    question: question2,
                    answers: answers2,
                  ),
                  MultipleChoiceQuestion(
                    question: question3,
                    answers: answers3,
                  ),
                  MultipleChoiceQuestion(
                    question: question4,
                    answers: answers4,
                  ),
                  MultipleChoiceQuestion(
                    question: question5,
                    answers: answers5,
                  ),
                  MultipleChoiceQuestion(
                    question: question6,
                    answers: answers6,
                  ),
                ],
                options: CarouselOptions(
                  enlargeCenterPage: false,
                  height: screenHeight / 1.5,
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
                  Flexible(child: Text("${_current}/7")),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        _controller.nextPage();
                        },
                      child: _current < 7 ? const Icon(Icons.arrow_forward)  : const Icon(Icons.check),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

}


class AddDreamText extends StatefulWidget {
  const AddDreamText({super.key});
  @override
  State<AddDreamText> createState() => _AddDreamTextState();
}

class _AddDreamTextState extends State<AddDreamText> {
  late String text;
  String? textError;
  
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

  void submit() {
    if (validate()) {
      // Navigator.pushNamed(context, "/home");
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ListView(
              children: [
                SizedBox(height: screenHeight * .01),
                MultilineInputField(
                  labelText: "Racconta il tuo sogno",
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  errorText: textError,
                  onChanged: (value) {
                    setState(() {
                      text = value;
                      resetErrorText();
                    });
                  },
                  autoFocus: false,
                ),
                SizedBox(height: screenHeight * .025),
                SimpleCircularIconButton(
                  radius: 50,
                  iconData: Icons.mic,
                  fillColor: Colors.red,
                  iconColor: Colors.black,

                )
              ],
            ),    
          )
        );
  }
}
