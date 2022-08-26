// ignore_for_file: unused_import, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/resources/firestore_methods.dart';
import 'package:twitter_clone/widgets/comment_card.dart';
import 'package:twitter_clone/widgets/img_post_grid_widget.dart';
import 'package:twitter_clone/widgets/social_bar_widget.dart';
import 'dart:developer' as devtools show log;
import '../screens/logged_screens/profile_screen.dart';

class ChoosenPostWidget extends StatefulWidget {
  final snap;
  const ChoosenPostWidget({super.key, this.snap});

  @override
  State<ChoosenPostWidget> createState() => _ChoosenPostWidgetState();
}

class _ChoosenPostWidgetState extends State<ChoosenPostWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: FirestoreMethods().getPublishedDate(widget.snap, true),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProfileScreen(uid: widget.snap['uid']))),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(widget.snap['profImage']),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              widget.snap['username'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            Text(
                              '@${widget.snap['alias']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.snap['description'],
                        style: const TextStyle(fontSize: 20),
                      )),
                ),
                if (widget.snap['postUrl'] != null)
                  ImgPostGridWidget(
                      length: widget.snap['postUrl'].length,
                      postId: widget.snap['postId'],
                      postUrl: widget.snap['postUrl']),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      snapshot.data!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                const Divider(),
                Row(
                  children: [
                    Text('${widget.snap['likes'].length.toString()} likes'),
                  ],
                ),
                const Divider(),
                SocialBarWidget(
                  postId: widget.snap['postId'],
                  color: Colors.grey[600]!,
                  isPostScreen: false,
                  isTweetScreen: true,
                ),
                const Divider(),
              ]),
            );
          },
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.snap['postId'])
              .collection('comments')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: (snapshot.data as dynamic).docs.length,
              itemBuilder: (context, index) => CommentCard(
                snap: (snapshot.data as dynamic).docs[index].data(),
              ),
            );
          },
        ),
      ],
    );
  }
}
