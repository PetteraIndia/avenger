import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petterav1/Screens/boarding_screen1.dart';
import 'package:petterav1/Screens/boarding_screen2.dart';

import 'package:petterav1/Screens/login_screen.dart';
import 'package:petterav1/Screens/newpost.dart';

import 'package:petterav1/Screens/socialmediapage.dart';

class AuthService {
  Stream<User?> handleAuthState() {
    return FirebaseAuth.instance.authStateChanges();
  }


  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();

    await GoogleSignIn().signOut();
    print("done signout");
    AuthService().handleAuthState();

  }
}
