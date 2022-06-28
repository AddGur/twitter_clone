import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/screens/logged_screens/new_post_screen.dart';
import 'package:twitter_clone/screens/logged_screens/selected_image_screen.dart';
import 'package:twitter_clone/utilis/dummy_posts.dart';
import 'package:twitter_clone/widgets/drawer.dart';
import 'package:twitter_clone/widgets/post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<Posts>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
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
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Text('A'),
                    ),
                  );
                }),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
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
                  return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            SelectedImageScreen.routeName,
                            arguments: posts.dummyPost[index].postId);
                      },
                      child: PostWidget(postData: posts.dummyPost[index])
                      //),
                      );
                },
                childCount: posts.dummyPost.length,
              ),
            ),
          ],
        ),
        drawer: TwitterDrawer(),
        floatingActionButton: SpeedDial(
          buttonSize: const Size(50.0, 50.0),
          animatedIcon: AnimatedIcons.menu_close,
          overlayOpacity: 0.9,
          onClose: () => Navigator.pushNamed(context, NewPostScreen.routeName),
          children: [
            SpeedDialChild(
              child: Icon(FontAwesomeIcons.gift),
              labelWidget: Text('GIF   '),
            ),
            SpeedDialChild(
              child: Icon(Icons.mail),
              labelWidget: Text('Photos   '),
            ),
            SpeedDialChild(
              child: Icon(Icons.mail),
              labelWidget: Text('Spaces   '),
            ),
          ],
        ));
  }
}
