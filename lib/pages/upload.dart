import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familyshare/models/user.dart';
import 'package:familyshare/pages/timeline.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../widgets/progress.dart';

class Upload extends StatefulWidget {
    User? currentUser;
   Upload({required this.currentUser});
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
   PickedFile? file;
  bool isUploading = false;
  String postId = Uuid().v4();
  Timestamp timestamp = Timestamp.now();
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  handleTakePhoto() async {
    Navigator.pop(context);
    // ignore: invalid_use_of_visible_for_testing_member
    PickedFile? file = await ImagePicker.platform.pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );

    setState(() {
      this.file = file!;
    });
  }

  handleFromGallery() async {
    Navigator.pop(context);
    PickedFile? file = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = file!;
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
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.deepOrange),
                  ),
                ),
              ),
              onPressed: () => selectImage(context),
              child: Text(
                'Upload Image',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  clearImage() {
    setState(() {
      file = null as PickedFile;
    });
  }

  // compressImage() async {
  //   final tempDir = await getTemporaryDirectory();
  //   final path = tempDir.path;
  //   Im.Image? imageFile = Im.decodeImage(await file!.readAsBytes());
  //   final compressedImageFile = File('$path/img_$postId.jpg')
  //     ..writeAsBytesSync(Im.encodeJpg(imageFile!, quality: 85));
  //   setState(() {
  //     file = compressedImageFile as PickedFile?;
  //   });
  // }

  uploadImage(imagefile) async {
  final appDocDir = await getApplicationDocumentsDirectory();
final filePath = "${appDocDir.absolute}/path/to/mountains.jpg";
final file = File(filePath);

// Create the file metadata
final metadata = SettableMetadata(contentType: "image/jpeg");

// Create a reference to the Firebase Storage bucket
final storageRef = FirebaseStorage.instance.ref();

// Upload file and metadata to the path 'images/mountains.jpg'
final uploadTask = storageRef
    .child("images/path/to/mountains.jpg")
    .putFile(file, metadata);

// Listen for state changes, errors, and completion of the upload.
uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
  switch (taskSnapshot.state) {
    case TaskState.running:
      final progress =
          100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
      print("Upload is $progress% complete.");
      break;
    case TaskState.paused:
      print("Upload is paused.");
      break;
    case TaskState.canceled:
      print("Upload was canceled");
      break;
    case TaskState.error:
      // Handle unsuccessful uploads
      break;
    case TaskState.success:
      // Handle successful uploads on complete
      // ...
      break;
  }
});
  }

  createPosts(
      {required String mediaUrl,
      required String location,
      required String caption}) {
    posts.doc(widget.currentUser!.id).collection('userPosts').doc(postId).set({
      'postId': postId,
      'ownerId': widget.currentUser!.id,
      'username': widget.currentUser!.username,
      'mediaUrl': mediaUrl,
      'caption': caption,
      'location': location,
      'likes': {},
      'timestamp': timestamp,
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    // await compressImage();
     await uploadImage(file);
    createPosts(
        mediaUrl: '',
        location: locationController.text,
        caption: captionController.text);
    captionController.clear();
    locationController.clear();
    setState(() {
      file = null as PickedFile;
      isUploading = false;
      postId = Uuid().v4();
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
            onPressed: isUploading ? null : () => handleSubmit(),
            child: Text(
              'Post',
              style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          isUploading ? linearProgress() : Text(''),
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
                    image: FileImage(
                      File(file!.path),
                    ),
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
                controller: captionController,
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
                controller: locationController,
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
