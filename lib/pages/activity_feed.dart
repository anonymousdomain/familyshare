import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familyshare/pages/home.dart';
import 'package:familyshare/widgets/header.dart';
import 'package:familyshare/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  getActivityFeed() async {
    QuerySnapshot snapshot = await activityDOc
        .doc(currentUser?.id)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .limit(20)
        .get();
    List<ActivityFeedItem> feedItems = [];
    snapshot.docs.map((doc) {
      feedItems.add(ActivityFeedItem.fromDocument(doc));
    }).toList();
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, appTitle: 'Activity Feed'),
      body: FutureBuilder(
        future: getActivityFeed(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          return ListView(
            children: snapshot.data as List<ActivityFeedItem>,
          );
        },
      ),
    );
  }
}

Widget? mediaPreview;
String? activityItemText;

class ActivityFeedItem extends StatelessWidget {
  final String username;
  final String userId;
  final String type;
  final String mediaUrl;
  final String postId;
  final String userProfile;
  final String comment;
  final Timestamp timestamp;
  const ActivityFeedItem(
      {required this.username,
      required this.userId,
      required this.type,
      required this.mediaUrl,
      required this.postId,
      required this.userProfile,
      required this.comment,
      required this.timestamp});
  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
        username: doc.get('username'),
        userId: doc.get('userId'),
        type: doc.get('type'),
        mediaUrl: doc.get('mediaUrl'),
        postId: doc.get('postId'),
        userProfile: doc.get('userProfile'),
        comment: doc.get('comment'),
        timestamp: doc.get('timestamp'));
  }
  checkMediaPreview() {
    if (type == 'like' || type == 'comment') {
      mediaPreview = GestureDetector(
        onTap: () {},
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(mediaUrl),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = Text('');
    }
    if (type == 'like') {
      activityItemText = ' liked Your Post';
    } else if (type == 'follow') {
      activityItemText = ' is following you';
    } else if (type == 'comment') {
      activityItemText = ' replied $comment';
    } else {
      activityItemText = ' Error unknown type $type';
    }
  }

  @override
  Widget build(BuildContext context) {
    checkMediaPreview();
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          title: GestureDetector(
            onTap: () {},
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  style: TextStyle(fontSize: 14.0, color: Colors.black),
                  children: [
                    TextSpan(
                        text: username,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: '$activityItemText',
                    ),
                  ]),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userProfile),
          ),
          subtitle: Text(
            timeago.format(timestamp.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}
