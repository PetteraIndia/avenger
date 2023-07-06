import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petterav1/Screens/boarding_screen1.dart';
import 'package:petterav1/Screens/login_screen.dart';
import 'package:petterav1/Screens/newpost.dart';
import 'package:petterav1/mobileScreen.dart';
import 'package:petterav1/resources/auth_service.dart';

import 'Screens/boarding_screen3.dart';

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
      home: AuthService().handleAuthState(),
    );
  }
}
