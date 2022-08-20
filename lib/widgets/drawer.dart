import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../screens/logged_screens/profile_screen.dart';
import 'dart:developer' as devtools show log;
import '../../utilis/user.dart' as model;

class TwitterDrawer extends StatelessWidget {
  const TwitterDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    Widget usersInfo({
      required String imgUrl,
      required String name,
      required String alias,
      required int followers,
      required int following,
    }) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProfileScreen.routeName);
            },
            child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 30,
                backgroundImage: NetworkImage(imgUrl))),
        const SizedBox(
          height: 10,
        ),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        Text(
          '@$alias',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: Colors.grey[700]),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              followers.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const Text('Folllowing'),
            const SizedBox(
              width: 10,
            ),
            Text(
              following.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const Text('Followers'),
          ],
        ),
        const Divider()
      ]);
    }

    Widget buildMenuItem({
      required String text,
      required IconData icon,
      required Function()? onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: ListTile(
          visualDensity: const VisualDensity(horizontal: -2, vertical: -4),
          leading: Icon(icon),
          title: Text(text),
        ),
      );
    }

    return Drawer(
        child: Padding(
      padding: const EdgeInsets.only(top: 50, left: 30),
      child: Column(
        children: [
          usersInfo(
              imgUrl: user.photoUrl!.isEmpty
                  ? 'https://cdn.iconscout.com/icon/premium/png-256-thumb/profile-3891967-3227614.png'
                  : user.photoUrl.toString(),
              name: user.username,
              alias: user.alias,
              followers: user.followers.length,
              following: user.following.length),
          ListView(
            shrinkWrap: true,
            children: [
              buildMenuItem(
                text: 'Profile',
                icon: Icons.person_outline,
                onTap: () => devtools.log('profile'),
              ),
              buildMenuItem(
                text: 'Lists',
                icon: Icons.list_alt,
                onTap: () => devtools.log('lists'),
              ),
              buildMenuItem(
                text: 'Topics',
                icon: Icons.add_comment_outlined,
                onTap: () => devtools.log('topic'),
              ),
              buildMenuItem(
                text: 'Bookmarks',
                icon: Icons.bookmark,
                onTap: () => devtools.log('bookmarks'),
              ),
              buildMenuItem(
                text: 'Moments',
                icon: Icons.light_mode_outlined,
                onTap: () => devtools.log('moments'),
              ),
              buildMenuItem(
                text: 'Monetisation',
                icon: Icons.money_rounded,
                onTap: () => devtools.log('monetisation'),
              ),
              const Divider(),
              buildMenuItem(
                text: 'Twitter for Professionals',
                icon: Icons.rocket,
                onTap: () => devtools.log('Twitter for professionals'),
              ),
              const Divider(),
              GestureDetector(
                onTap: () => devtools.log('settings and privacy'),
                child: const ListTile(
                  visualDensity: VisualDensity(horizontal: -2, vertical: -4),
                  leading: Text('Setting and privacy'),
                ),
              ),
              GestureDetector(
                onTap: () => devtools.log('settings'),
                child: const ListTile(
                  visualDensity: VisualDensity(horizontal: -2, vertical: -4),
                  leading: Text('Help Centre'),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
