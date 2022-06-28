import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/responsive/mobile_screen_layout.dart';
import 'package:twitter_clone/screens/logged_screens/home_screen.dart';
import 'package:twitter_clone/screens/logged_screens/new_post_screen.dart';
import 'package:twitter_clone/screens/logged_screens/profile_screen.dart';
import 'package:twitter_clone/screens/logged_screens/search_screen.dart';
import 'package:twitter_clone/screens/logged_screens/selected_image_screen.dart';
import 'package:twitter_clone/screens/login_screen.dart';
import 'package:twitter_clone/screens/main_screen.dart';
import 'package:twitter_clone/screens/new_account_screen.dart';
import 'package:twitter_clone/utilis/dummy_users.dart';

import 'utilis/dummy_posts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Users()),
        ChangeNotifierProvider(create: (ctx) => Posts()),
        ChangeNotifierProvider(create: (ctx) => IsCommentEmpty()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainLoginScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          NewAccountScreen.routeName: (context) => NewAccountScreen(),
          MainLoginScreen.routeName: (context) => MainLoginScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
          MobileScreenLayout.routeName: (context) => MobileScreenLayout(),
          NewPostScreen.routeName: (context) => NewPostScreen(),
          SelectedImageScreen.routeName: (context) => SelectedImageScreen(),
          ProfileScreen.routeName: (context) => ProfileScreen(),
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                bottom: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.call), text: "Call"),
                    Tab(icon: Icon(Icons.message), text: "Message"),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              SearchScreen(),
              HomeScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
