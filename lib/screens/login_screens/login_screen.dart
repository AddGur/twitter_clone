// ignore_for_file: use_build_context_synchronously, unused_local_variable, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/screens/login_screens/enter_password_screen.dart';
import 'package:twitter_clone/widgets/snackbar.dart';

import '../../responsive/mobile_screen_layout.dart';
import '../main_screen.dart';

import '../../widgets/twitter_button.dart';

import 'dart:developer' as devtools show log;

class LoginScreen extends StatefulWidget {
  static const routeName = '/loginscreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _loginController;
  bool isContains = false;

  @override
  void initState() {
    _loginController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _loginController.dispose();

    super.dispose();
  }

  void navigator() {
    Navigator.pushNamed(context, MobileScreenLayout.routeName);
  }

  Future getFireData(String dataType) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where(dataType, isEqualTo: _loginController.text)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          isContains = true;
        });
      }
    });
  }

  Future checkEmail() async {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_loginController.text)) {
      await getFireData('email');
    } else if (RegExp(
            r'^[\+]?[(]?[[0-9]?[0-9]?[0-9]?[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
        .hasMatch(_loginController.text)) {
      await getFireData('phoneNumer');
    } else {
      await getFireData('alias');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset('assets/images/twitter_logo.png',
            height: 20, fit: BoxFit.cover),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(MainLoginScreen.routeName);
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Column(children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'To get started, first enter your phone, email address or @username',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _loginController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone, email address or username'),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TwitterButton(
                    onPressed: () {},
                    buttonsText: 'Forgot password?',
                    textColor: Colors.black,
                    backgroundColor: Colors.white),
                TwitterButton(
                    onPressed: () async {
                      _loginController.text.isNotEmpty
                          ? await checkEmail()
                          : null;
                      _loginController.text.isNotEmpty
                          ? isContains
                              ? Navigator.pushNamed(
                                  context, EnterPasswordScreen.routeName,
                                  arguments: _loginController.text)
                              : showSnackBar(
                                  'Sorry, we could not find your account.',
                                  context,
                                  30)
                          : null;
                    },
                    buttonsText: 'Next',
                    textColor: Colors.white,
                    backgroundColor: Colors.black)
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
