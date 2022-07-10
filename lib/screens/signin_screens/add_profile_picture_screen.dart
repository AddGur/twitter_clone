import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:twitter_clone/screens/signin_screens/add_description_screen.dart';
import 'package:twitter_clone/utilis/user.dart';

import '../../resources/storage_methods.dart';
import '../../widgets/twitter_button.dart';
import '../main_screen.dart';

import 'dart:developer' as devtools show log;

class AddProfilePictureScreen extends StatefulWidget {
  static const routeName = '/pickpic';
  const AddProfilePictureScreen({super.key});

  @override
  State<AddProfilePictureScreen> createState() =>
      _AddProfilePictureScreenState();
}

class _AddProfilePictureScreenState extends State<AddProfilePictureScreen> {
  bool _isImagePicked = false;

  Uint8List? _file;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<NewUser>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Image.asset('assets/images/twitter_logo.png',
              height: 20, fit: BoxFit.cover),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  'Pick a profile picture',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Have a favourite selfie? Upload it now.',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _selectImage(context),
                    child: _isImagePicked
                        ? CircleAvatar(
                            radius: 70,
                            backgroundImage: MemoryImage(_file!),
                          )
                        : DottedBorder(
                            color: Colors.blue,
                            dashPattern: [10],
                            borderType: BorderType.RRect,
                            radius: Radius.circular(15),
                            strokeCap: StrokeCap.round,
                            strokeWidth: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.photo_camera,
                                    color: Colors.blue,
                                    size: 80,
                                  ),
                                  Text(
                                    'Upload',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              Expanded(flex: 10, child: Container()),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TwitterButton(
                      onPressed: () {},
                      buttonsText: 'Skip for now',
                      textColor: Colors.black,
                      backgroundColor: Colors.white),
                  TwitterButton(
                      onPressed: () async {
                        Navigator.pushNamed(
                            context, AddDescriptionScreen.routeName);
                        userData.photoUrl = await StroageMethods()
                            .uploadImageToStorage('profilePics', _file!, false);
                        devtools.log(userData.photoUrl);
                      },
                      buttonsText: 'Next',
                      textColor: Colors.black,
                      backgroundColor: Colors.white),
                ],
              )
            ],
          ),
        ));
  }

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      devtools.log(_file.name);
      devtools.log('a');
      return await _file.readAsBytes();
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                    _isImagePicked = true;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                    _isImagePicked = true;
                  });
                },
              ),
            ],
          );
        });
  }
}
