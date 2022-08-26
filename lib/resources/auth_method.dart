import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_clone/resources/storage_methods.dart';
import '../utilis/user.dart' as model;
// ignore: unused_import
import 'dart:developer' as devtools show log;
import 'dart:typed_data';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(documentSnapshot);
  }

  Future<String> createUser(
      {required String email,
      required String password,
      required String username,
      required String alias,
      String? phoneNumber,
      required String birthday,
      required String joined,
      required Uint8List file,
      String? discrption}) async {
    String res = "error";

    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String photoUrl =
          await StorageMethods().uploadImageToStorage('profilePics', file);

      model.User user = model.User(
        email: email,
        username: username,
        birthday: birthday,
        joined: joined,
        uid: credential.user!.uid,
        alias: alias,
        photoUrl: photoUrl,
        followers: [],
        following: [],
        discrption: discrption,
        phoneNumber: phoneNumber,
      );

      await _firestore
          .collection("users")
          .doc(credential.user!.uid)
          .set(user.toJson());

      res = 'success';
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'error';
    try {
      if (password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Wrong password!';
      }
      // } on FirebaseAuthException catch (e) {
      //   showSnackBar('Wrong password!', context, 100);
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
  }
}
