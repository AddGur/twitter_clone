import 'package:flutter/material.dart';

showSnackBar(String content, BuildContext context, double margin) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 75, left: margin, right: margin),
      duration: const Duration(seconds: 3),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child:
                      Image.asset('assets/images/twitter_logo.png', height: 10),
                ),
              )),
          const SizedBox(
            width: 10,
          ),
          Text(content),
        ],
      ),
    ),
  );
}
