import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  final String? postId;
  final String? ownerId;
  final String? username;
  final String? desc;
  final String? mediaUrl;
  final dynamic likes;
  const Post(
      {this.postId,
      this.ownerId,
      this.username,
      this.desc,
      this.mediaUrl,
      this.likes});
  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc.get('postId'),
      ownerId: doc.get('ownerId'),
      username: doc.get('username'),
      desc: doc.get('desc'),
      mediaUrl: doc.get('mediaUrl'),
    );
  }
  int getLikeCount(likes) {
    // if no likes, return 0
    if (likes == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _PostState createState() => _PostState(
    postId: postId,
    ownerId: ownerId,
    username: username,
    desc: desc,
    mediaUrl:mediaUrl,
    likes: likes,
    likeCount: getLikeCount(likes),
  );
}

class _PostState extends State<Post> {
  final String? postId;
  final String? ownerId;
  final String? username;
  final String? desc;
  final String? mediaUrl;
  Map? likes;
  int? likeCount;
  _PostState(
      {this.postId,
      this.ownerId,
      this.username,
      this.desc,
      this.mediaUrl,
      this.likes,
      this.likeCount});
  @override
  Widget build(BuildContext context) {
    return Text('Post');
  }
}
