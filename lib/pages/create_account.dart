import 'dart:async';

import 'package:familyshare/widgets/header.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext parentContext) {
    String? username;
    final formkey = GlobalKey<FormState>();
    // final scaffoldKey = GlobalKey<ScaffoldState>();
    submit() {
      final form = formkey.currentState;
      if (form!.validate()) {
        form.save();
        SnackBar snackBar = SnackBar(
          content: Text('welcome $username'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Timer(
          Duration(seconds: 2),
          () {
            Navigator.pop(context, username);
          },
        );
      }
    }

    return Scaffold(
      // key: scaffoldKey,
      appBar: header(context, appTitle: 'Creat Your Account'),
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Center(
                  child: Text(
                    'create your username',
                    style: TextStyle(fontSize: 25.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: formkey,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.length < 5 || value.isEmpty) {
                        return 'username is to short';
                      } else if (value.trim().length > 12) {
                        return 'username is to long';
                      }
                      return null;
                    },
                    onSaved: (newValue) => username = newValue,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Your Username',
                        labelStyle: TextStyle(fontSize: 15.0),
                        hintText: 'must be at least 3 characters'),
                  ),
                ),
              ),
              GestureDetector(
                onTap: submit,
                child: Container(
                  height: 50.0,
                  width: 350.0,
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'submit',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
