import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../utilis/dummy_posts.dart';

class SelectedImageScreen extends StatefulWidget {
  static const routeName = '/selectedImageScreen';
  const SelectedImageScreen({super.key});

  @override
  State<SelectedImageScreen> createState() => _SelectedImageScreenState();
}

class _SelectedImageScreenState extends State<SelectedImageScreen> {
  @override
  Widget build(BuildContext context) {
    final postId = ModalRoute.of(context)!.settings.arguments as String;
    final postData =
        Provider.of<Posts>(context, listen: false).findById(postId);

    Color mainColor = Colors.white;

    Future<PaletteGenerator> getImagePalette() async {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
              Image.network(postData.postImageUrl!).image);
      return paletteGenerator;
    }

    return FutureBuilder<PaletteGenerator>(
        future: getImagePalette(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else {
                mainColor = snapshot.data!.lightVibrantColor!.color;
                return Scaffold(
                  backgroundColor: mainColor,
                  body: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                              tag: 'post-${postData.postImageUrl}',
                              child: Image.network(postData.postImageUrl!)),
                        ]),
                  ),
                );
              }
          }
        });
  }
}
