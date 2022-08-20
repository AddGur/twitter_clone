import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/resources/auth_method.dart';

import '../../providers/user_provider.dart';
import '../../utilis/user.dart' as model;
import '../logged_screens/new_post_screen.dart';
import '../logged_screens/selected_image_screen.dart';
import 'package:twitter_clone/utilis/dummy_posts.dart';
import 'package:twitter_clone/widgets/drawer.dart';
import 'package:twitter_clone/widgets/post_widget.dart';

import 'dart:developer' as devtools show log;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final posts = Provider.of<Posts>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    systemOverlayStyle:
                        SystemUiOverlayStyle(statusBarColor: Colors.white),
                    backgroundColor: Colors.white,
                    floating: true,
                    expandedHeight: 30.0,
                    title: Image.asset('assets/images/twitter_logo.png',
                        height: 20, fit: BoxFit.cover),
                    centerTitle: true,
                    leadingWidth: 40,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Builder(builder: (context) {
                        return GestureDetector(
                          onDoubleTap: () => AuthMethod().logoutUser(),
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: user.photoUrl!.isEmpty
                                ? NetworkImage(
                                    'https://cdn.iconscout.com/icon/premium/png-256-thumb/profile-3891967-3227614.png')
                                : NetworkImage(user.photoUrl!),
                          ),
                        );
                      }),
                    ),
                    actions: const [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.star_outline,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return snapshot.data!.docs.length > 0
                            ? PostWidget(
                                snap: snapshot.data!.docs[index].data())
                            : Center(
                                child: Text('Add post'),
                              );
                      },
                      childCount: snapshot.data!.docs.length,
                    ),
                  ),
                ],
              );
            }),
        drawer: const TwitterDrawer(),
        floatingActionButton: SpeedDial(
          buttonSize: const Size(50.0, 50.0),
          animatedIcon: AnimatedIcons.view_list,
          overlayOpacity: 0.9,
          onClose: () => Navigator.pushNamed(context, NewPostScreen.routeName),
          children: [
            SpeedDialChild(
              child: const Icon(FontAwesomeIcons.gift),
              labelWidget: const Text('GIF\t'),
            ),
            SpeedDialChild(
              child: const Icon(Icons.mail),
              labelWidget: const Text('Photos\t'),
              onTap: () {
                devtools.log(FirebaseAuth.instance.currentUser!.uid.toString());
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.mail),
              labelWidget: const Text('Spaces\t'),
            ),
          ],
        ));
  }
}
