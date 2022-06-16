import 'package:familyshare/pages/activity_feed.dart';
import 'package:familyshare/pages/profile.dart';
import 'package:familyshare/pages/search.dart';
import 'package:familyshare/pages/timeline.dart';
import 'package:familyshare/pages/upload.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignIn = GoogleSignIn();

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;

  late PageController pageController;
  late int pageIndex=0;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage:2);
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      // print(err);
    });
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      // print(err);
    });
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onPageTap(int pageIndex) {
    pageController.jumpToPage(
      pageIndex,
    );
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

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Timeline(),
          ActivityFeed(),
          Upload(),
          Search(),
          Profile(),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onPageTap,
        activeColor: Theme.of(context).primaryColor,
        iconSize: 35,
       // backgroundColor: Theme.of(context).secondaryHeaderColor,
        
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.whatshot), label: 'whatshot'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active), label: 'notification'),
          BottomNavigationBarItem(
              icon: Icon(Icons.photo_camera), label: 'upload'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'profile'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
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
