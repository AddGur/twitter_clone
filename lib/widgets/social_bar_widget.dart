import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_clone/screens/logged_screens/new_comment_fullscreen.dart';

class SocialBarWidget extends StatefulWidget {
  final String postId;
  final Color color;
  final bool isPostScreen;
  final bool isTweetScreen;
  const SocialBarWidget(
      {super.key,
      required this.postId,
      required this.color,
      required this.isPostScreen,
      required this.isTweetScreen});

  @override
  State<SocialBarWidget> createState() => _SocialBarWidgetState();
}

class _SocialBarWidgetState extends State<SocialBarWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Row(
              mainAxisAlignment: !widget.isPostScreen
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.spaceBetween,
              children: [
                _buttonIconWidget(
                    () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            NewCommentFullScreen(postId: widget.postId))),
                    FontAwesomeIcons.comment,
                    widget.isTweetScreen
                        ? 0
                        : (snapshot.data as dynamic).docs.length,
                    widget.color),
                _buttonIconWidget(() {}, FontAwesomeIcons.arrowRightArrowLeft,
                    0, widget.color),
                _buttonIconWidget(
                    () {}, FontAwesomeIcons.heart, 0, widget.color),
                _buttonIconWidget(
                    () {}, FontAwesomeIcons.share, 0, widget.color),
                if (widget.isPostScreen) const Expanded(child: SizedBox()),
              ]);
        });
  }
}

Widget _buttonIconWidget(
    Function onPressed, IconData icon, int length, Color textColor) {
  return ElevatedButton.icon(
    onPressed: () => onPressed(),
    icon: (Icon(
      icon,
      size: 18,
    )),
    label: Text(
      length > 0 ? length.toString() : '',
      style: const TextStyle(fontSize: 18),
    ),
    style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent),
  );
}
