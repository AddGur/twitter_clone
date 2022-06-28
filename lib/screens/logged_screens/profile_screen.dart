import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profileScreen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> // {
    with
        TickerProviderStateMixin {
  var top = 0.0;

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
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
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
                    IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                  ],
                  expandedHeight: 320,
                  flexibleSpace: LayoutBuilder(
                    builder: (ctx, cons) {
                      top = cons.biggest.height;
                      return FlexibleSpaceBar(
                          title: AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: top <= 150 ? 1.0 : 0.0,
                            child: Column(children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text('Name'),
                              Text(
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
                              Container(
                                height: 200,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20))),
                                              onPressed: () {},
                                              child: Text(
                                                'Edytuj profil',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                        ),
                                        Text(
                                          'Name',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          '@allias',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 15),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.local_hospital_outlined,
                                              size: 15,
                                            ),
                                            Text(
                                              'Urodziny: 11 czerwaca 2004',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_month,
                                              size: 15,
                                            ),
                                            Text(
                                              'Dołączył/a czerwiec 2004',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
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
                        Tab(
                          text: 'Tweety',
                        ),
                        Tab(
                          text: 'Tweety i odpowiedzi',
                        ),
                        Tab(
                          text: 'Multimedia',
                        ),
                        Tab(
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
                              return ListTile(
                                leading: CircleAvatar(radius: 10),
                                title: Text('Title'),
                              );
                            },
                            itemCount: 50,
                          ),
                          Text('Tweett and answer'),
                          Text('Multi'),
                          Text('Multi'),
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
    final double defaultMargin = 90;
    final double defaultStart = 80;
    final double defaultEnd = defaultStart / 2;

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
          radius: 35,
        ),
      ),
    );
  }
}
