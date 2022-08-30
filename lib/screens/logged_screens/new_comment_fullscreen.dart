// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, unused_import

import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:provider/provider.dart';
import 'package:twitter_clone/resources/firestore_methods.dart';
import '../../providers/user_provider.dart';
import '../../utilis/user.dart' as model;

class NewCommentFullScreen extends StatefulWidget {
  final postId;
  static const routeName = '/newComment';
  const NewCommentFullScreen({super.key, this.postId});

  @override
  State<NewCommentFullScreen> createState() => _NewCommentFullScreenState();
}

class _NewCommentFullScreenState extends State<NewCommentFullScreen> {
  late TextEditingController _commentController;

  @override
  void initState() {
    _commentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void postComment(String profilePic, String uid, String username, String text,
      String postId, String alias) async {
    try {
      String res = await FirestoreMethods()
          .postComment(postId, text, uid, username, profilePic, alias);

      if (res == 'success') {
        showDialog(
            barrierColor: Colors.transparent,
            context: context,
            builder: (context) {
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pop(context);
              });
              FocusManager.instance.primaryFocus?.unfocus();

              return AlertDialog(
                elevation: 0,
                title: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.blue,
                    ),
                    const Text(
                      '    Reply sent',
                      style: TextStyle(fontSize: 19),
                    ),
                  ],
                ),
              );
            });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: Navigator.of(context).pop,
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                postComment(user.photoUrl!, user.uid, user.username,
                    _commentController.text, widget.postId, user.alias);
                _commentController.clear();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: const Text('Reply'),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(user.photoUrl!),
                    backgroundColor: Colors.red,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: _commentController,
                        onChanged: (value) {},
                        autofocus: true,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Tweet your reply',
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  void commetnTweet(
      String uid, String username, String profImage, String alias) async {
    Navigator.pop(context);
  }
}
