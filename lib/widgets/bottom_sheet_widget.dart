import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/providers/user_provider.dart';
import 'package:twitter_clone/resources/firestore_methods.dart';
import 'package:twitter_clone/utilis/user.dart';
import '../../utilis/user.dart' as model;

class TwitterBottomSheet extends StatefulWidget {
  final snap;
  const TwitterBottomSheet({super.key, required this.snap});

  @override
  State<TwitterBottomSheet> createState() => _TwitterBottomSheetState();
}

class _TwitterBottomSheetState extends State<TwitterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: IconButton(
            icon: const Icon(
              FontAwesomeIcons.ellipsisVertical,
              size: 16,
            ),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: 100,
                      color: Color(0xff737373),
                      child: Container(
                        child: _buildBottomNavigationMenu(snap: widget.snap),
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20)),
                        ),
                      ),
                    );
                  });
            }));
  }
}

class _buildBottomNavigationMenu extends StatefulWidget {
  const _buildBottomNavigationMenu({
    Key? key,
    required this.snap,
  }) : super(key: key);

  final snap;

  @override
  State<_buildBottomNavigationMenu> createState() =>
      _buildBottomNavigationMenuState();
}

class _buildBottomNavigationMenuState
    extends State<_buildBottomNavigationMenu> {
  bool isFollowing = false;

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.snap['uid'])
          .get();
      isFollowing = userSnap.data()!['followers'].contains(
            FirebaseAuth.instance.currentUser!.uid,
          );
      setState(() {});
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        user.uid == widget.snap['uid']
            ? ListTile(
                leading: const Icon(FontAwesomeIcons.trashCan),
                title: const Text('Delete Tweet'),
                onTap: () =>
                    FirestoreMethods().deletePost(widget.snap['postId']))
            : isFollowing
                ? ListTile(
                    leading: const Icon(FontAwesomeIcons.userMinus),
                    title: Text('Unfollow @${widget.snap['alias']}'),
                    onTap: () {})
                : ListTile(
                    leading: const Icon(FontAwesomeIcons.userPlus),
                    title: Text('Follow @${widget.snap['alias']}'),
                    onTap: () {})
      ],
    );
  }
}
