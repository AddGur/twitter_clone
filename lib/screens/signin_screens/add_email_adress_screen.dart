// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utilis/user.dart';

class AddEmailAdressScreen extends StatefulWidget {
  static const routeName = '/add_email';
  const AddEmailAdressScreen({super.key});

  @override
  State<AddEmailAdressScreen> createState() => _AddEmailAdressScreenState();
}

class _AddEmailAdressScreenState extends State<AddEmailAdressScreen> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<NewUser>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Add email')),
      body: Text(userData.email),
    );
  }
}
