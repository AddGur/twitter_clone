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

  int nameLength = 50;
  int phoneLegth = 9;
  bool _isFocused = false;
  bool _emailChoosen = true;

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

  @override
  Widget build(BuildContext context) {
    final IsNameEmpty isNameEmpty = Provider.of<IsNameEmpty>(context);
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
        child: Center(
          child: Column(children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Create your account',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
              ),
            ),
            TextField(
              autofocus: true,
              onTap: () {
                setState(() {
                  _isFocused = false;
                });
              },
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
                setState(() {
                  _isFocused = true;
                });
              },
              controller: _nameController,
              decoration: InputDecoration(
                  suffixIcon: isNameEmpty.isNameEmpty
                      ? null
                      : const Icon(
                          FontAwesomeIcons.circleCheck,
                          color: Colors.green,
                        ),
                  hintText: 'Name',
                  counterText: nameLength.toString(),
                  counterStyle: TextStyle(
                      color: nameLength > 0 ? Colors.black : Colors.red)),
              onChanged: (value) {
                setState(() {
                  nameLength = 50 - _nameController.text.length;

                  if (_nameController.text.isEmpty) {
                    context.read<IsNameEmpty>().setTrue();
                  } else {
                    context.read<IsNameEmpty>().setFalse();
                  }
                });
              },
            ),
            TextField(
                onTap: () {
                  setState(() {
                    _isFocused = true;
                  });
                },
                focusNode: _focus,
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                  setState(() {
                    _isFocused = false;
                  });
                  _selectDate(context);
                },
                keyboardType:
                    _emailChoosen ? TextInputType.phone : TextInputType.text,
                decoration: InputDecoration(
                    hintText: _isFocused
                        ? _emailChoosen
                            ? 'Phone number'
                            : 'Email address'
                        : 'Phone number or email address'),
                controller:
                    _emailChoosen ? _numberController : _emailController),
            GestureDetector(
              onTap: () {
                _selectDate(context);
                setState(() {
                  _isFocused = false;
                });
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: _birtdayController,
                  decoration: const InputDecoration(
                    hintText: 'Date of birth',
                  ),
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            const Divider(),
            Row(
              mainAxisAlignment: _isFocused
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
              children: [
                _isFocused
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
                      if (_nameController.text.isNotEmpty &&
                              _birtdayController.text.isNotEmpty &&
                              _emailController.text.isNotEmpty ||
                          _numberController.text.isNotEmpty) {
                        if (_emailController.text.isNotEmpty) {
                          userData.setUserEmail(_nameController.text,
                              _emailController.text, _birtdayController.text);

                          devtools.log(userData.phoneNumber);
                          Navigator.pushNamed(
                              context, AddPasswordScreen.routeName);
                        } else {
                          userData.setUserPhone(_nameController.text,
                              _numberController.text, _birtdayController.text);

                          Navigator.pushNamed(
                              context, AddEmailAdressScreen.routeName);
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
      ),
    );
  }
}

class IsNameEmpty with ChangeNotifier {
  bool _isNameEmpty = true;
  bool get isNameEmpty => _isNameEmpty;

  void setFalse() {
    _isNameEmpty = false;
    notifyListeners();
  }

  void setTrue() {
    _isNameEmpty = true;
    notifyListeners();
  }
}
