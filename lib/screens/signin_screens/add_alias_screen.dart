import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:twitter_clone/resources/auth_method.dart';
import 'package:twitter_clone/responsive/mobile_screen_layout.dart';
import 'package:twitter_clone/screens/logged_screens/home_screen.dart';
import 'package:twitter_clone/utilis/user.dart';
import 'package:twitter_clone/widgets/snackbar.dart';

import '../../providers/user_provider.dart';
import '../../widgets/twitter_button.dart';

import 'dart:developer' as devtools show log;

class AddAliasScreen extends StatefulWidget {
  static const routeName = '/add_alias';
  const AddAliasScreen({super.key});

  @override
  State<AddAliasScreen> createState() => _AddAliasScreenState();
}

class _AddAliasScreenState extends State<AddAliasScreen> {
  late TextEditingController _alias;
  var randNumb = Random().nextInt(900000) + 100000;
  var randName;
  Uint8List? _file;
  bool _aliasExists = false;

  @override
  void initState() {
    final userData = Provider.of<NewUser>(context, listen: false);

    super.initState();
    _alias = TextEditingController();
    randName = ('${userData.name}${randNumb}');
    _alias.text = randName;
    getFireData();
    if (_aliasExists) {
      randNumb++;
      randName = ('${userData.name}${randNumb}');
      _alias.text = randName;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _alias.dispose();
  }

  void signUpUser() async {
    final userData = Provider.of<NewUser>(context, listen: false);

    String res = await AuthMethod().createUser(
        email: userData.email,
        password: userData.password,
        username: userData.name,
        discrption: userData.description,
        alias: _alias.text,
        phoneNumber: '',
        birthday: userData.birthday,
        joined: DateFormat.yMMMM().format(DateTime.now()),
        file: _file!);
    if (res != 'success') {
      showSnackBar('err', context, 30);
    } else {
      await addData();

      await Navigator.pushNamed(context, MobileScreenLayout.routeName);
    }
  }

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  Future getFireData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("alias", isEqualTo: _alias.text)
        .get()
        .then((QuerySnapshot querySnapshot) {
      _aliasExists = false;

      querySnapshot.docs.forEach((doc) {
        _aliasExists = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _file = ModalRoute.of(context)!.settings.arguments as Uint8List;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Image.asset('assets/images/twitter_logo.png',
              height: 20, fit: BoxFit.cover),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What should we call you?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Your @username is unique. You can always change it later',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _alias,
                autocorrect: false,
                style: const TextStyle(fontWeight: FontWeight.w300),
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefix: Text('@'),
                  border: OutlineInputBorder(),
                ),
              ),
              const Expanded(child: SizedBox()),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TwitterButton(
                      onPressed: () {
                        _alias.text = randName;
                        signUpUser;
                      },
                      buttonsText: 'Skip',
                      textColor: Colors.black,
                      backgroundColor: Colors.white),
                  TwitterButton(
                      onPressed: signUpUser,
                      buttonsText: 'Next',
                      textColor: Colors.black,
                      backgroundColor: Colors.white),
                ],
              )
            ],
          ),
        ));
  }
}
