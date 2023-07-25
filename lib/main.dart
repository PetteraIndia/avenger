import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:petterav1/Screens/boarding_screen1.dart';
import 'package:petterav1/Screens/newpost.dart';
import 'package:petterav1/Screens/profile_screen.dart';
import 'package:petterav1/Screens/socialmediapage.dart';
import 'package:petterav1/Screens/welcomescreen.dart';
import 'package:petterav1/mobileScreen.dart';

import 'Screens/LoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pettera',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: checkUserLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the future is loading, show a loading indicator or splash screen
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasData && snapshot.data == true) {
              // User is already logged in, navigate to SocialMediaPage
              return SocialMediaPage(Si: 1, ci: 0);
            } else {
              // User is not logged in, navigate to LoginScreen
              return WelcomeScreen();
            }
          }
        },
      ),
    );
  }

  Future<bool> checkUserLoggedIn() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    return user != null;
  }
}
