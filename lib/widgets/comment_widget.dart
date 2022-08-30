// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/resources/firestore_methods.dart';
import 'package:twitter_clone/utilis/user.dart';

import '../providers/user_provider.dart';

class CommentWidget extends StatefulWidget {
  final String postId;
  const CommentWidget({super.key, required this.postId});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool isFocused = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    void postComment(String profilePic, String uid, String username,
        String text, String postId, String alias) async {
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
                    children: const [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.blue,
                      ),
                      Text(
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

    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border.symmetric(
              horizontal: BorderSide(width: 1.0, color: Colors.grey))),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
        child: Column(
          children: [
            Visibility(
                visible: isFocused,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.postId)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                  text: 'Replying to ',
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                        text: '@${snapshot.data!['alias']}',
                                        style:
                                            const TextStyle(color: Colors.blue))
                                  ]),
                            ));
                      }),
                )),
            TextField(
                controller: _commentController,
                onTap: () {
                  setState(() {
                    isFocused = true;
                  });
                },
                maxLines: null,
                decoration: InputDecoration(
                    hintText: 'Tweet your reply',
                    suffixIcon: isFocused
                        ? IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.fullscreen))
                        : IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.photo_camera)))),
            Visibility(
                visible: isFocused,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.image_outlined,
                          color: Colors.blue,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.gif_box_outlined,
                            color: Colors.blue)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.graphic_eq_outlined,
                          color: Colors.blue,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.place_outlined,
                          color: Colors.blue,
                        )),
                    const Expanded(child: SizedBox()),
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Stack(
                        children: const [
                          CircularProgressIndicator(
                            color: Colors.blue,
                            backgroundColor: Colors.grey,
                            strokeWidth: 3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () async {
                        postComment(user.photoUrl!, user.uid, user.username,
                            _commentController.text, widget.postId, user.alias);

                        _commentController.clear();
                      },
                      child: const Text('Reply'),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
