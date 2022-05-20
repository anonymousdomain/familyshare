import 'dart:async';

import 'package:familyshare/widgets/header.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  late String username;
  final _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  submit() {
    final form = _formkey.currentState;
    if (form!.validate()) {
      form.save();
      SnackBar snackBar = SnackBar(content: Text('welcome ${username}'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, username);
      });
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context, titleText: "set up profile",removeBackButton: true),
      body: ListView(
        children: [
          Container(
            child: Column(children: [
              Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Center(
                  child: Text(
                    'Create a Username',
                    style: TextStyle(fontSize: 25.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                    key: _formkey,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.trim().length < 3 || value.isEmpty) {
                          return 'username is too short';
                        } else if (value.trim().length > 12) {
                          return 'username is to long';
                        }
                        return null;
                      },
                      onSaved: (newValue) => username = newValue!,
                      decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'USER NAME*',
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: 'must be at least 3 characters'),
                    )),
              ),
              GestureDetector(
                onTap: submit,
                child: Container(
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  child: Text(
                    'submit',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
