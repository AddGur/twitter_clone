// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../utilis/user.dart';
import '../../widgets/twitter_button.dart';
import 'add_profile_picture_screen.dart';

class AddPasswordScreen extends StatefulWidget {
  static const routeName = '/passwordscreen';
  const AddPasswordScreen({super.key});

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  late TextEditingController _password;
  bool _isPasswordShown = false;
  bool _isPasswordCorrect = false;

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

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<NewUser>(context);
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
                'You\'ll need a password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Maske sure it\'s 8 characters or more.',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                  controller: _password,
                  obscureText: _isPasswordShown ? false : true,
                  autocorrect: false,
                  autofocus: true,
                  onChanged: (value) {
                    if (_password.text.length > 7) {
                      setState(() {
                        _isPasswordCorrect = true;
                      });
                    } else {
                      setState(() {
                        _isPasswordCorrect = false;
                      });
                    }
                  },
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      suffixIcon: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _isPasswordShown
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordShown = false;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.visibility_off,
                                    color: Colors.green,
                                  ))
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordShown = true;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.visibility,
                                    color: Colors.red,
                                  )),
                          if (!_isPasswordCorrect && _password.text.isNotEmpty)
                            const Icon(
                              FontAwesomeIcons.circleExclamation,
                              color: Colors.red,
                            ),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ))),
              Expanded(child: Container()),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TwitterButton(
                      onPressed: () async {
                        try {
                          Navigator.pushNamed(
                              context, AddProfilePictureScreen.routeName);
                          userData.password = _password.text;
                        } on FirebaseAuthException catch (e) {
                          print(e);
                        } catch (e) {
                          print(e);
                        }
                      },
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
