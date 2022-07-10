import 'package:flutter/cupertino.dart';

class UserData with ChangeNotifier {
  final String uid;
  final String userName;
  final String userAlias;
  final String userImageUrl;
  final int followers;
  final int following;

  UserData(
      {required this.uid,
      required this.userName,
      required this.userAlias,
      required this.userImageUrl,
      required this.followers,
      required this.following});
}

class RandomUsers with ChangeNotifier {
  final List<UserData> _dummyUsers = [
    UserData(
        uid: '1',
        userName: 'John Doe',
        userAlias: 'Johny',
        userImageUrl: 'https://pic.onlinewebfonts.com/svg/img_74993.png',
        followers: 1,
        following: 2),
    UserData(
        uid: '2',
        userName: 'Jane Doe',
        userAlias: 'Jane',
        userImageUrl:
            'https://icons-for-free.com/iconfiles/png/512/user+icon-1320190636314922883.png',
        followers: 2,
        following: 3)
  ];

  List<UserData> get dummyUsers {
    return [..._dummyUsers];
  }
}
