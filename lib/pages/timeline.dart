import 'package:familyshare/widgets/header.dart';
import 'package:familyshare/widgets/progress.dart';
import 'package:flutter/material.dart';

//final db = FirebaseFirestore.instance.collection('users');
//final posts=FirebaseFirestore.instance.collection('posts');
class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context,isAppTitle: true,),
      body: circularProgress(),
    );
  }
}
