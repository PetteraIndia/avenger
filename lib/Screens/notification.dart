import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with your actual notification count or use dynamic data
        itemBuilder: (context, index) {
          // Replace with your notification item widget
          return ListTile(
            title: Text('Notification $index'),
          );
        },
      ),
    );
  }
}
