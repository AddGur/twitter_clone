import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/screens/login_screens/enter_password_screen.dart';
import 'package:twitter_clone/providers/user_provider.dart';
import 'screens/login_screens/login_screen.dart';
import 'screens/signin_screens/add_alias_screen.dart';
import 'screens/signin_screens/add_description_screen.dart';
import 'screens/signin_screens/add_email_adress_screen.dart';
import 'screens/signin_screens/add_password_screen.dart';
import '../utilis/user.dart';
import 'firebase_options.dart';

import '../responsive/mobile_screen_layout.dart';
import '../screens/logged_screens/new_post_screen.dart';
import '../screens/logged_screens/profile_screen.dart';
import '../screens/logged_screens/selected_image_screen.dart';
import '../screens/main_screen.dart';
import 'screens/signin_screens/add_first_data_screen.dart';
import '../utilis/dummy_users.dart';

import 'screens/signin_screens/add_profile_picture_screen.dart';
import 'utilis/dummy_posts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Posts()),
        ChangeNotifierProvider(create: (ctx) => IsCommentEmpty()),
        ChangeNotifierProvider(create: (ctx) => IsNameEmpty()),
        ChangeNotifierProvider(create: (ctx) => NewUser()),
        ChangeNotifierProvider(create: (ctx) => RandomUsers()),
        ChangeNotifierProvider(create: (ctx) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainLoginScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          AddFirstDataScreen.routeName: (context) => const AddFirstDataScreen(),
          MainLoginScreen.routeName: (context) => const MainLoginScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          MobileScreenLayout.routeName: (context) => const MobileScreenLayout(),
          NewPostScreen.routeName: (context) => const NewPostScreen(),
          SelectedImageScreen.routeName: (context) =>
              const SelectedImageScreen(),
          ProfileScreen.routeName: (context) => const ProfileScreen(),
          AddEmailAdressScreen.routeName: (context) =>
              const AddEmailAdressScreen(),
          AddPasswordScreen.routeName: (context) => const AddPasswordScreen(),
          AddProfilePictureScreen.routeName: (context) =>
              const AddProfilePictureScreen(),
          AddDescriptionScreen.routeName: (context) =>
              const AddDescriptionScreen(),
          AddAliasScreen.routeName: (context) => const AddAliasScreen(),
          EnterPasswordScreen.routeName: (context) =>
              const EnterPasswordScreen(),
        },
      ),
    );
  }
}
