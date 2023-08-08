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
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        '52830187312-165qn0553dqp2thq91pqs3m8mtlpjhc3.apps.googleusercontent.com',
  );
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Trigger the Google sign-in flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

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
          await auth.signInWithCredential(credential);

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
            await firestore.collection('users').doc(user.uid).get();

        if (snapshot.exists && snapshot.data() != null) {
          final data = snapshot.data()! as Map<String, dynamic>;

          bool hasSignedInBefore = data['hasSignedInBefore'] ?? false;
          print('User has signed in before: $hasSignedInBefore');

          if (hasSignedInBefore) {
            print('hiiiiiii');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const SocialMediaPage(Si: 0, ci: 0)),
            );
          } else {
            // Set the flag indicating the user has signed in before
            // await firestore
            //     .collection('users')
            //     .doc(user.uid)
            //     .set({'hasSignedInBefore': true});

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BoardingScreen1()),
            );
          }
        } else {
          // User is signing in for the first time, so create a new document
          // await firestore
          //     .collection('users')
          //     .doc(user.uid)
          //     .set({'hasSignedInBefore': true});

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BoardingScreen1()),
          );
        }
      }
    }
  } catch (e) {
    print('Error signing in with Google: $e');
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String verificationId = '';
  bool isVerifyingSendCode = false;
  bool isVerifyingVerifyNumber = false;
  String sendOtpErrorMessage = '';
  String verifyOtpErrorMessage = '';

  Future<void> verifyPhoneNumber() async {
    try {
      setState(() {
        isVerifyingSendCode = true;
        sendOtpErrorMessage = '';
      });

      await _auth.verifyPhoneNumber(
        phoneNumber: '+91${_phoneNumberController.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          // Verification is complete, proceed with the next steps
          await handleSignInComplete();
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failure
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            this.verificationId = verificationId;
            // Stop the loader
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            isVerifyingSendCode = false;
            this.verificationId = verificationId;
            _otpController.text =
                verificationId; // Fill the OTP field with the received verificationId
          });
        },
        timeout: const Duration(seconds: 120),
      );
    } catch (e) {
      setState(() {
        sendOtpErrorMessage =
            'Failed to send OTP'; // Set the send OTP error message
      });
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
        verifyOtpErrorMessage = ''; // Reset the error message
      });

      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: _otpController.text,
      );
      await _auth.signInWithCredential(credential);

      await handleSignInComplete();
    } catch (e) {
      setState(() {
        verifyOtpErrorMessage =
            'Invalid OTP'; // Set the verify OTP error message
      });
    } finally {
      setState(() {
        isVerifyingVerifyNumber = false;
      });
    }
  }

  Future<void> handleSignInComplete() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      // Successful sign-in
      print('User signed in with phone OTP!');
      print('User ID: ${user.uid}');

      // Check if the user has signed in before
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(user.uid).get();

      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()! as Map<String, dynamic>;

        bool hasSignedInBefore = data['hasSignedInBefore'] ?? false;
        print('User has signed in before: $hasSignedInBefore');

        if (hasSignedInBefore) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const SocialMediaPage(Si: 0, ci: 0)),
          );
        } else {
          // Set the flag indicating the user has signed in before
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set({'hasSignedInBefore': true});

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BoardingScreen1()),
          );
        }
      } else {
        // User is signing in for the first time, so create a new document
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set({'hasSignedInBefore': true});

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BoardingScreen1()),
        );
      }
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
        margin: const EdgeInsets.only(left: 25, right: 25),
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
              const SizedBox(
                height: 0,
              ),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your phone before getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 10), // Add padding here
                child: SizedBox(
                  width: double.infinity,
                  child: TextField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Your Phone Number",
                    ),
                  ),
                ),
              ),
              if (sendOtpErrorMessage
                  .isNotEmpty) // Display send OTP error message if it's not empty
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    sendOtpErrorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(
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
              if (verifyOtpErrorMessage
                  .isNotEmpty) // Display verify OTP error message if it's not empty
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    verifyOtpErrorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(
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
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.send),
                        label: const Text("Send OTP"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed:
                            isVerifyingVerifyNumber ? null : signInWithOTP,
                        icon: isVerifyingVerifyNumber
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.verified),
                        label: const Text("Verify OTP"),
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
