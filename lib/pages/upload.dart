import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  PickedFile? file;
  handleTakePhoto() async {
    Navigator.pop(context);
    PickedFile? file = await ImagePicker.platform.pickImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = file ;
    });
  }

  handleFromGallery() async {
    Navigator.pop(context);
    PickedFile? file = await ImagePicker.platform.pickImage(
        source: ImageSource.gallery, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text('Create POst'),
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

  buildUploadForm() {
    return Text('file is loaded');
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? buildSPlashScreen() : buildUploadForm();
  }
}
