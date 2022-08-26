import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:twitter_clone/widgets/choosen_post_widget.dart';
import 'package:twitter_clone/widgets/comment_widget.dart';

class TweetScreen extends StatefulWidget {
  static const routeName = '/tweetScreen';
  // final snap;
  const TweetScreen({
    super.key,
    //   this.snap,
  });

  @override
  State<TweetScreen> createState() => _TweetScreenState();
}

class _TweetScreenState extends State<TweetScreen> {
  bool isFocused = false;
  int commentLen = 0;
  late String postId;
  TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    postId = ModalRoute.of(context)!.settings.arguments as String;
    getComments();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(
          'Tweet',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child:
              // Column(
              //   children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return SingleChildScrollView(
                      child: ChoosenPostWidget(
                        snap: snapshot.data!,
                      ),
                    );
                  }),
        ),
        CommentWidget(postId: postId),
        Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom)),
      ]),
    );
  }
}
