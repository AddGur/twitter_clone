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

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
              title: SizedBox(
                height: 30,
                child: TextField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      hintStyle: TextStyle(fontSize: 15),
                      hintText: "Search Twitter",
                      fillColor: Colors.grey[200]),
                ),
              ),
              centerTitle: true,
              leadingWidth: 40,
              leading: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Builder(builder: (context) {
                  return GestureDetector(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Text(''),
                    ),
                  );
                }),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                )
              ],
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
              labelWidget: Text('Zdjęcia   '),
            ),
            SpeedDialChild(
              child: Icon(Icons.mail),
              labelWidget: Text('Pokoje   '),
            ),
          ],
        ));
  }
}
