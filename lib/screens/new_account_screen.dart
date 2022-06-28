import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:twitter_clone/widgets/twitter_button.dart';
import 'package:twitter_clone/screens/main_screen.dart';
import 'package:intl/date_symbol_data_file.dart';

class NewAccountScreen extends StatefulWidget {
  static const routeName = '/newAccountScreen';

  const NewAccountScreen({super.key});

  @override
  State<NewAccountScreen> createState() => _NewAccountScreenState();
}

class _NewAccountScreenState extends State<NewAccountScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _numberController;
  late final TextEditingController _emailController;
  late final TextEditingController _birtdayController;
  late FocusNode _focus;

  int nameLength = 50;
  bool _isFocused = false;
  bool _emailChoosen = true;

  DateTime birthdayDate = DateTime.now();
// add locals option

  @override
  void initState() {
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _emailController = TextEditingController();
    _birtdayController = TextEditingController();
    _focus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _emailController.dispose();
    _birtdayController.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _switchKeybordType() {
    _focus.unfocus();
    setState(() {
      _emailChoosen = !_emailChoosen;
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
    if (picked != null && picked != birthdayDate)
      setState(() {
        birthdayDate = picked;
        _birtdayController.value = TextEditingValue(
            text: DateFormat('dd MMMM yyyy').format(picked).toString());
      });
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
          icon: Icon(Icons.arrow_back),
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
              child: Text(
                'Create your account',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
            ),
            TextField(
              autofocus: true,
              onTap: () {
                setState(() {
                  _isFocused = false;
                });
              },
              controller: _nameController,
              decoration: InputDecoration(
                  hintText: 'Name',
                  counterText: nameLength.toString(),
                  counterStyle: TextStyle(
                      color: nameLength > 0 ? Colors.black : Colors.red)),
              onChanged: (value) {
                setState(() {
                  nameLength = 50 - _nameController.text.length;
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
                keyboardType:
                    _emailChoosen ? TextInputType.phone : TextInputType.text,
                decoration: InputDecoration(
                    hintText: _isFocused
                        ? _emailChoosen
                            ? 'Phone number'
                            : 'Email address'
                        : 'Phone number or email address'),
                controller:
                    _emailChoosen ? _emailController : _numberController),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  // Add a datePicker
                  controller: _birtdayController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    hintText: 'Date of birth',
                  ),
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            Divider(),
            Row(
              mainAxisAlignment: _isFocused
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
              children: [
                _isFocused
                    ? ElevatedButton(
                        onPressed: () => _switchKeybordType(),
                        child: Text(_emailChoosen
                            ? 'Use email instead'
                            : 'Use phone instead'))
                    : SizedBox(),
                TwitterButton(
                    onPressed: () {},
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
