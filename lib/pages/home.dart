import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignIn = GoogleSignIn();

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;

  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
     // print(err);
    });
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
     //  print(err);
    });
  }

  handleSignIn(account) {
    if (account != null) {
      print('user:$account');
      setState(
        () {
          isAuth = true;
        },
      );
    } else {
      setState(
        () {
          isAuth = false;
        },
      );
    }
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  Widget buildAuthScreen() {
    return ElevatedButton(
      onPressed: logout,
      child: Text('logout',style: TextStyle(fontSize: 26),),
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme.of(context).secondaryHeaderColor,
            Theme.of(context).primaryColor,
          ], begin: Alignment.topRight, end: Alignment.bottomLeft),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'FamilyShare',
              style: TextStyle(
                  fontFamily: 'Roboto', fontSize: 50.0, color: Colors.white),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/googleIcon.png'),
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
