import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  final String text;
  final Function? onPressed;
  const FormButton({
    this.text = '', 
    this.onPressed, 
    Key? key
  })
  : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return ElevatedButton(
      onPressed: onPressed as void Function()?,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}


class IconTextButton extends StatelessWidget {
  final String text;
  final Icon icon;
  final Function? onPressed;
  const IconTextButton({
    this.icon = const Icon(Icons.add),
    this.text = '', 
    this.onPressed, 
    Key? key
  })
  : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return ElevatedButton(
      onPressed: onPressed as void Function()?,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10,),
            icon,
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      )

    );
  }
}



class InputField extends StatefulWidget {
  final String? labelText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final bool obscureText;
  final bool clearable;
  final Function? onCleared;
  final String? text;
  final bool enabled;
  final bool toggleObscure;
  final TextEditingController? controller;

  InputField(
      {this.labelText,
      this.onChanged,
      this.onSubmitted,
      this.errorText,
      this.keyboardType,
      this.textInputAction,
      this.autoFocus = false,
      this.obscureText = false,
      this.clearable = false,
      this.onCleared,
      this.toggleObscure = false,
      this.text,
      this.controller,
      this.enabled = true,
      super.key});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late TextEditingController controller;
  bool showText = true;
  IconButton? iconButton = null;

  @override
  void initState() {
    super.initState();
    showText = widget.obscureText;
    if(widget.onCleared != null){
      iconButton = IconButton(
          onPressed: () {
            controller.clear();
            widget.onCleared!();
          },
          icon: const Icon(Icons.clear),
          tooltip: "Cancella",
        );
    }

    if(widget.controller == null){
      controller = TextEditingController(text: widget.text);
    } 
    else {
      controller = widget.controller!;
      controller.text = widget.text ?? "";
    }
  }


  @override
  Widget build(BuildContext context) {
    if(widget.toggleObscure){
      iconButton = IconButton(
          onPressed: () {
            setState(() {
              showText = !showText;
            });
          },
          icon: Icon(showText ? Icons.visibility_off : Icons.visibility),
          tooltip: showText ? "Visualizza" : "Nascondi",
        );
    }
    return TextField(
      controller: controller,
      readOnly: !widget.enabled,
      autofocus: widget.autoFocus,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: showText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        errorText: widget.errorText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: iconButton,
      ),
    );
  }
}


class MultilineInputField extends StatefulWidget {
  final String? labelText;
  final int maxLines;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  late final TextEditingController controller;

  MultilineInputField(
      {this.labelText,
      this.maxLines = 5,
      this.onChanged,
      this.onSubmitted,
      this.errorText,
      this.keyboardType,
      this.textInputAction,
      this.autoFocus = false,
      controller,
      super.key}){
        if(controller == null){
          this.controller = TextEditingController();
        }else{
          this.controller = controller;
        }
      }

  @override
  State<MultilineInputField> createState() => _MultilineInputFieldState();
}

class _MultilineInputFieldState extends State<MultilineInputField> {

  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: widget.autoFocus,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      onSubmitted: widget.onSubmitted,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        labelText: widget.labelText,
        errorText: widget.errorText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class SimpleCircularIconButton extends StatelessWidget {
  const SimpleCircularIconButton(
      {this.fillColor = Colors.transparent,
      required this.iconData,
      this.text = "",
      this.iconColor = Colors.blue,
      this.outlineColor = Colors.transparent,
      this.showAlert = false,
      this.onPressed,
      this.radius = 70.0,
      super.key});

  final IconData iconData;
  final String text;
  final Color fillColor;
  final Color outlineColor;
  final bool showAlert;
  final Color iconColor;
  final Function? onPressed;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Ink(
              width: radius,
              height: radius,
              decoration: ShapeDecoration(
                color: fillColor,
                shape: CircleBorder(side: BorderSide(color: outlineColor)),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                splashRadius: radius,
                iconSize: radius,
                icon: Icon(iconData, color: iconColor),
                splashColor: iconColor.withOpacity(.4),
                onPressed: onPressed as void Function()?,
              ),
            ),
            if (showAlert) ...[
              Positioned(
                top: radius / 100,
                right: radius / 100,
                child: Container(
                  width: radius / 3,
                  height: radius / 3,
                  decoration: const ShapeDecoration(
                    color: Colors.red,
                    shape: CircleBorder(),
                  ),
                  child: Center(
                    child: Text(
                      "!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: radius / 4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        Text(
          this.text,
          textAlign: TextAlign.justify,
        )
      ],
    );
  }
}
