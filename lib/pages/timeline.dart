import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familyshare/widgets/header.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final db = FirebaseFirestore.instance;

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
    getUsers();
  }

  getUsers() {
    db.collection('users').get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        print(doc.data());
      });
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: Text('Time line'),
    );
  }
}
