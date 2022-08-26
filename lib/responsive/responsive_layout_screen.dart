import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class ResponsiveLayout extends StatefulWidget {
  static const routeName = '/respLayout';

  final Widget mobileScreenLayout;
  const ResponsiveLayout({
    Key? key,
    required this.mobileScreenLayout,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    setState(() {
      isLoading = true;
    });
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : LayoutBuilder(builder: (context, constraints) {
            return widget.mobileScreenLayout;
          });
  }
}
