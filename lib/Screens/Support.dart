import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatelessWidget {
  // Helper method to open phone dialer
  void _launchCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Helper method to open email client
  void _launchEmail(String email) async {
    final url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Widget for the call button
  Widget _buildCallButton() {
    return ElevatedButton.icon(
      onPressed: () {
        _launchCall('9591624226');
      },
      icon: Icon(Icons.phone, size: 24),
      label: Text('Call Support'),
    );
  }

  // Widget for the email button
  Widget _buildEmailButton() {
    return ElevatedButton.icon(
      onPressed: () {
        _launchEmail('petterahelpline@gmail.com');
      },
      icon: Icon(Icons.email, size: 24),
      label: Text('Email Support'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyText1!.color;

    return Scaffold(
      appBar: AppBar(
        title: Text('Support'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your satisfaction is our top priority. Should you have any questions, concerns, or encounter any issues while using Pettera Services, our dedicated support team is here to assist you every step of the way. We offer multiple channels to get in touch:',
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
                SizedBox(height: 20),
                Text(
                  'Phone Support:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
                SizedBox(height: 10),
                Text(
                  'Feel free to give us a call on our helpline, and one of our friendly support agents will be delighted to help you out. We value your time, and we aim to address your queries promptly.',
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
                SizedBox(height: 20),
                Center(child: _buildCallButton()),
                SizedBox(height: 20),
                Text(
                  'Email Support:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
                SizedBox(height: 10),
                Text(
                  "Can't talk right now? No worries! Drop us an email with your concern, and we promise to get back to you within 24 hours. Our email support team is highly responsive and committed to resolving any issues you may encounter.",
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
                SizedBox(height: 20),
                Center(child: _buildEmailButton()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
