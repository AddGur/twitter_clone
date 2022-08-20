import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/resources/storage_methods.dart';
import 'package:twitter_clone/utilis/posts.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, List<File> file, String uid,
      String username, String alias, String profImage) async {
    String res = 'error';

    try {
      String postId = const Uuid().v1();

      List<String> photoUrl = await StroageMethods().postImages(file, postId);

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
}
