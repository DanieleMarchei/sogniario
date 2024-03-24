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
          children: [
            icon,
            const SizedBox(width: 10,),
            Text(
              text,
              style: const TextStyle(fontSize: 16),
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
      super.key});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: widget.autoFocus,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        errorText: widget.errorText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: widget.onCleared != null ? IconButton(
          onPressed: () {
            controller.clear();
            widget.onCleared!();
          },
          icon: const Icon(Icons.clear),
        ) : null,
      ),
    );
  }
}


class MultilineInputField extends StatelessWidget {
  final String? labelText;
  final int maxLines;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  const MultilineInputField(
      {this.labelText,
      this.maxLines = 5,
      this.onChanged,
      this.onSubmitted,
      this.errorText,
      this.keyboardType,
      this.textInputAction,
      this.autoFocus = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autoFocus,
      onChanged: onChanged,
      maxLines: maxLines,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
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
