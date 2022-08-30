// ignore_for_file: use_build_context_synchronously, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/resources/auth_method.dart';
import 'package:twitter_clone/responsive/responsive_layout_screen.dart';
import '../../../widgets/twitter_button.dart';

import 'dart:developer' as devtools show log;

import '../../responsive/mobile_screen_layout.dart';
import '../../widgets/snackbar.dart';

class EnterPasswordScreen extends StatefulWidget {
  static const routeName = '/enterpasswordscreen';
  const EnterPasswordScreen({super.key});

  @override
  State<EnterPasswordScreen> createState() => _EnterPasswordScreenState();
}

class _EnterPasswordScreenState extends State<EnterPasswordScreen> {
  late TextEditingController _password;
  String email = '';
  bool isPasswordShown = false;
  bool isPasswordEmpty = true;
  String login = '';

  @override
  void initState() {
    super.initState();

    _password = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _password.dispose();
  }

  void loginUser() async {
    String res =
        await AuthMethod().loginUser(email: email, password: _password.text);
    if (res == 'success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    } else {
      showSnackBar('Wrong password!', context, 100);
    }
  }

  Future takeEmailAdress(String dataType, String input) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where(dataType, isEqualTo: input)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          email = doc['email'];
        });
      }
    });
  }

  Future checkEmail(String text) async {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(text)) {
      setState(() {
        email = text;
      });
    } else if (RegExp(
            r'^[\+]?[(]?[[0-9]?[0-9]?[0-9]?[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
        .hasMatch(text)) {
      await takeEmailAdress("phoneNumer", text);
    } else {
      await takeEmailAdress("alias", text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments.toString();
    login = args;
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
                'Enter your password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                  enableInteractiveSelection: false,
                  focusNode: AlwaysDisabledFocusNode(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: login,
                  )),
              const SizedBox(
                height: 10,
              ),
              TextField(
                  controller: _password,
                  obscureText: isPasswordShown ? false : true,
                  autocorrect: false,
                  autofocus: true,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        isPasswordEmpty = false;
                      });
                    } else {
                      isPasswordEmpty = true;
                    }
                  },
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      suffixIcon: isPasswordShown
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordShown = false;
                                });
                              },
                              icon: const Icon(
                                Icons.visibility,
                                color: Colors.red,
                              ))
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordShown = true;
                                });
                              },
                              icon: const Icon(
                                Icons.visibility_off,
                                color: Colors.green,
                              )))),
              Expanded(child: Container()),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TwitterButton(
                      onPressed: () async {
                        _password.text.isNotEmpty
                            ? await checkEmail(login)
                            : null;
                        _password.text.isNotEmpty ? loginUser() : null;
                      },
                      buttonsText: 'Log in',
                      textColor: Colors.white,
                      backgroundColor: Colors.black),
                ],
              )
            ],
          ),
        ));
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
