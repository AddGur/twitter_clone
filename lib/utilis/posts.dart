import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String alias;
  final String postId;
  final datePublished;
  final List<String>? postUrl;
  final String profImage;
  final likes;
  final shares;
  final List<String> comments;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.alias,
    required this.postId,
    required this.datePublished,
    this.postUrl,
    required this.profImage,
    required this.likes,
    required this.shares,
    required this.comments,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot["description"],
      uid: snapshot["uid"],
      username: snapshot["username"],
      alias: snapshot["alias"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      postUrl: snapshot["postUrl"],
      profImage: snapshot["profImage"],
      likes: snapshot["likes"],
      shares: snapshot["shares"],
      comments: snapshot["comments"],
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "username": username,
        "postId": postId,
        "alias": alias,
        "datePublished": datePublished,
        "profImage": profImage,
        "likes": likes,
        "postUrl": postUrl,
        "shares": shares,
        "comments": comments,
      };

  //   Post findById(String id) {
  // return FirebaseFirestore.instance.collection('posts').where().

}
