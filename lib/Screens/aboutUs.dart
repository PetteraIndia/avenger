import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCard(
                heading: 'WHO WE ARE?',
                text:
                    'Pettera is an early-stage start-up that is on a mission to build a community that supports animals in need. We are passionate about creating a platform that connects animal lovers with animals that require our assistance, and we need your help to achieve this goal.',
              ),
              _buildCard(
                heading: 'OUR MISSION',
                text:
                    'At Pettera, our mission is simple: we want to make a difference in the world and help animals in need. We believe that animals deserve love, care, and respect, and we are dedicated to building a community that supports them in every way possible. Our vision is to create a platform that connects animal lovers with animals that require our assistance, whether it\'s through adoption, fostering, volunteering, or donating.',
              ),
              _buildCard(
                heading: 'HOW YOU CAN HELP?',
                text:
                    'You can help make a difference for animals by spreading the word about our community and inviting your friends and family to join us. Together, we can create a movement for animal welfare that reaches far and wide. By being an active member of our community, you can make a real impact on the lives of animals in need. Share your ideas and suggestions for ways we can improve and become more effective in helping animals.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String heading, required String text}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(text),
          ],
        ),
      ),
    );
  }
}
