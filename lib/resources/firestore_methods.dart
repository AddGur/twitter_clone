import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:twitter_clone/resources/storage_methods.dart';
import 'package:twitter_clone/utilis/comment.dart';
import 'package:twitter_clone/utilis/posts.dart';
import 'package:twitter_clone/widgets/snackbar.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, List<File> file, String uid,
      String username, String alias, String profImage) async {
    String res = 'error';

    try {
      String postId = const Uuid().v1();

      List<String> photoUrl = await StorageMethods().postImages(file, postId);

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        alias: alias,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
        shares: [],
        comments: [],
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> getImgUrl(List<String> imgUrl, String postId) async {
    CollectionReference collectionReference = _firestore.collection('posts');
    var docs = collectionReference.doc(postId);
    var response = await docs.get();
    var variable = response.data() as Map;
    int imgAmount = await variable['postUrl'].length;
    for (int i = 0; i < imgAmount; i++) {
      imgUrl.add(variable['postUrl'][i]);
    }
  }

  Future<String> postComment(String postId, String text, String uid,
      String username, String profImage) async {
    String res = 'Some error occured';

    try {
      String commentId = const Uuid().v1();

      Comment comment = Comment(
          profImage: profImage,
          uid: uid,
          username: username,
          text: text,
          commentId: commentId,
          datePublished: DateTime.now());

      _firestore
          .collection('posts')
          .doc('/$postId/comments/$commentId')
          .set(comment.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> getPublishedDate(dynamic snapshot, bool isTweet) async {
    Timestamp timestamp = await snapshot['datePublished'];
    late String formatted;
    final DateFormat formatter;
    final DateTime dateTime = DateTime.parse(timestamp.toDate().toString());
    if (isTweet) {
      formatter = DateFormat('HH:MM · dd MMM yyyy');
      formatted = formatter.format(dateTime);
    } else {
      if (DateTime.now().difference(dateTime).inHours < 24) {
        formatted =
            ' · ${DateTime.now().difference(dateTime).inHours.toString()}h';
      } else if (DateTime.now().difference(dateTime).inDays < 7) {
        formatted =
            ' · ${DateTime.now().difference(dateTime).inDays.toString()}d';
      } else if (DateTime.now().difference(dateTime).inDays < 365) {
        formatter = DateFormat(' · dd MMM');
        formatted = formatter.format(dateTime);
      } else {
        formatter = DateFormat(' · dd MMM yyyy');
        formatted = formatter.format(dateTime);
      }
    }
    return formatted;
  }
}
