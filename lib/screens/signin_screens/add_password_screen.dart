import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  bool isPasswordShown = false;

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
              Text(
                'You\'ll need a password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Maske sure it\'s 8 characters or more.',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                  controller: _password,
                  obscureText: isPasswordShown ? false : true,
                  autocorrect: false,
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: isPasswordShown
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordShown = false;
                                });
                              },
                              icon: Icon(
                                Icons.visibility_off,
                                color: Colors.green,
                              ))
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordShown = true;
                                });
                              },
                              icon: Icon(
                                Icons.visibility,
                                color: Colors.red,
                              )))),
              Expanded(child: Container()),
              Divider(),
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
                          if (e.code == 'weak-password') {
                            print('The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                          }
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
