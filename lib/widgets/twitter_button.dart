import 'package:flutter/material.dart';

class TwitterButton extends StatelessWidget {
  final Function()? onPressed;
  final String buttonsText;
  final Color backgroundColor;
  final Color textColor;
  const TwitterButton(
      {super.key,
      required this.onPressed,
      required this.buttonsText,
      required this.backgroundColor,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        buttonsText,
        style: TextStyle(color: textColor),
      ),
      style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    );
  }
}
