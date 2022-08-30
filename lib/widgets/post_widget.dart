// ignore_for_file: unused_import, prefer_typing_uninitialized_variables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/resources/firestore_methods.dart';
import 'package:twitter_clone/screens/logged_screens/profile_screen.dart';
import 'package:twitter_clone/widgets/bottom_sheet_widget.dart';
import 'package:twitter_clone/widgets/img_post_grid_widget.dart';
import 'package:twitter_clone/widgets/social_bar_widget.dart';

import 'dart:developer' as devtools show log;

import '../screens/logged_screens/tweet_screen.dart';

class PostWidget extends StatefulWidget {
  final snap;
  const PostWidget({
    super.key,
    required this.snap,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  int length = 0;
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, TweetScreen.routeName,
            arguments: widget.snap['postId']);
      },
      child: FutureBuilder(
          future: FirestoreMethods().getPublishedDate(widget.snap, false),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(uid: widget.snap['uid']))),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(widget.snap['profImage']),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${widget.snap['username']} ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '@${widget.snap['alias']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[700]),
                                  ),
                                  Text(
                                    snapshot.data!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[700]),
                                  ),
                                  TwitterBottomSheet(
                                    snap: widget.snap,
                                  )
                                ],
                              ),
                            ],
                          ),
                          Text(
                            widget.snap['description'],
                          ),
                          if (widget.snap['postUrl'] != null)
                            ImgPostGridWidget(
                              length: widget.snap['postUrl'].length,
                              snap: widget.snap,
                            ),
                          SocialBarWidget(
                            snap: widget.snap,
                            color: Colors.grey[600]!,
                            isPostScreen: true,
                            isTweetScreen: false,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const Divider(),
              ]),
            );
          }),
    );
  }
}

class PassArguments {
  final dynamic snapshot;
  final int index;

  PassArguments(this.snapshot, this.index);
}
