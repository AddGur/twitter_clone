import 'package:flutter/material.dart';
import 'package:twitter_clone/screens/login_screens/enter_password_screen.dart';

import '../../responsive/mobile_screen_layout.dart';
import '../main_screen.dart';

import '../../widgets/twitter_button.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/loginscreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _loginController;

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
            TextField(
              controller: _loginController,
              decoration: const InputDecoration(
                  hintText: 'Phone, email address or username'),
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
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, EnterPasswordScreen.routeName,
                          arguments: _loginController.text);
                    },
                    buttonsText: 'Next',
                    textColor: Colors.black,
                    backgroundColor: Colors.white)
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
