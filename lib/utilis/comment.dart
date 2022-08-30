// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String profImage;
  final String uid;
  final String username;
  final String alias;
  final String text;
  final String commentId;
  final datePublished;

  const Comment({
    required this.profImage,
    required this.uid,
    required this.username,
    required this.alias,
    required this.text,
    required this.commentId,
    required this.datePublished,
  });

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
      profImage: snapshot["profImage"],
      uid: snapshot["uid"],
      username: snapshot["username"],
      alias: snapshot["alias"],
      text: snapshot["text"],
      commentId: snapshot["commentId"],
      datePublished: snapshot["datePublished"],
    );
  }

  Map<String, dynamic> toJson() => {
        "profImage": profImage,
        "uid": uid,
        "username": username,
        "alias": alias,
        "text": text,
        "commentId": commentId,
        "datePublished": datePublished,
      };
}
