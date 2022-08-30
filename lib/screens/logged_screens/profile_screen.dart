// ignore_for_file: avoid_print, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/widgets/twitter_button.dart';
import 'dart:developer' as devtools show log;
import '../../providers/user_provider.dart';
import '../../resources/firestore_methods.dart';
import '../../utilis/user.dart' as model;
import '../../widgets/post_widget.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profileScreen';
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  var top = 0.0;
  late ScrollController _scrollController;
  late TabController _tabController;
  bool isHidden = false;
  var userDate = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isLoading = false;
  bool isYourProfile = false;
  bool isFollowing = false;

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      userDate = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap.data()!['followers'].contains(
            FirebaseAuth.instance.currentUser!.uid,
          );
      setState(() {});
    } catch (e) {
      print(
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    if (user.uid == widget.uid) {
      setState(() {
        isYourProfile = true;
      });
    }
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: DefaultTabController(
              length: 4,
              child: Stack(
                children: [
                  CustomScrollView(controller: _scrollController, slivers: [
                    SliverAppBar(
                        leading: IconButton(
                            onPressed: Navigator.of(context).pop,
                            icon: const Icon(Icons.arrow_back)),
                        actions: [
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.search)),
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.abc))
                        ],
                        expandedHeight: 150.0,
                        primary: true,
                        pinned: true,
                        flexibleSpace: LayoutBuilder(builder: (ctx, cons) {
                          top = cons.biggest.height;
                          return FlexibleSpaceBar(
                            title: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: isHidden ? 1 : 0.0,
                              child: Column(children: const [
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
                        SizedBox(
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
                                        child: isYourProfile
                                            ? TwitterButton(
                                                onPressed: () {},
                                                buttonsText: 'Edit profile',
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black)
                                            : isFollowing
                                                ? TwitterButton(
                                                    backgroundColor:
                                                        Colors.white,
                                                    buttonsText: 'Unfollow',
                                                    textColor: Colors.black,
                                                    onPressed: () async {
                                                      await FirestoreMethods()
                                                          .followUser(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        userDate['uid'],
                                                      );
                                                      setState(() {
                                                        isFollowing = false;
                                                        followers--;
                                                      });
                                                    },
                                                  )
                                                : TwitterButton(
                                                    buttonsText: 'Follow',
                                                    backgroundColor:
                                                        Colors.white,
                                                    textColor: Colors.black,
                                                    onPressed: () async {
                                                      await FirestoreMethods()
                                                          .followUser(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        userDate['uid'],
                                                      );
                                                      setState(() {
                                                        isFollowing = true;
                                                        followers++;
                                                      });
                                                    })),
                                    Text(
                                      userDate['username'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      '@${userDate['alias']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: Colors.grey),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          FontAwesomeIcons.baby,
                                          size: 18,
                                        ),
                                        Text(
                                          ' Born ${userDate['birthday']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Icon(
                                          FontAwesomeIcons.calendarDay,
                                          size: 18,
                                        ),
                                        Text(' Joined ${userDate['joined']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400)),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '$following Following   $followers Followers',
                                          style: const TextStyle(fontSize: 15),
                                        ),
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
                                backgroundImage:
                                    NetworkImage(userDate['photoUrl']),
                              ),
                            ))
                      ],
                    )),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          controller: _tabController,
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 5.0),
                          indicatorSize: TabBarIndicatorSize.label,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          tabs: const [
                            Tab(text: 'Tweets'),
                            Tab(text: 'Tweets & replies'),
                            Tab(text: 'Media'),
                            Tab(text: 'Likes'),
                          ],
                        ),
                      ),
                      pinned: true,
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: double.maxFinite,
                            child: TabBarView(
                                controller: _tabController,
                                children: [
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('posts')
                                          .where('uid', isEqualTo: widget.uid)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return ListView.builder(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          itemCount: (snapshot.data! as dynamic)
                                              .docs
                                              .length,
                                          itemBuilder: (context, index) {
                                            return PostWidget(
                                                snap:
                                                    (snapshot.data! as dynamic)
                                                        .docs[index]
                                                        .data());
                                          },
                                        );
                                      }),
                                  const Text('Tweett and answer'),
                                  const Text('Media'),
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('posts')
                                          .where('likes',
                                              arrayContains: widget.uid)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return ListView.builder(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          itemCount: (snapshot.data! as dynamic)
                                              .docs
                                              .length,
                                          itemBuilder: (context, index) {
                                            return PostWidget(
                                                snap:
                                                    (snapshot.data! as dynamic)
                                                        .docs[index]
                                                        .data());
                                          },
                                        );
                                      }),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  _buildFab(isHidden, userDate['photoUrl']),
                ],
              ),
            ),
            //     }),
          );
  }

  Widget _buildFab(bool isHidden, String imgUrl) {
    const double defaultMargin = 160;
    const double defaultStart = 130;
    const double defaultEnd = defaultStart / 2;

    double top = defaultMargin;
    double scale = 1.0;

    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top -= offset;

      if (offset < defaultMargin - defaultStart) {
        scale = 1.0;
      } else if (offset < defaultStart - defaultEnd) {
        scale = (defaultMargin - defaultEnd - offset) / defaultEnd;
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
