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
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      child: Text(
        buttonsText,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
