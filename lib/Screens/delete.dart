import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'LoginScreen.dart'; // Import Firebase Authentication package

Future<void> _signOut(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        '52830187312-165qn0553dqp2thq91pqs3m8mtlpjhc3.apps.googleusercontent.com',
  );
  final FirebaseAuth auth = FirebaseAuth.instance;

  try {
    await auth.signOut();
    await googleSignIn.signOut(); // Sign out from Google
    // Sign out from Firebase

    // Navigate to the sign-in screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  } catch (e) {
    print('Error signing out: $e');
  }
}

class DeleteAccountScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _deleteAccount(BuildContext context) async {
    final user = _auth.currentUser;

    if (user != null) {
      // Show a confirmation dialog
      final shouldDelete = await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('Confirm Deletion'),
            content: Text('We feel sorry to let you go ! 🥺 '),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext, false); // Cancel
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext, true); // Confirm
                },
                style: ElevatedButton.styleFrom(primary: Colors.red),
                child: Text('Confirm'),
              ),
            ],
          );
        },
      );

      if (shouldDelete == true) {
        try {
          final userUid = user.uid; // Get the UID of the user
          await user.delete();

          // Delete user's document from Firestore collection
          final firestoreInstance = FirebaseFirestore.instance;
          await firestoreInstance.collection('users').doc(userUid).delete();

          _signOut(context); // Log the user out

          // Account and document deleted successfully
          print('Account and document deleted successfully');
        } catch (error) {
          print('Error deleting account: $error');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Account Deletion'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Are you sure you want to delete your account?',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _deleteAccount(context),
                style: ElevatedButton.styleFrom(primary: Colors.red),
                child: Text('Confirm'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(
                      context); // Close the delete confirmation screen
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
