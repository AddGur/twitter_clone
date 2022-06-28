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
  List<PostData> _dummyPosts = [
    PostData(
      postId: '1',
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
    PostData(
      postId: '2',
      name: 'Jane Doe',
      userImageUrl:
          'https://icons-for-free.com/iconfiles/png/512/user+icon-1320190636314922883.png',
      postImageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/080103_hakkai_fuji.jpg/1280px-080103_hakkai_fuji.jpg',
      alias: '@jane',
      date: DateTime.now(),
      description:
          'A mountain is an elevated portion of the Earth\'s crust, generally with steep sides that show significant exposed bedrock.',
      commentsCounter: 3,
      shareCounter: 2,
      likesCounter: 14,
    ),
    PostData(
      postId: '3',
      name: 'Jane Doe',
      userImageUrl:
          'https://icons-for-free.com/iconfiles/png/512/user+icon-1320190636314922883.png',
      alias: '@jane',
      date: DateTime.now(),
      description: 'Post without image',
      commentsCounter: 3,
      shareCounter: 2,
      likesCounter: 14,
    ),
    PostData(
      postId: '4',
      name: 'John Doe',
      userImageUrl: 'https://pic.onlinewebfonts.com/svg/img_74993.png',
      postImageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/Paracas_National_Reserve%2C_Ica%2C_Peru-3April2011.jpg/1280px-Paracas_National_Reserve%2C_Ica%2C_Peru-3April2011.jpg',
      alias: '@johny',
      date: DateTime.now(),
      description:
          'The sea, connected as the world ocean or simply the ocean, is the body of salty water that covers approximately 71 percent of the Earth\'s surface. ',
      commentsCounter: 5,
      shareCounter: 3,
      likesCounter: 8,
    ),
  ];

  List<PostData> get dummyPost {
    return [..._dummyPosts];
  }

  PostData findById(String id) {
    return _dummyPosts.firstWhere((prod) => prod.postId == id);
  }
}
