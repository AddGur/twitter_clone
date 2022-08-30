// ignore_for_file: unused_import, no_leading_underscores_for_local_identifiers

import 'dart:ui';

import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:twitter_clone/resources/firestore_methods.dart';
import 'package:twitter_clone/widgets/post_widget.dart';
import 'package:twitter_clone/widgets/social_bar_widget.dart';
import 'dart:developer' as devtools show log;

import '../../widgets/comment_widget.dart';

class SelectedImageScreen extends StatefulWidget {
  static const routeName = '/selectedImageScreen';
  const SelectedImageScreen({super.key});

  @override
  State<SelectedImageScreen> createState() => _SelectedImageScreenState();
}

class _SelectedImageScreenState extends State<SelectedImageScreen> {
  bool isBarHidden = false;
  List<String> imgUrl = [];
  List<PaletteColor> colors = [];

  @override
  Widget build(BuildContext context) {
    final imgData = ModalRoute.of(context)!.settings.arguments as PassArguments;

    PageController controller = PageController(initialPage: imgData.index);

    Future<List<PaletteColor>> _updatePalettes() async {
      await FirestoreMethods().getImgUrl(imgUrl, imgData.snapshot['postId']);
      for (String image in imgUrl) {
        final PaletteGenerator generator =
            await PaletteGenerator.fromImageProvider(
          NetworkImage(image),
        );
        colors.add(generator.lightMutedColor ?? PaletteColor(Colors.blue, 2));
      }
      return colors;
    }

    Future hideBar() async {
      isBarHidden
          ? await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: SystemUiOverlay.values)
          : await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    }

    return FutureBuilder(
      future: _updatePalettes(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return PageView.builder(
                controller: controller,
                itemCount: imgUrl.length,
                itemBuilder: (context, index) {
                  return Scaffold(
                    appBar: AppBar(
                      systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor: colors.isNotEmpty
                            ? colors[index].color
                            : Colors.white,
                      ),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      actions: [
                        PopupMenuButton(
                            itemBuilder: (context) =>
                                [const PopupMenuItem(child: Text('Save'))])
                      ],
                      backgroundColor: colors.isNotEmpty
                          ? colors[index].color
                          : Colors.white,
                      elevation: 0,
                    ),
                    backgroundColor:
                        colors.isNotEmpty ? colors[index].color : Colors.white,
                    body: SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height -
                            AppBar().preferredSize.height -
                            50,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            GestureDetector(
                              onTap: () {
                                hideBar();
                                isBarHidden = !isBarHidden;
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height / 2,
                                decoration: BoxDecoration(
                                    color: colors.isNotEmpty
                                        ? colors[index].color
                                        : Colors.white,
                                    image: DecorationImage(
                                        image: NetworkImage(imgUrl[index]),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: SocialBarWidget(
                                snap: imgData.snapshot,
                                color: Colors.white,
                                isPostScreen: false,
                                isTweetScreen: false,
                              ),
                            ),
                            CommentWidget(postId: imgData.snapshot['postId']),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
        }
      },
    );
  }
}
