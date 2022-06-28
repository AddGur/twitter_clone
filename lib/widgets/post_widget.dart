import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../utilis/dummy_posts.dart';

class PostWidget extends StatelessWidget {
  final PostData postData;
  const PostWidget({
    super.key,
    required this.postData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(postData.userImageUrl),
            ),
            SizedBox(
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
                            postData.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            postData.alias,
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
                      Icon(
                        Icons.list,
                        size: 16,
                      ),
                    ],
                  ),
                  Text(postData.description),
                  if (postData.postImageUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Hero(
                          tag: 'post-${postData.postImageUrl}',
                          child: Image.network(
                            postData.postImageUrl!,
                          ),
                        ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommunityIcon(
                          icon: FontAwesomeIcons.comment,
                          count: postData.commentsCounter),
                      CommunityIcon(
                          icon: FontAwesomeIcons.arrowRightArrowLeft,
                          count: postData.shareCounter),
                      CommunityIcon(
                          icon: FontAwesomeIcons.heart,
                          count: postData.shareCounter),
                      CommunityIcon(
                        icon: FontAwesomeIcons.share,
                      ),
                      SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        Divider(),
      ]),
    );
  }
}

class CommunityIcon extends StatelessWidget {
  final IconData icon;
  final int? count;
  //final Function onTap;
  const CommunityIcon({super.key, required this.icon, this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {},
        child: Container(
            child: Row(
          children: [
            Icon(
              icon,
              size: 12,
              color: Colors.grey[700],
            ),
            SizedBox(
              width: 3,
            ),
            if (count != null)
              Text(
                count.toString(),
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
          ],
        )),
      ),
    );
  }
}
