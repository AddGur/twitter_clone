import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profileScreen';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  var top = 0.0;
  var userDate = {};

  late ScrollController _scrollController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
    _tabController = TabController(length: 4, vsync: this);
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userDate = userSnap.data()!;
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  backgroundColor: top <= 150 ? Colors.blue : Colors.white,
                  floating: false,
                  pinned: true,
                  snap: false,
                  actions: [
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.search)),
                  ],
                  expandedHeight: 320,
                  flexibleSpace: LayoutBuilder(
                    builder: (ctx, cons) {
                      top = cons.biggest.height;
                      return FlexibleSpaceBar(
                          title: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: top <= 150 ? 1.0 : 0.0,
                            child: Column(children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Text('Name'),
                              const Text(
                                'Tweets: 4',
                                style: TextStyle(fontSize: 14),
                              ),
                            ]),
                          ),
                          background: Column(
                            children: [
                              Container(
                                height: 130,
                                width: double.infinity,
                                child: Image.network(
                                  'https://media.istockphoto.com/photos/human-hologram-of-people-crowd-picture-id1177346488?k=20&m=1177346488&s=612x612&w=0&h=jQWoBlLkTF_773Avn8t_4daQA6hxlrcLmmo9sdoPb1Y=',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20))),
                                              onPressed: () {},
                                              child: const Text(
                                                'Edytuj profil',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                        ),
                                        const Text(
                                          'Name',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        const Text(
                                          '@allias',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 15),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.local_hospital_outlined,
                                              size: 15,
                                            ),
                                            const Text(
                                              'Urodziny: 11 czerwaca 2004',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_month,
                                              size: 15,
                                            ),
                                            const Text(
                                              'Dołączył/a czerwiec 2004',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              '3 Obserwowani 0 Obserwowani',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                              )
                            ],
                          ));
                    },
                  ),
                  bottom: TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      controller: _tabController,
                      isScrollable: true,
                      tabs: [
                        const Tab(
                          text: 'Tweety',
                        ),
                        const Tab(
                          text: 'Tweety i odpowiedzi',
                        ),
                        const Tab(
                          text: 'Multimedia',
                        ),
                        const Tab(
                          text: 'Polubienia',
                        ),
                      ]),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Container(
                        height: 1000,
                        width: double.maxFinite,
                        child:
                            TabBarView(controller: _tabController, children: [
                          ListView.builder(
                            itemBuilder: (context, index) {
                              return const ListTile(
                                leading: CircleAvatar(radius: 10),
                                title: Text('Title'),
                              );
                            },
                            itemCount: 50,
                          ),
                          const Text('Tweett and answer'),
                          const Text('Multi'),
                          const Text('Multi'),
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _avatar(),
          ],
        ),
      ),
    );
  }

  Widget _avatar() {
    const double defaultMargin = 90;
    const double defaultStart = 80;
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
      } else {
        scale = 0.0;
      }
    }

    return Positioned(
      top: top,
      left: 20,
      child: Transform(
        transform: Matrix4.identity()..scale(scale),
        child: CircleAvatar(
          backgroundImage: NetworkImage(
            userDate['photoUrl'],
          ),
          radius: 35,
        ),
      ),
    );
  }
}
