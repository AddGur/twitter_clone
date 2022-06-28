import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/screens/logged_screens/profile_screen.dart';
import 'dart:developer' as devtools show log;

import '../utilis/dummy_users.dart';

class TwitterDrawer extends StatelessWidget {
  const TwitterDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    Widget UsersInfo({
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
                radius: 30, backgroundImage: NetworkImage(imgUrl))),
        SizedBox(
          height: 10,
        ),
        Text(
          name,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        Text(
          '@$alias',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: Colors.grey[700]),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              followers.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text('Obserwowani'),
            SizedBox(
              width: 10,
            ),
            Text(
              following.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text('Obserwujący'),
          ],
        ),
        Divider()
      ]);
    }

    Widget BuildMenuItem({
      required String text,
      required IconData icon,
      required Function()? onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: ListTile(
          visualDensity: VisualDensity(horizontal: -2, vertical: -4),
          leading: Icon(icon),
          title: Text(text),
        ),
      );
    }

    final user = Provider.of<Users>(context);
    final userDummy = user.dummyUsers[0];

    return Drawer(
        child: Padding(
      padding: const EdgeInsets.only(top: 50, left: 30),
      child: Column(
        children: [
          UsersInfo(
              imgUrl: userDummy.userImageUrl,
              name: userDummy.userName,
              alias: userDummy.userAlias,
              followers: userDummy.followers,
              following: userDummy.following),
          ListView(
            shrinkWrap: true,
            children: [
              BuildMenuItem(
                text: 'Profil',
                icon: Icons.person_outline,
                onTap: () => devtools.log('profile'),
              ),
              BuildMenuItem(
                text: 'Listy',
                icon: Icons.list_alt,
                onTap: () => devtools.log('lists'),
              ),
              BuildMenuItem(
                text: 'Tematy',
                icon: Icons.add_comment_outlined,
                onTap: () => devtools.log('theme'),
              ),
              BuildMenuItem(
                text: 'Zakładki',
                icon: Icons.bookmark,
                onTap: () => devtools.log('bookmarks'),
              ),
              BuildMenuItem(
                text: 'Chwile',
                icon: Icons.light_mode_outlined,
                onTap: () => devtools.log('moments'),
              ),
              BuildMenuItem(
                text: 'Monetyzacja',
                icon: Icons.money_rounded,
                onTap: () => devtools.log('monetization'),
              ),
              Divider(),
              BuildMenuItem(
                text: 'Twitter dla profesjonalistów',
                icon: Icons.rocket,
                onTap: () => devtools.log('Twitter for professionalist'),
              ),
              Divider(),
              GestureDetector(
                onTap: () => devtools.log('settings and privacy'),
                child: ListTile(
                  visualDensity: VisualDensity(horizontal: -2, vertical: -4),
                  leading: Text('Ustawienie i prywatność'),
                ),
              ),
              GestureDetector(
                onTap: () => devtools.log('help center'),
                child: ListTile(
                  visualDensity: VisualDensity(horizontal: -2, vertical: -4),
                  leading: Text('Centrum pomocy'),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
