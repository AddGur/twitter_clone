import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String profImage;
  final String uid;
  final String username;
  final String text;
  final String commentId;
  final datePublished;

  const Comment({
    required this.profImage,
    required this.uid,
    required this.username,
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
      text: snapshot["text"],
      commentId: snapshot["commentId"],
      datePublished: snapshot["datePublished"],
    );
  }

  Map<String, dynamic> toJson() => {
        "profImage": profImage,
        "uid": uid,
        "username": username,
        "text": text,
        "commentId": commentId,
        "datePublished": datePublished,
      };

  //   Post findById(String id) {
  // return FirebaseFirestore.instance.collection('posts').where().

}
