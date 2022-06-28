import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familyshare/pages/home.dart';
import 'package:familyshare/widgets/header.dart';
import 'package:familyshare/widgets/post.dart';
import 'package:familyshare/widgets/progress.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
  final String userId;
  final String postId;
  const PostScreen({required this.userId, required this.postId});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: posts.doc(userId).collection('userPosts').doc(postId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        Post post = Post.fromDocument(snapshot.data!);
        return Center(
          child: Scaffold(
            appBar: header(context, appTitle: post.desc),
            body: ListView(
              children: [
                Container(
                  child: post,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
