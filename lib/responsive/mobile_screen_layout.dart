import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/utilis/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  static const routeName = '/mainScreen';
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
      print(page);
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(_page == 0 ? Icons.home : Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(_page == 1 ? Icons.search : Icons.search_off_outlined),
          ),
          BottomNavigationBarItem(
            icon: Icon(_page == 2 ? Icons.doorbell : Icons.doorbell_outlined),
          ),
          BottomNavigationBarItem(
            icon: Icon(_page == 3 ? Icons.mail_lock : Icons.mail_lock_outlined),
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}