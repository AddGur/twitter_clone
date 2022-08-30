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
          side: const BorderSide(
            width: 1.0,
            color: Colors.grey,
          ),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      child: Text(
        buttonsText,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
