// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as devtools show log;
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:twitter_clone/resources/firestore_methods.dart';
import '../../providers/user_provider.dart';
import '../../utilis/user.dart' as model;

class NewPostScreen extends StatefulWidget {
  static const routeName = '/newPostScreen';
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  late TextEditingController _tweetController;

  final ImagePicker _picker = ImagePicker();
  final List<File> _imageFileList = [];

  @override
  void initState() {
    _tweetController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _tweetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final IsCommentEmpty isCommentEmpty = Provider.of<IsCommentEmpty>(context);
    final model.User _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: Navigator.of(context).pop,
          ),
          actions: [
            isCommentEmpty.commentIsEmpty
                ? Container()
                : TextButton(onPressed: () {}, child: const Text('Draft')),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () {
                postTweet(
                    _user.uid, _user.username, _user.photoUrl!, _user.alias);
              },
              child: const Text('Tweet'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: isCommentEmpty.commentIsEmpty
                      ? Theme.of(context).primaryColor
                      : Colors.blue[100],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(_user.photoUrl!),
                    backgroundColor: Colors.red,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: _tweetController,
                        onChanged: (value) {
                          if (_tweetController.text.isNotEmpty) {
                            context.read<IsCommentEmpty>().setTrue();
                          } else {
                            context.read<IsCommentEmpty>().setFalse();
                          }
                        },
                        autofocus: true,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: _imageFileList.isEmpty
                              ? 'What\'s happening?'
                              : 'Add a comment...',
                          border: InputBorder.none,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: _imageFileList.isEmpty
                              ? null
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.file(
                                              File(_imageFileList[index].path),
                                              fit: BoxFit.cover,
                                              height: _imageFileList.length > 1
                                                  ? 200
                                                  : 300,
                                            ),
                                          ),
                                          Positioned(
                                              right: 10,
                                              top: 10,
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors.black54,
                                                child: IconButton(
                                                  onPressed: () =>
                                                      removeImage(index),
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors.white),
                                                ),
                                              )),
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: _imageFileList.length,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            Container(
              child: _imageFileList.isEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            onTap: takePicture,
                            child: const ImagePickerWidget(
                              iconImage: Icon(
                                Icons.photo_camera,
                                color: Colors.blue,
                              ),
                            )),
                        GestureDetector(
                            onTap: selectImages,
                            child: const ImagePickerWidget(
                              iconImage: Icon(
                                Icons.photo_camera_back_outlined,
                                color: Colors.blue,
                              ),
                            )),
                      ],
                    )
                  : null,
            ),
            const Divider(),
            GestureDetector(
                onTap: () {},
                child: Row(children: const [
                  Icon(
                    Icons.public,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Everyone can reply',
                    style: TextStyle(color: Colors.blue),
                  ),
                ])),
            const Divider(),
            Row(
              children: [
                IconButton(
                    onPressed: selectImages,
                    icon: const Icon(
                      Icons.image_outlined,
                      color: Colors.blue,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.gif_box_outlined,
                      color: _imageFileList.isEmpty
                          ? Colors.blue
                          : Colors.blue[200],
                    )),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.graphic_eq_outlined,
                      color: _imageFileList.isEmpty
                          ? Colors.blue
                          : Colors.blue[200],
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.place_outlined,
                      color: Colors.blue,
                    )),
                const Expanded(child: SizedBox()),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.circle_outlined,
                      color: Colors.grey[300],
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add_circle_outlined,
                      color: Colors.blue,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  void selectImages() async {
    var selectedImage =
        await _picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (selectedImage == null) {
      return;
    }
    setState(() {
      var img = File(selectedImage.path);
      _imageFileList.add(img);
    });

    devtools.log(_imageFileList.length.toString());
  }

  void takePicture() async {
    var takenPicture =
        await _picker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (takenPicture == null) {
      return;
    }
    setState(() {
      var img = File(takenPicture.path);
      _imageFileList.add(img);
    });
  }

  void postTweet(
      String uid, String username, String profImage, String alias) async {
    await FirestoreMethods().uploadPost(
        _tweetController.text, _imageFileList, uid, username, alias, profImage);
    Navigator.pop(context);
  }

  void removeImage(int number) {
    setState(() {
      _imageFileList.removeAt(number);
    });
  }
}

class ImagePickerWidget extends StatelessWidget {
  final Icon iconImage;
  const ImagePickerWidget({super.key, required this.iconImage});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.grey)),
        child: iconImage,
      ),
    );
  }
}

class IsCommentEmpty with ChangeNotifier {
  bool _commentIsEmpty = false;
  bool get commentIsEmpty => _commentIsEmpty;

  void setFalse() {
    _commentIsEmpty = false;
    notifyListeners();
  }

  void setTrue() {
    _commentIsEmpty = true;
    notifyListeners();
  }
}
