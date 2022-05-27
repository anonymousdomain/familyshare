import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:familyshare/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class Upload extends StatefulWidget {
  final User? currentUser;
  Upload({required this.currentUser});
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  PickedFile? file;

  handleTakePhoto() async {
    Navigator.pop(context);
    PickedFile? file = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = file;
    });
  }

  handleFromGallery() async {
    Navigator.pop(context);
    PickedFile? file = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text('Create Post'),
            children: [
              SimpleDialogOption(
                onPressed: handleTakePhoto,
                child: Text('take photo from camera'),
              ),
              SimpleDialogOption(
                onPressed: handleFromGallery,
                child: Text('Upload photo from gallery'),
              ),
              SimpleDialogOption(
                child: Text('cancel'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  Container buildSPlashScreen() {
    return Container(
      color: Theme.of(context).secondaryHeaderColor.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/upload.svg',
            height: 260.0,
          ),
          Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Colors.deepOrange)))),
                  onPressed: () => selectImage(context),
                  child: Text(
                    'Upload Image',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  )))
        ],
      ),
    );
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
          onPressed: clearImage,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'caption a post',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => print('post'),
            child: Text(
              'Post',
              style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                    decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(File(file!.path)),
                  ),
                )),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(widget.currentUser!.photoUrl),
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'write a caption...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.pin_drop,
              color: Colors.orange,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'enter a location...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            width: 200.0,
             height: 100.0,
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              onPressed: () => print('get users location'),
              icon: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
              label: Text(
                'Use a current Location',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? buildSPlashScreen() : buildUploadForm();
  }
}
