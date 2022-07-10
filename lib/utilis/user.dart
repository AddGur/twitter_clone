import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Users {
  final String email;
  final String? phoneNumber;
  final String username;
  final String birthday;
  final String uid;
  final String alias;
  final String? photoUrl;
  final String? discrption;
  final List followers;
  final List following;

  Users(
      {required this.email,
      this.phoneNumber,
      required this.username,
      required this.birthday,
      required this.uid,
      required this.alias,
      this.photoUrl,
      this.discrption,
      required this.followers,
      required this.following});

  static Users fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Users(
      email: snapshot["email"],
      username: snapshot["username"],
      birthday: snapshot["birthday"],
      uid: snapshot["uid"],
      alias: snapshot["alias"],
      photoUrl: snapshot["photoUrl"],
      discrption: snapshot["discrption"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "phoneNumer": phoneNumber,
        "username": username,
        "birthday": birthday,
        "alias": alias,
        "uid": uid,
        "photoUrl": photoUrl,
        "discrption": discrption,
        "followers": followers,
        "following": following,
      };
}

class NewUser with ChangeNotifier {
  String name = '';
  String phoneNumber = '';
  String password = '';
  String photoUrl = '';
  String email = '';
  String description = '';
  String birthday = '';

  void setUserEmail(String userName, String userEmail, String userBirthday) {
    name = userName;
    email = userEmail;
    birthday = userBirthday;
    notifyListeners();
  }

  void setUserPhone(
      String userName, String userPhoneNumber, String userBirthday) {
    name = userName;
    phoneNumber = userPhoneNumber;
    birthday = userBirthday;
    notifyListeners();
  }
}
