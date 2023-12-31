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

  const CommunityTab({super.key, required this.userId});

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
          return const Center(
            child: Text('Error loading community posts'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final communityDocs = snapshot.data!.docs;

        if (communityDocs.isEmpty) {
          return const Center(
            child: Text('No community posts found'),
          );
        }

        // Sort the communityDocs list based on datePublished in reverse order (most recent first)
        communityDocs.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;
          final aDate = aData['datePublished'] as Timestamp;
          final bDate = bData['datePublished'] as Timestamp;
          return bDate.compareTo(aDate);
        });

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
                              ),
                            ),
                            SizedBox(height: h * 0.01),
                            Text(
                              description,
                              style: TextStyle(
                                fontSize: w * 0.04,
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
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  communityName,
                                  style: TextStyle(
                                    fontSize: w * 0.035,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
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
