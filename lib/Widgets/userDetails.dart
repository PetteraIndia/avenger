import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile {
  late String? profilePicUrl;
  late String? fullName;
  late String? bio;

  Future<void> fetchUserProfile() async {
    try {
      print("hiiiiiiiiiiiiiii");
      final userId = FirebaseAuth.instance.currentUser!.uid;
      print(userId); // Replace with the actual current user ID
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final userData = userSnapshot.data();
      if (userData != null) {
        profilePicUrl = userData['photoUrl'];
        fullName = userData['Full Name'];
        bio = userData['bio'];
      }
    } catch (e) {
      // Handle any potential errors here
      print('Error fetching user profile: $e');
    }
  }
}
