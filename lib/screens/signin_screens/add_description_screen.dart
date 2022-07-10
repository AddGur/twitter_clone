import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../utilis/user.dart';
import '../../../widgets/twitter_button.dart';

import 'dart:developer' as devtools show log;

import 'add_alias_screen.dart';

class AddDescriptionScreen extends StatefulWidget {
  static const routeName = '/addDesc';
  const AddDescriptionScreen({super.key});

  @override
  State<AddDescriptionScreen> createState() => _AddDescriptionScreenState();
}

class _AddDescriptionScreenState extends State<AddDescriptionScreen> {
  late TextEditingController _description;
  String yourBio = '';

  @override
  void initState() {
    super.initState();
    _description = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _description.dispose();
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
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Describe yourself',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'What makes you special? Don\'t think too hard, just have fun with it.',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _description,
                maxLines: 4,
                maxLength: 160,
                decoration: InputDecoration(
                    labelText: 'Your bio',
                    alignLabelWithHint: true,
                    border: const OutlineInputBorder(),
                    counterText: '${yourBio.length}/160'),
                onChanged: (value) {
                  setState(() {
                    yourBio = value;
                  });
                },
              ),
              const Expanded(child: SizedBox()),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TwitterButton(
                      onPressed: () {},
                      buttonsText: 'Skip for now',
                      textColor: Colors.black,
                      backgroundColor: Colors.white),
                  TwitterButton(
                      onPressed: () {
                        devtools.log(userData.birthday);
                        devtools.log(userData.name);
                        devtools.log(userData.email);
                        devtools.log(userData.password);
                        devtools.log(userData.photoUrl);
                        Navigator.pushNamed(context, AddAliasScreen.routeName);
                        userData.description = _description.text;
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
