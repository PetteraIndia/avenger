import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petterav1/Screens/boarding_screen1.dart';
import 'package:petterav1/Screens/socialmediapage.dart';
import 'package:pinput/pinput.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

Future<void> signInWithGoogle(BuildContext context) async {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

        // Check if the user has signed in before
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(user.uid).get();

        if (snapshot.exists && snapshot.data() != null) {
          final data = snapshot.data()! as Map<String, dynamic>;

          bool hasSignedInBefore = data['hasSignedInBefore'] ?? false;

          if (hasSignedInBefore) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SocialMediaPage()),
            );
          } else {
            // Set the flag indicating the user has signed in before
            await _firestore
                .collection('users')
                .doc(user.uid)
                .set({'hasSignedInBefore': true});

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BoardingScreen1()),
            );
          }
        }
      }
    }
  } catch (e) {
    print('Error signing in with Google: $e');
  }
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  String verificationId = '';
  bool isVerifyingSendCode = false;
  bool isVerifyingVerifyNumber = false;

  Future<void> verifyPhoneNumber() async {
    try {
      setState(() {
        isVerifyingSendCode = true;
      });

      await _auth.verifyPhoneNumber(
        phoneNumber: '+91${_phoneNumberController.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          // Verification is complete, proceed with the next steps
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failure
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            this.verificationId = verificationId;
            isVerifyingSendCode = false; // Stop the loader
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            this.verificationId = verificationId;
            _otpController.text =
                verificationId; // Fill the OTP field with the received verificationId
          });
        },
        timeout: const Duration(seconds: 120),
      );
    } catch (e) {
      // Handle any errors during verification
    } finally {
      setState(() {
        isVerifyingSendCode = false;
      });
    }
  }

  Future<void> signInWithOTP() async {
    try {
      setState(() {
        isVerifyingVerifyNumber = true;
      });

      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: _otpController.text,
      );
      await _auth.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BoardingScreen1()),
      );
      // Verification is complete, proceed with the next steps
    } catch (e) {
      // Handle any errors during sign in
    } finally {
      setState(() {
        isVerifyingVerifyNumber = false;
      });
    }
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'img/petterablue.png',
                width: 200,
                height: 200,
              ),
              SizedBox(
                height: 0,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We need to register your phone before getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    EdgeInsets.symmetric(horizontal: 10), // Add padding here
                child: SizedBox(
                  width: double.infinity,
                  child: TextField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Your Phone Number",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Pinput(
                length: 6,
                showCursor: true,
                onChanged: (value) {
                  setState(() {
                    // Store the OTP value
                    _otpController.text = value;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed:
                            isVerifyingSendCode ? null : verifyPhoneNumber,
                        icon: isVerifyingSendCode
                            ? CircularProgressIndicator()
                            : Icon(Icons.send),
                        label: Text("Send OTP"),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed:
                            isVerifyingVerifyNumber ? null : signInWithOTP,
                        icon: isVerifyingVerifyNumber
                            ? CircularProgressIndicator()
                            : Icon(Icons.verified),
                        label: Text("Verify OTP"),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: h * 0.02,
              ),
              SizedBox(
                height: h * 0.01,
              ),
              Text(
                'OR',
                style: TextStyle(
                  fontSize: w * 0.05,
                ),
              ),
              SizedBox(
                height: h * 0.01,
              ),
              ElevatedButton.icon(
                onPressed: () => signInWithGoogle(context),
                icon: Image.asset(
                  'img/g.png',
                  width: 35,
                ),
                label: const Text(
                  'Continue with Google',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(
                height: h * 0.2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
