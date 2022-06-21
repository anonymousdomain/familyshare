import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? id;
  final String? username;
  final String? email;
  final String? photoUrl;
  final String? displayName;
  final String? bio;

  User({
   required this.id,
   required  this.username,
   required  this.email,
   required  this.photoUrl,
   required   this.displayName,
    required this.bio,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.get('id'),
      username: doc.get('username'),
      email: doc.get('email'),
      photoUrl: doc.get('photoUrl'),
      displayName: doc.get('displayName'),
      bio: doc.get('bio'),
    );
  }
}
