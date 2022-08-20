import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/widgets/twitter_button.dart';
import '../../utilis/user.dart' as model;
import 'dart:developer' as devtools show log;

import '../../providers/user_provider.dart';
import '../../widgets/post_widget.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profileScreen';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var top = 0.0;
  late ScrollController _scrollController;
  bool isHidden = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return DefaultTabController(
              length: 4,
              child: Stack(
                children: [
                  CustomScrollView(controller: _scrollController, slivers: [
                    SliverAppBar(
                        leading: Icon(Icons.arrow_back),
                        actions: [
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.search)),
                          IconButton(onPressed: () {}, icon: Icon(Icons.abc))
                        ],
                        expandedHeight: 150.0,
                        primary: true,
                        pinned: true,
                        flexibleSpace: LayoutBuilder(builder: (ctx, cons) {
                          top = cons.biggest.height;
                          return FlexibleSpaceBar(
                            title: AnimatedOpacity(
                              duration: Duration(milliseconds: 300),
                              opacity: isHidden ? 1 : 0.0,
                              child: Column(children: [
                                SizedBox(
                                  height: 22,
                                ),
                                Text(
                                  'John Doe',
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  'followe',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ]),
                            ),
                            background: Image.network(
                              'https://sm.ign.com/t/ign_pl/screenshot/default/twitter-logo_uuha.1280.jpg',
                              fit: BoxFit.cover,
                            ),
                          );
                        })),
                    SliverToBoxAdapter(
                        child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Container(
                            width: double.infinity,
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: TwitterButton(
                                          onPressed: () {},
                                          buttonsText: 'Edit profile',
                                          backgroundColor: Colors.white,
                                          textColor: Colors.black),
                                    ),
                                    Text(
                                      user.username,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      '@${user.alias}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: Colors.grey),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.baby,
                                          size: 18,
                                        ),
                                        Text(
                                          ' Born ${user.birthday}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          FontAwesomeIcons.calendarDay,
                                          size: 18,
                                        ),
                                        Text(' Joined ${user.joined}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            print(isHidden.toString());
                                          },
                                          child: Text(
                                            '${user.following.length} Following   ${user.followers.length} Followers',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        )
                                      ],
                                    )
                                  ]),
                            )),
                        Positioned(
                            top: 11,
                            left: 55,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20,
                              child: CircleAvatar(
                                radius: 18.4,
                                backgroundColor: Colors.blue,
                                backgroundImage: NetworkImage(user.photoUrl!),
                              ),
                            ))
                      ],
                    )),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          labelPadding: EdgeInsets.symmetric(horizontal: 5.0),
                          indicatorSize: TabBarIndicatorSize.label,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(text: 'Tweets'),
                            Tab(text: 'Tweets & replies'),
                            Tab(text: 'Media'),
                            Tab(text: 'Likes'),
                          ],
                        ),
                      ),
                      pinned: true,
                    ),
                    SliverFixedExtentList(
                        delegate: SliverChildListDelegate([
                          ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) => PostWidget(
                              snap: snapshot.data!.docs[index].data(),
                            ),
                          ),
                        ]),
                        itemExtent: 300)
                  ]),
                  _buildFab(isHidden, user.photoUrl!),
                ],
              ),
            );
          }),
    );
  }

  Widget _buildFab(bool isHidden, String imgUrl) {
    final double defaultMargin = 160;
    final double defaultStart = 130;
    final double defaultEnd = defaultStart / 2;

    double top = defaultMargin;
    double scale = 1.0;

    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top -= offset;
      devtools.log('OFFSET ${offset.toString()}');
      devtools.log('TOP ${top.toString()}');

      if (offset < defaultMargin - defaultStart) {
        scale = 1.0;
      } else if (offset < defaultStart - defaultEnd) {
        scale = (defaultMargin - defaultEnd - offset) / defaultEnd;
        devtools.log('SCALE ${scale.toString()}');
      } else if (offset > 105) {
        scale = 0;
      } else {
        scale = 0.4;
      }

      if (offset > 165) {
        setState(() {
          isHidden = true;
        });
      } else {
        setState(() {
          isHidden = false;
        });
      }
    }
    return Positioned(
        top: top - 35,
        left: 25,
        child: Transform(
            alignment: Alignment.bottomCenter,
            transform: Matrix4.identity()..scale(scale),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50,
              child: CircleAvatar(
                  radius: 46,
                  backgroundColor: Colors.blue,
                  backgroundImage: NetworkImage(imgUrl)),
            )));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
        child: Container(
      child: _tabBar,
    ));
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
