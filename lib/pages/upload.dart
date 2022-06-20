
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final ImagePicker _picker = ImagePicker();
  XFile? file;
  photoWithCamera() async {
    Navigator.pop(context);
    XFile? file = await _picker.pickImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = file;
    });
  }

  takePhotoFromGallary() async {
    Navigator.pop(context);
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text('Create post',style:TextStyle(fontSize: 25.0,fontWeight: FontWeight.w300),),
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

  @override
  Widget build(BuildContext context) {
    return file == null ? buildSplashScreen() : Text('loaded');
  }
}
