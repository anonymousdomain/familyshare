import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familyshare/pages/home.dart';
import 'package:familyshare/widgets/header.dart';
import 'package:familyshare/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class Comments extends StatefulWidget {
  final String? postId;
  final String? postOwnerId;
  final String? postMediaUrl;

  const Comments({this.postId, this.postOwnerId, this.postMediaUrl});
  @override
  CommentsState createState() => CommentsState(
      postId: postId, postOwnerId: postOwnerId, postMediaUrl: postMediaUrl);
}

class CommentsState extends State<Comments> {
  Timestamp timestamp = Timestamp.now();
  TextEditingController commentController = TextEditingController();
  final String? postId;
  final String? postOwnerId;
  final String? postMediaUrl;

  CommentsState({this.postId, this.postOwnerId, this.postMediaUrl});

  addComment() {
    commentsDoc.doc(postId).collection('comments').add({
      'username': currentUser?.username,
      'comment': commentController.text,
      'timestamp': timestamp,
      'avatarUrl': currentUser?.photoUrl,
      'userId': currentUser?.id,
    });
    commentController.clear();
  }

  buildComments() {
    return StreamBuilder<QuerySnapshot>(
      stream: commentsDoc
          .doc(postId)
          .collection('comments')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<Comment> comments = [];
        snapshot.data?.docs.map((doc) {
          comments.add(Comment.fromDocument(doc));
        }).toList();
        return ListView(
          children: comments,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, appTitle: 'comments'),
      body: Column(
        children: [
          Expanded(
            child: buildComments(),
          ),
          Divider(
            height: 1.1,
          ),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(labelText: 'write a comment...'),
            ),
            trailing: OutlinedButton(
              onPressed: addComment,
              style: OutlinedButton.styleFrom(side: BorderSide.none),
              child: Text('Post'),
            ),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String? username;
  final String? userId;
  final String? avatarUrl;
  final String? comment;
  final Timestamp? timestamp;
  const Comment(
      {this.username,
      this.userId,
      this.avatarUrl,
      this.comment,
      this.timestamp});
  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      username: doc.get('username'),
      userId: doc.get('userId'),
      avatarUrl: doc.get('avatarUrl'),
      comment: doc.get('comment'),
      timestamp: doc.get('timestamp'),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(comment!),
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: CachedNetworkImageProvider(avatarUrl!),
          ),
          subtitle: Text(timeago.format(timestamp!.toDate())),
        ),
        Divider()
      ],
    );
  }
}
