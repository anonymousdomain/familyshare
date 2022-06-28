import 'package:familyshare/pages/post_screen.dart';
import 'package:familyshare/widgets/custom_image.dart';
import 'package:familyshare/widgets/post.dart';
import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {
  final Post post;
  const PostTile(this.post);
    showPost(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => PostScreen(userId: post.ownerId, postId:post.postId)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:()=>showPost(context),
      child: cachedNetworkImage(post.mediaUrl),
    );
  }
}
