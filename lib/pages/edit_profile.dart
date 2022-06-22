import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familyshare/models/user.dart';
import 'package:familyshare/pages/home.dart';
import 'package:familyshare/widgets/progress.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final String? currentUserId;
  const EditProfile({this.currentUserId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User? user;
  bool isLoading = false;
  bool _isNameValid = true;
  bool _isBioValid = true;
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersDoc.doc(widget.currentUserId).get();
    user = User.fromDocument(doc);
    displayNameController.text = user?.displayName ?? '';
    bioController.text = user?.bio ?? '';
    setState(() {
      isLoading = false;
    });
  }

  logOut() async {
    await googleSignIn.signOut();
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  updateProfile() {
    setState(() {
      displayNameController.text.trim().length < 5 ||
              displayNameController.text.isEmpty
          ? _isNameValid = false
          : _isNameValid = true;
      bioController.text.trim().length > 100
          ? _isBioValid = false
          : _isBioValid = true;
    });
    if (_isNameValid && _isBioValid) {
      usersDoc.doc(widget.currentUserId).update({
        'displayName': displayNameController.text,
        'bio': bioController.text
      });
    }
    SnackBar snackBar = SnackBar(
      content: Text('Your profile is updated'),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            'Display Name',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
              hintText: 'update Display name',
              errorText: _isNameValid ? null : 'display name is to short'),
        ),
      ],
    );
  }

  buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            'Bio',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
              hintText: 'update Your Bio',
              errorText: _isBioValid ? null : 'your bio is to long'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.done,
              color: Colors.green,
              size: 30.0,
            ),
          ),
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage:
                            CachedNetworkImageProvider(user?.photoUrl ?? ''),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          buildDisplayNameField(),
                          buildBioField(),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: updateProfile,
                      child: Text(
                        'update Profile',
                        style: TextStyle(
                            backgroundColor: Theme.of(context).primaryColor,
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextButton.icon(
                        onPressed: logOut,
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                        label: Text(
                          'logout',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}
