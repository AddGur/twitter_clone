import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/utilis/user.dart';
import 'dart:developer' as devtools show log;

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Users> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return Users.fromSnap(documentSnapshot);
  }

  Future createUser(
      {required String email,
      required String password,
      required String username,
      required String alias,
      String? phoneNumber,
      required String birthday,
      required String file,
      String? discrption}) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      Users user = Users(
        email: email,
        username: username,
        birthday: birthday,
        uid: credential.user!.uid,
        alias: alias,
        photoUrl: file,
        followers: [],
        following: [],
        discrption: discrption,
        phoneNumber: phoneNumber,
      );

      await _firestore
          .collection("users")
          .doc(credential.user!.uid)
          .set(user.toJson());
    } catch (err) {
      return err.toString();
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    if (password.isNotEmpty) {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    }
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
  }
}
