import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/utilis/user.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../providers/user_provider.dart';
import '../screens/logged_screens/selected_image_screen.dart';
import '../utilis/dummy_posts.dart';
import 'dart:developer' as devtools show log;

class PostWidget extends StatefulWidget {
  final snap;
  const PostWidget({
    super.key,
    required this.snap,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    // final User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(widget.snap['profImage']),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.snap['username'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.snap['alias'],
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[700]),
                          ),
                          Text(
                            ' . 16g.',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.list,
                        size: 16,
                      ),
                    ],
                  ),
                  Text(
                    widget.snap['description'],
                  ),
                  if (widget.snap['postUrl'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: widget.snap['postUrl'].length == 1
                          ? GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    SelectedImageScreen.routeName,
                                    arguments: PassArguments(
                                        widget.snap['postId'], 0));
                              },
                              child: Image.network(
                                widget.snap['postUrl'][0],
                              ),
                            )
                          : widget.snap['postUrl'].length == 3
                              ? StaggeredGridView.countBuilder(
                                  scrollDirection: Axis.vertical,
                                  physics: PageScrollPhysics(),
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  itemCount: widget.snap['postUrl'].length,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          SelectedImageScreen.routeName,
                                          arguments: PassArguments(
                                              widget.snap['postId'], index));
                                    },
                                    child: Image.network(
                                      widget.snap['postUrl'][index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  staggeredTileBuilder: (index) =>
                                      StaggeredTile.count(
                                    (index % 2 == 0) ? 1 : 1,
                                    (index % 2 == 0) ? 1 : 2,
                                  ),
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2,
                                )
                              : StaggeredGridView.countBuilder(
                                  physics: PageScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  itemCount: widget.snap['postUrl'].length,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          SelectedImageScreen.routeName,
                                          arguments: PassArguments(
                                              widget.snap['postId'], index));
                                    },
                                    child: Image.network(
                                      widget.snap['postUrl'][index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  staggeredTileBuilder: (index) =>
                                      StaggeredTile.count(
                                    (index % 1 == 0) ? 1 : 1,
                                    (index % 1 == 0) ? 1 : 2,
                                  ),
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2,
                                ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CommunityIcon(icon: FontAwesomeIcons.comment, count: 0),
                      _CommunityIcon(
                          icon: FontAwesomeIcons.arrowRightArrowLeft, count: 0),
                      _CommunityIcon(icon: FontAwesomeIcons.heart, count: 0),
                      const _CommunityIcon(
                        icon: FontAwesomeIcons.share,
                      ),
                      const SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        const Divider(),
      ]),
    );
  }
}

class PassArguments {
  final String postId;
  final int index;

  PassArguments(this.postId, this.index);
}

class _CommunityIcon extends StatelessWidget {
  final IconData icon;
  final int? count;
  //final Function onTap;
  const _CommunityIcon({super.key, required this.icon, this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            Icon(
              icon,
              size: 12,
              color: Colors.grey[700],
            ),
            const SizedBox(
              width: 3,
            ),
            if (count != null)
              Text(
                count.toString(),
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
          ],
        ),
      ),
    );
  }
}
