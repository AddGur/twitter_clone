import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/providers/user_provider.dart';
import 'package:twitter_clone/resources/firestore_methods.dart';
import 'package:twitter_clone/screens/logged_screens/new_comment_fullscreen.dart';
import 'package:twitter_clone/utilis/user.dart';

class SocialBarWidget extends StatefulWidget {
  final snap;
  final Color color;
  final bool isPostScreen;
  final bool isTweetScreen;
  const SocialBarWidget(
      {super.key,
      required this.snap,
      required this.color,
      required this.isPostScreen,
      required this.isTweetScreen});

  @override
  State<SocialBarWidget> createState() => _SocialBarWidgetState();
}

class _SocialBarWidgetState extends State<SocialBarWidget> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Row(
        mainAxisAlignment: !widget.isPostScreen
            ? MainAxisAlignment.spaceAround
            : MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.snap['postId'])
                  .collection('comments')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return _buttonIconWidget(
                    () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NewCommentFullScreen(
                            postId: widget.snap['postId']))),
                    FontAwesomeIcons.comment,
                    widget.isTweetScreen
                        ? 0
                        : (snapshot.data! as dynamic).docs.length,
                    widget.color);
              }),
          _buttonIconWidget(
              () {}, FontAwesomeIcons.arrowRightArrowLeft, 0, widget.color),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.snap['postId'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return _buttonIconWidget(() async {
                  await FirestoreMethods().likePost(
                      widget.snap['postId'], user.uid, snapshot.data!['likes']);
                },
                    FontAwesomeIcons.heart,
                    widget.isTweetScreen ? 0 : widget.snap['likes'].length,
                    widget.color);
              }),
          _buttonIconWidget(() {}, FontAwesomeIcons.share, 0, widget.color),
          if (widget.isPostScreen) const Expanded(child: SizedBox()),
        ]);
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
