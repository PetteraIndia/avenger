import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:petterav1/Screens/boarding_screen1.dart';
import 'package:petterav1/Screens/newpost.dart';
import 'package:petterav1/Screens/profile_screen.dart';
import 'package:petterav1/Screens/socialmediapage.dart';
import 'package:petterav1/Screens/welcomescreen.dart';
import 'package:petterav1/mobileScreen.dart';
import 'package:petterav1/Screens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class ThemeNotifier with ChangeNotifier {
  bool _isDarkModeEnabled = false;
  static const String _themeKey = 'isDarkModeEnabled';

  bool get isDarkModeEnabled => _isDarkModeEnabled;

  ThemeNotifier() {
    _loadThemePreference();
  }

  void toggleTheme() {
    _isDarkModeEnabled = !_isDarkModeEnabled;
    _saveThemePreference();
    notifyListeners();
  }

  void _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkModeEnabled = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  void _saveThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themeKey, _isDarkModeEnabled);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final brightness =
        themeNotifier.isDarkModeEnabled ? Brightness.dark : Brightness.light;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pettera',
      theme: ThemeData(
        brightness: brightness,

        primarySwatch: Colors.deepPurple,
        useMaterial3: true,

        // Add other theme properties here...
      ),
      home: FutureBuilder(
        future: checkUserLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasData && snapshot.data == true) {
              // User is already logged in, navigate to SocialMediaPage
              return SocialMediaPage(Si: 0, ci: 0);
            } else {
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
