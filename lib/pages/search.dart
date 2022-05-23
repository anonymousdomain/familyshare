import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familyshare/models/user.dart';
import 'package:familyshare/pages/timeline.dart';
import 'package:familyshare/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
    Future<QuerySnapshot>?usersSearchResult;
  TextEditingController searchController = TextEditingController();

  clearSearch() {
    searchController.clear();
  }

  handleSearch(String query) {
    Future<QuerySnapshot> usersSearch =
        db.where('displayName', isGreaterThanOrEqualTo: query).get();
    setState(() {
      usersSearchResult = usersSearch;
    });
  }

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'search for a user...',
          filled: true,
          prefixIcon: Icon(
            Icons.account_box,
            size: 30.0,
          ),
          suffixIcon: IconButton(
            onPressed:clearSearch,
            icon: Icon(Icons.clear),
          ),
        ),
        onFieldSubmitted: handleSearch,
      ),
    );
  }

  buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            SvgPicture.asset('assets/images/search.svg',
                height: orientation == Orientation.portrait ? 300 : 200),
            Text(
              'Find User',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 50.0,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic),
            )
          ],
        ),
      ),
    );
  }

  buildSearchResults() {
    return FutureBuilder<QuerySnapshot>(
      future: usersSearchResult,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<Text> searchResults = [];
        snapshot.data!.docs.map((doc) {
          User user = User.fromDocument(doc);
          searchResults.add(Text(user.displayName));
        }).toList();
        return ListView(
          children: searchResults,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      appBar: buildSearchField(),
      // ignore: unnecessary_null_comparison
      body: usersSearchResult == null ? buildNoContent() : buildSearchResults(),
    );
  }
}

class UserResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("User Result");
  }
}
