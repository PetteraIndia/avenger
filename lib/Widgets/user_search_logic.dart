import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petterav1/Screens/userProfileScreen.dart';

class UserSearch extends StatefulWidget {
  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> userList = [];
  List<Map<String, dynamic>> searchResults = [];
  bool showSearchResults = false;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').get();

    if (snapshot.docs.isNotEmpty) {
      List<Map<String, dynamic>> users =
          snapshot.docs.map((doc) => doc.data()).toList();
      setState(() {
        userList = users;
      });
    }
    print('Fetched ${userList.length} users'); // Added print statement
  }

  void performSearch(String query, String currentUserId) {
    List<Map<String, dynamic>> results = [];

    if (query.isNotEmpty) {
      results = userList.where((user) {
        String fullName = user['Full Name'].toLowerCase();
        String username = user['Username'].toLowerCase();
        String userId = user['uid'];

        // Exclude the current user from the search results
        bool isCurrentUser = userId == currentUserId;

        return !isCurrentUser &&
            (fullName.contains(query.toLowerCase()) ||
                username.contains(query.toLowerCase()));
      }).toList();
    }

    setState(() {
      searchResults = results;
    });
  }

  Widget buildSearchResults() {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> user = searchResults[index];
        String userId = user['uid'];

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user['photoUrl']),
          ),
          title: Text(
            user['Full Name'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          subtitle: Text(
            '@${user['Username']}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14.0,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 18.0,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfileScreen(userId: userId),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          onChanged: (query) {
            print('Search query: $query'); // Added print statement
            performSearch(query, FirebaseAuth.instance.currentUser!.uid);
          },
          decoration: InputDecoration(
            hintText: 'Search your Friend',
            border: InputBorder.none,
          ),
        ),
      ),
      body: searchResults.isNotEmpty ? buildSearchResults() : Container(),
    );
  }
}
