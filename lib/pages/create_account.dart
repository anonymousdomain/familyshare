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
    submit() {
      formkey.currentState?.save();
      Navigator.pop(context, username);
    }

    return Scaffold(
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
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
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
            ],
          )
        ],
      ),
    );
  }
}
