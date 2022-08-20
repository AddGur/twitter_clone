import 'package:file/file.dart';
import 'package:flutter/cupertino.dart';

class PostData {
  final String postId;
  final String name;
  final String userImageUrl;
  final String? postImageUrl;
  final List<File>? storedImage;
  final String alias;
  final DateTime date;
  final String description;
  final int commentsCounter;
  final int shareCounter;
  final int likesCounter;

  PostData({
    required this.postId,
    required this.name,
    required this.userImageUrl,
    this.postImageUrl,
    this.storedImage,
    required this.alias,
    required this.date,
    required this.description,
    required this.commentsCounter,
    required this.shareCounter,
    required this.likesCounter,
  });
}

class Posts with ChangeNotifier {
  final List<PostData> _dummyPosts = [
    PostData(
      postId:
          "1",
      name: 'John Doe',
      userImageUrl: 'https://pic.onlinewebfonts.com/svg/img_74993.png',
      postImageUrl:
          'https://www.fao.org/images/devforestslibraries/default-album/forests.jpg?sfvrsn=2dd96b96_11',
      alias: '@johny',
      date: DateTime.now(),
      description:
          'A forest is a complex ecological system in which trees are the dominant life-form. ',
      commentsCounter: 0,
      shareCounter: 0,
      likesCounter: 0,
    ),
  ];

  List<PostData> get dummyPost {
    return [..._dummyPosts];
  }

  PostData findById(String id) {
    return _dummyPosts.firstWhere((prod) => prod.postId == id);
  }
}
