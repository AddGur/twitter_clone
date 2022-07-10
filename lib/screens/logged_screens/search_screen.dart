import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:provider/provider.dart';

import '../logged_screens/new_post_screen.dart';
//import 'package:twitter_clone/utilis/dummy_posts.dart';
import 'package:twitter_clone/widgets/drawer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    //  final posts = Provider.of<Posts>(context);

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
                      contentPadding: const EdgeInsets.all(10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      hintStyle: const TextStyle(fontSize: 15),
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
                    child: const CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Text(''),
                    ),
                  );
                }),
              ),
              actions: [
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ],
        ),
        drawer: const TwitterDrawer(),
        floatingActionButton: SpeedDial(
          buttonSize: const Size(50.0, 50.0),
          animatedIcon: AnimatedIcons.menu_close,
          overlayOpacity: 0.9,
          onClose: () => Navigator.pushNamed(context, NewPostScreen.routeName),
          children: [
            SpeedDialChild(
              child: const Icon(FontAwesomeIcons.gift),
              labelWidget: const Text('GIF   '),
            ),
            SpeedDialChild(
              child: const Icon(Icons.mail),
              labelWidget: const Text('Zdjęcia   '),
            ),
            SpeedDialChild(
              child: const Icon(Icons.mail),
              labelWidget: const Text('Pokoje   '),
            ),
          ],
        ));
  }
}
