import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils.dart';

class CircleDecoration extends StatelessWidget {
  double height;
  double width;
  Offset offset;
  Color shadow, gradientOne, gradientTwo;

  CircleDecoration({
    this.height = 200,
    this.width = 300,
    this.offset = const Offset(5, 5),
    required this.shadow,
    required this.gradientOne,
    required this.gradientTwo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [gradientOne, gradientTwo]),
          boxShadow: [
            BoxShadow(color: shadow, offset: offset, blurRadius: 10)
          ]),
    );
  }
}

class ScaffoldWithCircles extends Scaffold {
  ScaffoldWithCircles({
    super.key,
    super.appBar,
    required body,
    required context,
    super.floatingActionButton,
    super.floatingActionButtonLocation,
    super.floatingActionButtonAnimator,
    super.persistentFooterButtons,
    super.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    super.drawer,
    super.onDrawerChanged,
    super.endDrawer,
    super.onEndDrawerChanged,
    super.bottomNavigationBar,
    super.bottomSheet,
    super.backgroundColor,
    super.resizeToAvoidBottomInset,
    super.primary = true,
    super.drawerDragStartBehavior = DragStartBehavior.start,
    super.extendBody = false,
    super.extendBodyBehindAppBar = false,
    super.drawerScrimColor,
    super.drawerEdgeDragWidth,
    super.drawerEnableOpenDragGesture = true,
    super.endDrawerEnableOpenDragGesture = true,
    super.restorationId,
  }) : super(body: getCircles(context, body));
}

Stack getCircles(BuildContext context, body){
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  bool showDesktopLayout = screenWidth > widthConstraint;
  return Stack(
      children: [
        Positioned(
          top: -50,
          left: screenWidth / 4 - 25,
          child: CircleDecoration(
            height: 250,
            width: 250,
            offset: Offset(-1, -1),
            shadow: Colors.blue.shade600,
            gradientOne: Colors.blue.shade200.withOpacity(0.4),
            gradientTwo: Colors.blue.shade100,
          ),
        ),
        Positioned(
          bottom: -10,
          right: -50,
          child: CircleDecoration(
            height: 150,
            width: 200,
            offset: Offset(1, 1),
            shadow: Colors.blue.shade800,
            gradientOne: Colors.blue.shade100,
            gradientTwo: Colors.blue.shade200.withOpacity(0.6),
          ),
        ),
        Positioned(
          bottom: screenHeight / 4,
          left: -50,
          child: CircleDecoration(
            height: 200,
            width: 200,
            offset: Offset(2, 2),
            shadow: Colors.blue.shade700,
            gradientOne: Colors.blue.shade100.withOpacity(0.4),
            gradientTwo: Colors.blue.shade200,
          ),
        ),
        if(showDesktopLayout)...{
          Positioned(
            bottom: screenHeight / 4 - 150,
            left: screenWidth / 2,
            child: CircleDecoration(
              height: 200,
              width: 200,
              offset: Offset(1, 2),
              shadow: Colors.blue.shade700,
              gradientOne: Colors.blue.shade200,
              gradientTwo: Colors.blue.shade100.withOpacity(0.4),
            ),
          ),
          Positioned(
            bottom: screenHeight / 2 + 100,
            left: screenWidth / 2 + 250,
            child: CircleDecoration(
              height: 200,
              width: 200,
              offset: Offset(2, 0),
              shadow: Colors.blue.shade700,
              gradientOne: Colors.blue.shade100.withOpacity(0.4),
              gradientTwo: Colors.blue.shade100,
            ),
          ),
        },
        body
      ],
    );
}