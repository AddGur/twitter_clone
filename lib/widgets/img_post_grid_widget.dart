import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:twitter_clone/widgets/post_widget.dart';

import '../screens/logged_screens/selected_image_screen.dart';

class ImgPostGridWidget extends StatefulWidget {
  final int length;
  final String postId;
  final List<dynamic> postUrl;
  const ImgPostGridWidget(
      {super.key,
      required this.length,
      required this.postId,
      required this.postUrl});

  @override
  State<ImgPostGridWidget> createState() => _ImgPostGridWidgetState();
}

class _ImgPostGridWidgetState extends State<ImgPostGridWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: widget.length == 1
          ? GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(SelectedImageScreen.routeName,
                    arguments: PassArguments(widget.postId, 0));
              },
              child: Image.network(
                widget.postUrl[0],
              ),
            )
          : widget.length == 3
              ? StaggeredGridView.countBuilder(
                  scrollDirection: Axis.vertical,
                  physics: const PageScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  itemCount: widget.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          SelectedImageScreen.routeName,
                          arguments: PassArguments(widget.postId, index));
                    },
                    child: Image.network(
                      widget.postUrl[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                  staggeredTileBuilder: (index) => StaggeredTile.count(
                    (index % 2 == 0) ? 1 : 1,
                    (index % 2 == 0) ? 1 : 2,
                  ),
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                )
              : StaggeredGridView.countBuilder(
                  physics: const PageScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  itemCount: widget.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          SelectedImageScreen.routeName,
                          arguments: PassArguments(widget.postId, index));
                    },
                    child: Image.network(
                      widget.postUrl[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                  staggeredTileBuilder: (index) => StaggeredTile.count(
                    (index % 1 == 0) ? 1 : 1,
                    (index % 1 == 0) ? 1 : 2,
                  ),
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                ),
    );
  }
}
