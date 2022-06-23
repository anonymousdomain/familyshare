// ignore_for_file: unused_import

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familyshare/models/user.dart';
import 'package:familyshare/pages/home.dart';
import 'package:familyshare/widgets/progress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class Upload extends StatefulWidget {
  final User? currentUser;
  const Upload(this.currentUser);
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final ImagePicker _picker = ImagePicker();
  TextEditingController captionController = TextEditingController();
  File? file;
  bool isUploading = false;
  String postId = Uuid().v4();
  Timestamp timestamp = Timestamp.now();
  photoWithCamera() async {
    Navigator.pop(context);
    XFile? file = await _picker.pickImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = File(file!.path);
    });
  }

  takePhotoFromGallary() async {
    Navigator.pop(context);
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = File(file!.path);
    });
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  Future<String> uploadImage(imagefile) async {
    UploadTask uploadTask =
        storage.child('post_$postId.jpg').putFile(imagefile);

    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  createPosts({mediaUrl, desc}) {
    posts.doc(widget.currentUser?.id).collection('userPosts').doc(postId).set({
      'postId': postId,
      'ownerId': widget.currentUser?.id,
      'username': widget.currentUser?.username,
      'mediaUrl': mediaUrl,
      'desc': desc,
      'timestamp': timestamp,
      'likes': {},
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    // await compressImage();
    String mediaUrl = await uploadImage(file);
    createPosts(mediaUrl: mediaUrl, desc: captionController.text);
    captionController.clear;
    setState(() {
      file = null;
      isUploading = false;
      postId = Uuid().v4();
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Create post',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
            ),
            titlePadding: EdgeInsets.all(8),
            children: [
              SimpleDialogOption(
                onPressed: photoWithCamera,
                child: Text('take photo with camera'),
              ),
              SimpleDialogOption(
                onPressed: takePhotoFromGallary,
                child: Text('take photo from gallary'),
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  Container buildSplashScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      color: Theme.of(context).secondaryHeaderColor.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/upload.svg',
            height: orientation == Orientation.portrait ? 260.0 : 200,
            // fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: () => selectImage(context),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(8.0)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.deepOrange),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.orange),
                  ),
                ),
              ),
              child: Text(
                'Upload Image',
                style: TextStyle(color: Colors.white, fontSize: 25.0),
              ),
            ),
          ),
        ],
      ),
    );
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
          'Caption a post',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: Text(
              'Post',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          isUploading ? linearProgress() : Text(''),
          SizedBox(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(File(file!.path)),
                          fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                  widget.currentUser?.photoUrl ?? ''),
            ),
            title: SizedBox(
              width: 250.0,
              child: TextField(
                controller: captionController,
                decoration: InputDecoration(
                    hintText: 'write a Caption', border: InputBorder.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? buildSplashScreen() : buildUploadForm();
  }
}
