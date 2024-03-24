import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/home_user.dart';
import 'package:frontend/questions.dart';
import 'package:frontend/utils.dart';

class ResponsiveReport extends StatefulWidget {
  const ResponsiveReport({
    super.key,
    required this.questionWidgets,
    required this.title,
    required this.onSubmitted
  });

  final List<QuestionWithDirection> questionWidgets;
  final String title;
  final Function onSubmitted;

  @override
  State<ResponsiveReport> createState() => _ResponsiveReportState();
}

class _ResponsiveReportState extends State<ResponsiveReport> {
  int _current = 1;
  final CarouselController _controller = CarouselController();

  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool showMobileLayout = screenWidth < widthConstraint;

    late Widget widgetToShow;
    double padding = 0.0;
    if (showMobileLayout) {
      widgetToShow = mobileWidgets(context);
      padding = 16.0;
    } else {
      widgetToShow = desktopWidgets(context);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Center(
                child: ConstrainedBox(
                        constraints: BoxConstraints.tightFor(width: min(screenWidth, widthConstraint)),
                        child: widgetToShow
                    )
                ),
      ),
      );
  }

  Widget desktopWidgets(BuildContext context) {
    SizedBox spacingBox = const SizedBox(height: 15,);
    List<Widget> desktopQuestions = [spacingBox];

    for (var question in widget.questionWidgets) {
      if (question.canChangeDirection) question.direction = Axis.horizontal;
      desktopQuestions.add(question);
      desktopQuestions.add(spacingBox);
    }

    FormButton sendButton = FormButton(text: "Conferma", onPressed: widget.onSubmitted,);
    desktopQuestions.add(sendButton);
    desktopQuestions.add(spacingBox);
    return ListView(
        children: desktopQuestions,
      );
  }

  Widget mobileWidgets(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    for (var question in widget.questionWidgets) {
      question.direction = Axis.vertical;
    }
    
    return Center(
      child: SingleChildScrollView(
            child: Column(
              children: 
        [SizedBox(height: screenHeight * .01),
        CarouselSlider(
          items: widget.questionWidgets,
          options: CarouselOptions(
            viewportFraction: 1,
            enlargeCenterPage: false,
            height: screenHeight / 1.3,
            enableInfiniteScroll: false,
            autoPlay: false,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index + 1;
              });
            },
          ),
          carouselController: _controller,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
          Flexible(
            child: ElevatedButton(
              onPressed: _current > 1
                  ? () {
                      setState(() {
                        _current -= 1;
                        _controller.previousPage();
                      });
                    }
                  : null,
              child: const Icon(Icons.arrow_back),
            ),
          ),
          Flexible(child: Text("${_current}/${widget.questionWidgets.length}")),
          Flexible(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _current += 1;
                  _controller.nextPage();
                  if (_current == widget.questionWidgets.length) {
                    widget.onSubmitted();
                  }
                });
              },
              child: _current < widget.questionWidgets.length
                  ? const Icon(Icons.arrow_forward)
                  : const Icon(Icons.check),
            ),
          )
        ])
      ])),
    );
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
    ));
  }
}
