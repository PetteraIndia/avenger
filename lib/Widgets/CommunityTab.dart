import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatDate(Timestamp timestamp) {
  final date = timestamp.toDate();
  final formatter = DateFormat.yMMMMd().add_jm();
  return formatter.format(date);
}

class CommunityTab extends StatelessWidget {
  final String userId;

  const CommunityTab({required this.userId});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('usersdata')
          .doc(userId)
          .collection('community')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading community posts'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final communityDocs = snapshot.data!.docs;

        if (communityDocs.isEmpty) {
          return Center(
            child: Text('No community posts found'),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              ...List.generate(
                communityDocs.length,
                (index) {
                  final communityData =
                      communityDocs[index].data() as Map<String, dynamic>;
                  final caption = communityData['caption'] ?? '';
                  final description = communityData['description'] ?? '';
                  final datePublished =
                      formatDate(communityData['datePublished'] as Timestamp);
                  final communityName = communityData['community'] ?? '';

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: h * 0.01),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(w * 0.04),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(w * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              caption,
                              style: TextStyle(
                                fontSize: w * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: h * 0.01),
                            Text(
                              description,
                              style: TextStyle(
                                fontSize: w * 0.04,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: h * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  datePublished,
                                  style: TextStyle(
                                    fontSize: w * 0.035,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  communityName,
                                  style: TextStyle(
                                    fontSize: w * 0.035,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: h *
                    0.02, // Add spacing between the community posts and the empty container
              ),
              Container(
                height: h * 0.1, // Adjust the height as desired
              ),
            ],
          ),
        );
      },
    );
  }
}
