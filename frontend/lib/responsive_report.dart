import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/decorations.dart';
import 'package:frontend/forms_and_buttons.dart';
import 'package:frontend/questions.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/utils.dart';
import 'package:go_router/go_router.dart';

class ResponsiveReport extends StatefulWidget {
  const ResponsiveReport({
    super.key,
    required this.questionWidgets,
    required this.title,
    required this.onSubmitted,
    required this.unansweredQuestions,
    this.ignoreUnansweredQuestions = false,
    this.homeButtonTooltip
  });

  final List<QuestionWithDirection> questionWidgets;
  final String title;
  final Function onSubmitted;
  final List<int> Function()  unansweredQuestions;
  final bool ignoreUnansweredQuestions;
  final String? homeButtonTooltip;

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

    return ScaffoldWithCircles(
      context: context,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title),
        leading: widget.homeButtonTooltip == null ? null : IconButton(
          icon: Icon(Icons.home),
          onPressed: () async {
            bool pop = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: Text("Tornare indietro?"),
                  insetPadding: EdgeInsets.all(16),
                  content: Text(widget.homeButtonTooltip!, textAlign: TextAlign.justify,),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Si'),
                      onPressed: () {
                        context.pop(true);
                      },
                    ),
                    TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        context.pop(false);
                      },
                    ),
                  ],);
              },
            );
            if(pop) context.goNamed(Routes.homeUser.name);
          },
          tooltip: "Torna alla pagina iniziale",
        ),
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

    FormButton sendButton = FormButton(
      text: "Conferma",
      onPressed: () {
        if(widget.ignoreUnansweredQuestions){
          widget.onSubmitted();
          return;
        }

        List<int> uq = widget.unansweredQuestions();
        if(uq.isEmpty){
          widget.onSubmitted();
          return;
        }

      showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Attenzione!"),
          content: Text("Alcune domande non sono state compilate."),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                context.pop();
              },
            ),
          ],
      );
      },
    );

      }
    );
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
              if(FocusManager.instance.primaryFocus != null) FocusManager.instance.primaryFocus!.unfocus();
            },
          ),
          carouselController: _controller,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
          Flexible(
            child: ElevatedButton(
              onPressed: _current > 1
                  ? () async {
                      await _controller.previousPage();
                    }
                  : null,
              child: const Icon(Icons.arrow_back),
            ),
          ),
          Flexible(child: Text("${_current}/${widget.questionWidgets.length}")),
          Flexible(
            child: ElevatedButton(
              onPressed: _current >= widget.questionWidgets.length 
              ? () {
                if(widget.ignoreUnansweredQuestions){
                  widget.onSubmitted();
                  return;
                }

                List<int> uq = widget.unansweredQuestions();
                if(uq.isNotEmpty){
                  _controller.animateToPage(uq.first);
                  Fluttertoast.showToast(
                    msg: "Alcune domande non sono state compilate.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 12.0
                  );
                }else{
                  widget.onSubmitted();
                }

              } 
              : () async {
                await _controller.nextPage();
              },
              child: _current < widget.questionWidgets.length
                  ? const Icon(Icons.arrow_forward)
                  : const Icon(Icons.check),
              style: _current < widget.questionWidgets.length
                  ? null
                  : ElevatedButton.styleFrom(backgroundColor: Colors.green.shade400),
            ),
          )
        ])
      ])),
    );
  }
}