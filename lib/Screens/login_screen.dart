import 'package:argon_buttons_flutter_fix/argon_buttons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'boarding_screen1.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

Future<void> _signInWithGoogle(BuildContext context) async {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    // Trigger the Google sign-in flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser != null) {
      // Obtain the Google SignInAuthentication and authenticate with Firebase
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Access the signed-in user information
      final User? user = userCredential.user;
      if (user != null) {
        // Successful sign-in
        print('User signed in with Google!');
        print('User ID: ${user.uid}');
        print('User display name: ${user.displayName}');
        print('User email: ${user.email}');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BoardingScreen1()),
        );
        // You can handle the signed-in user here or navigate to another screen
      }
    }
  } catch (e) {
    print('Error signing in with Google: $e');
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IntlPhoneField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'IN',
                onChanged: (phone) {
                  print(phone.completeNumber);
                },
              ),
              SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Send OTP"),
                ),
              ),
              ArgonTimerButton(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.45,
                minWidth: MediaQuery.of(context).size.width * 0.30,
                color: Colors.blue,
                borderRadius: 5.0,
                child: Text(
                  "Resend OTP",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                loader: (timeLeft) {
                  return Text(
                    "Wait | $timeLeft",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  );
                },
                onTap: (startTimer, btnState) {
                  if (btnState == ButtonState.Idle) {
                    startTimer(20);
                  }
                },
              ),
              SizedBox(
                height: h * 0.07,
              ),
              GestureDetector(
                onTap: () {
                  _signInWithGoogle(context);
                },
                child: Container(
                  height: h * 0.2,
                  width: w * 0.5,
                  child: Image.asset(
                    'img/g.png',
                    fit: BoxFit.contain,
                  ),
                  alignment: Alignment.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
