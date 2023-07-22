import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petterav1/Screens/userProfileScreen.dart';

class NotificationsPage extends StatelessWidget {
  bool hasNewNotification = false;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .collection('followNotifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching notifications'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No notifications'),
            );
          }

          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.withOpacity(0.3),
              thickness: 0.5,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final notification = snapshot.data!.docs[index];
              final fullName = notification['fullName'];
              final profileUrl = notification['profileUrl'];
              final message = notification['message'];
              final timestamp = notification['timestamp'].toDate();
              final String userId = notification['uid']; // Get the USER_ID

              // Format the date to show "Today", "Yesterday", or minutes/hours ago
              final String formattedDate = _formatDate(timestamp);

              return ListTile(
                onTap: () {
                  // Redirect to UserProfileScreen with the retrieved USER_ID
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileScreen(userId: userId),
                    ),
                  );
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(profileUrl),
                ),
                title: RichText(
                  text: TextSpan(
                    text: fullName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: w * 0.05,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: ', ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: w * 0.04,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: message,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: w * 0.04,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: w * 0.035,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (date.isAfter(today)) {
      final difference = now.difference(date);
      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} min ago';
      } else {
        return '${difference.inHours} hrs ago';
      }
    } else if (date.isAfter(yesterday)) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
