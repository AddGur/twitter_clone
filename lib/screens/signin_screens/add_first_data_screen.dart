// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/screens/signin_screens/add_email_adress_screen.dart';
import 'package:twitter_clone/screens/signin_screens/add_password_screen.dart';
import '../../utilis/user.dart';
import '../../widgets/twitter_button.dart';
import '../main_screen.dart';

import 'dart:developer' as devtools show log;

class AddFirstDataScreen extends StatefulWidget {
  static const routeName = '/firstData';

  const AddFirstDataScreen({super.key});

  @override
  State<AddFirstDataScreen> createState() => _AddFirstDataScreenState();
}

class _AddFirstDataScreenState extends State<AddFirstDataScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _numberController;
  late final TextEditingController _emailController;
  late final TextEditingController _birtdayController;
  late final TextEditingController _passwordController;
  late FocusNode _focus;

  int nameLength = 0;
  bool _isFocusedEmailPhone = false;
  bool _emailChoosen = true;
  bool _isNumberCorrect = false;
  bool _isNameCorrect = true;
  bool _isEmailCorrect = false;
  bool _isEmailExists = false;

  DateTime birthdayDate = DateTime.now();

  @override
  void initState() {
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _emailController = TextEditingController();
    _birtdayController = TextEditingController();
    _passwordController = TextEditingController();
    _focus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _emailController.dispose();
    _birtdayController.dispose();
    _passwordController.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _switchKeybordType() {
    _focus.unfocus();
    setState(() {
      _emailChoosen = !_emailChoosen;
      _emailChoosen ? _emailController.clear() : _numberController.clear();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        return _focus.requestFocus();
      });
    });
  }

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: birthdayDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != birthdayDate) {
      setState(() {
        birthdayDate = picked;
        _birtdayController.value = TextEditingValue(
            text: DateFormat('dd MMMM yyyy').format(picked).toString());
      });
    }
  }

  Future getFireData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: _emailController.text)
        .get()
        .then((QuerySnapshot querySnapshot) {
      _isEmailExists = false;
      for (var doc in querySnapshot.docs) {
        _isEmailExists = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<NewUser>(context, listen: false);
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
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Create your account',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    autofocus: true,
                    onTap: () {
                      setState(() {
                        _isFocusedEmailPhone = false;
                      });
                    },
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      FocusScope.of(context).nextFocus();
                      setState(() {
                        _isFocusedEmailPhone = true;
                      });
                    },
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffixIcon: nameLength == 0
                          ? null
                          : _isNameCorrect
                              ? const Icon(
                                  FontAwesomeIcons.circleCheck,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  FontAwesomeIcons.circleExclamation,
                                  color: Colors.red,
                                ),
                      labelText: 'Name',
                      counterText: '${nameLength.toString()}/50',
                      errorText: _isNameCorrect
                          ? null
                          : 'Must be 50 characters or fewer',
                    ),
                    onChanged: (value) {
                      setState(() {
                        nameLength = _nameController.text.length;
                        if (nameLength > 50) {
                          _isNameCorrect = false;
                          devtools.log(_isNameCorrect.toString());
                        } else {
                          _isNameCorrect = true;
                          devtools.log(_isNameCorrect.toString());
                        }
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                      onTap: () {
                        setState(() {
                          _isFocusedEmailPhone = true;
                        });
                      },
                      onChanged: (value) async {
                        await getFireData();

                        setState(() {
                          if (_emailChoosen) {
                            if (RegExp(
                                    r'^[\+]?[(]?[[0-9]?[0-9]?[0-9]?[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
                                .hasMatch(_numberController.text)) {
                              _isNumberCorrect = true;
                              devtools
                                  .log('Numb ${_isNumberCorrect..toString()}');
                            } else {
                              _isNumberCorrect = false;
                              devtools
                                  .log('Numb ${_isNumberCorrect..toString()}');
                            }
                          } else {
                            if (RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(_emailController.text)) {
                              _isEmailCorrect = true;
                              devtools
                                  .log('Email ${_isEmailCorrect..toString()}');
                            } else {
                              _isEmailCorrect = false;
                              devtools
                                  .log('Email ${_isEmailCorrect..toString()}');
                            }
                          }
                        });
                      },
                      focusNode: _focus,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                        setState(() {
                          _isFocusedEmailPhone = false;
                        });
                        _selectDate(context);
                      },
                      keyboardType: _emailChoosen
                          ? TextInputType.phone
                          : TextInputType.text,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        suffixIcon: (_emailChoosen
                                ? _numberController.text.isEmpty
                                : _emailController.text.isEmpty)
                            ? null
                            : (_emailChoosen
                                    ? _isNumberCorrect
                                    : (_isEmailCorrect && !_isEmailExists))
                                ? const Icon(
                                    FontAwesomeIcons.circleCheck,
                                    color: Colors.green,
                                  )
                                : const Icon(
                                    FontAwesomeIcons.circleExclamation,
                                    color: Colors.red,
                                  ),
                        labelText: _isFocusedEmailPhone
                            ? _emailChoosen
                                ? 'Phone number'
                                : 'Email address'
                            : 'Phone number or email address',
                        errorText: (_emailChoosen
                                ? _numberController.text.isEmpty
                                : _emailController.text.isEmpty)
                            ? null
                            : (_emailChoosen
                                    ? _isNumberCorrect
                                    : _isEmailCorrect)
                                ? (_isEmailExists
                                    ? 'Email already exists'
                                    : null)
                                : (_emailChoosen
                                    ? 'Please enter a valid phone number'
                                    : 'Please enter a valid email'),
                      ),
                      controller:
                          _emailChoosen ? _numberController : _emailController),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectDate(context);
                      setState(() {
                        _isFocusedEmailPhone = false;
                      });
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _birtdayController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Date of birth',
                        ),
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  const Divider(),
                  Row(
                    mainAxisAlignment: _isFocusedEmailPhone
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.end,
                    children: [
                      _isFocusedEmailPhone
                          ? ElevatedButton(
                              onPressed: () {
                                _switchKeybordType();

                                _emailChoosen
                                    ? userData.email = ''
                                    : userData.phoneNumber = '';
                              },
                              child: Text(_emailChoosen
                                  ? 'Use email instead'
                                  : 'Use phone instead'))
                          : const SizedBox(),
                      TwitterButton(
                          onPressed: () {
                            if (_emailChoosen
                                ? _isNumberCorrect
                                : (_isEmailCorrect && !_isEmailExists) &&
                                    _isNameCorrect) {
                              if (_nameController.text.isNotEmpty &&
                                      _birtdayController.text.isNotEmpty &&
                                      _emailController.text.isNotEmpty ||
                                  _numberController.text.isNotEmpty) {
                                if (_emailController.text.isNotEmpty) {
                                  userData.setUserEmail(
                                      _nameController.text,
                                      _emailController.text,
                                      _birtdayController.text);

                                  Navigator.pushNamed(
                                      context, AddPasswordScreen.routeName);
                                } else {
                                  userData.setUserPhone(
                                      _nameController.text,
                                      _numberController.text,
                                      _birtdayController.text);

                                  Navigator.pushNamed(
                                      context, AddEmailAdressScreen.routeName);
                                }
                              }
                            }
                          },
                          buttonsText: 'Next',
                          textColor: Colors.black,
                          backgroundColor: Colors.white)
                    ],
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
