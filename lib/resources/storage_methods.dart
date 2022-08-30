// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<ListResult> listFiles() async {
    ListResult results = await _storage.ref('test').listAll();
    for (var ref in results.items) {}
    return results;
  }

  Future<List<String>> postImages(List<File> images, String postId) async {
    var imageUrls =
        await Future.wait(images.map((image) => imageToPost(image, postId)));

    return imageUrls;
  }

  Future<String> imageToPost(File image, String postId) async {
    var downloadUrl;

    Reference reference = FirebaseStorage.instance
        .ref()
        .child('posts')
        .child(_auth.currentUser!.uid)
        .child(postId)
        .child(image
            .toString()
            .replaceAll('/data/user/0/com.example.twitter_clone/cache/', ''));

    UploadTask uploadTask = reference.putFile(image);
    await uploadTask.whenComplete(() async {
      downloadUrl = await reference.getDownloadURL();
    });

    return downloadUrl;
  }
}
