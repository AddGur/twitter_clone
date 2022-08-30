// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:twitter_clone/widgets/bottom_sheet_widget.dart';
import '../resources/firestore_methods.dart';
import '../screens/logged_screens/profile_screen.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({
    super.key,
    required this.snap,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  int length = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirestoreMethods().getPublishedDate(widget.snap, false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
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
                                TwitterBottomSheet(snap: widget.snap),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          widget.snap['text'],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const Divider(),
            ]),
          );
        });
  }
}
