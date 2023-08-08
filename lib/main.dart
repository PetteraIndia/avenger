import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/boarding_screen1.dart';
import 'Screens/socialmediapage.dart';
import 'Screens/welcomescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Lock the orientation to portrait mode
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
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
  const MyApp({super.key});

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
      home: FutureBuilder<bool>(
        future: checkUserLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Image.asset(
                  'img/petterablue.png'), // Replace with your image asset path
            );
          } else {
            if (snapshot.hasData && snapshot.data == true) {
              // User is already logged in
              String userId = FirebaseAuth.instance.currentUser!.uid;
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Image.asset(
                          'img/petterablue.png'), // Replace with your image asset path
                    );
                  } else {
                    if (snapshot.hasData && snapshot.data!.exists) {
                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      bool hasPhone = data.containsKey('phone');

                      if (hasPhone) {
                        // User has a phone number, navigate to SocialMediaPage
                        return const SocialMediaPage(Si: 0, ci: 0);
                      } else {
                        // User doesn't have a phone number, navigate to BoardingScreen
                        return const BoardingScreen1();
                      }
                    } else {
                      // Document doesn't exist, navigate to BoardingScreen
                      return const BoardingScreen1();
                    }
                  }
                },
              );
            } else {
              // User is not logged in, navigate to WelcomeScreen
              return const WelcomeScreen();
            }
          }
        },
      ),
    );
  }

  Future<bool> checkUserLoggedIn() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return user != null;
  }
}

// Your other screens and widgets (SocialMediaPage and WelcomeScreen) go here...
