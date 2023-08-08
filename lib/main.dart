import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/socialmediapage.dart';
import 'Screens/welcomescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCf1dJ8UZT3UzJNL-DkQtQ5EMbXDpvK0pw",
        appId: "1:52830187312:web:ba4a004b712dbf57a222f5",
        messagingSenderId: "52830187312",
        authDomain: "pettera-130c0.firebaseapp.com",
        projectId: "pettera-130c0",
        storageBucket: "pettera-130c0.appspot.com",
        measurementId: "G-GZ6T5LZZYD",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

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
      home: FutureBuilder(
        future: checkUserLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.hasData && snapshot.data == true) {
              // User is already logged in, navigate to SocialMediaPage
              return const SocialMediaPage(Si: 0, ci: 0);
            } else {
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
