import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familyshare/widgets/header.dart';
import 'package:familyshare/widgets/progress.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final CollectionReference db = FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream:db.snapshots (),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          final  List<Text> children =
              snapshot.data!.docs.map((doc) => Text(doc['username'])).toList();
          return Container(child: ListView(children: children));
        },
      ),
    );
  }
}
