import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familyshare/models/user.dart';
import 'package:familyshare/pages/home.dart';
import 'package:familyshare/widgets/progress.dart';
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
    likes.values.forEach((val) {
      if (val == false) {
        count -= 1;
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
        mediaUrl: mediaUrl,
        likes: likes,
        likeCount: getLikeCount(likes),
      );
}

class _PostState extends State<Post> {
  final String? currentUserId = currentUser?.id;
  final String? postId;
  final String? ownerId;
  final String? username;
  final String? desc;
  final String? mediaUrl;
  Map? likes;
  int? likeCount;
  late bool isLiked;
  _PostState(
      {this.postId,
      this.ownerId,
      this.username,
      this.desc,
      this.mediaUrl,
      this.likes,
      this.likeCount});

  handleLikePost() {
    bool liked = likes?[currentUserId] == true;

    if (liked) {
      posts.doc(ownerId).collection('userPosts').doc(postId).update(
        {'likes.$currentUserId': false},
      );
      setState(() {
        likeCount = (likeCount! - 1);
        isLiked = false;
        likes?[currentUserId] = false;
      });
    } else if (!liked) {
      posts.doc(ownerId).collection('userPosts').doc(postId).update(
        {'likes.$currentUserId': true},
      );
      setState(() {
        likeCount = (likeCount! + 1);
        isLiked = true;
        likes?[currentUserId] = true;
      });
    }
  }

  buildPostHeader() {
    return FutureBuilder<DocumentSnapshot>(
      future: usersDoc.doc(widget.ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return circularProgress();
        User user = User.fromDocument(snapshot.data!);
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: CachedNetworkImageProvider(user.photoUrl!),
          ),
          title: GestureDetector(
            onTap: () {},
            child: Text(
              user.username.toString(),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: Text(user.bio!),
          trailing: IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        );
      },
    );
  }

  buildPostImage() {
    return GestureDetector(
      onDoubleTap: handleLikePost,
      child: Stack(
        alignment: Alignment.center,
        children: [CachedNetworkImage(imageUrl: mediaUrl!)],
      ),
    );
  }

  buildPostFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40.0, left: 20.0),
            ),
            //likes
            GestureDetector(
              onTap: handleLikePost,
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 28.0,
                color: Colors.pink,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
            ),
            //comments
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.chat,
                size: 28.0,
                color: Colors.blue,
              ),
            )
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                '$likeCount likes',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                '$username ',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: Text(desc!))
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likes?[currentUserId] == true);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildPostHeader(),
        buildPostImage(),
        buildPostFooter(),
      ],
    );
  }
}
