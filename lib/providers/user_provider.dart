import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:twitter_clone/resources/auth_method.dart';

import '../utilis/user.dart';

class UserProvider with ChangeNotifier {
  Users? _users;
  final AuthMethod _authMethod = AuthMethod();

  Users get getUser => _users!;

  Future<void> refreshUser() async {
    Users users = await _authMethod.getUserDetails();
    _users = users;
    notifyListeners();
  }
}
