import 'package:argon_buttons_flutter_fix/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:petterav1/resources/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
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
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(height: 30),
              // TextFieldInput(
              //   textEditingController: phoneController,
              //   hintText: 'Enter Mobile Number',
              //   textInputType: TextInputType.emailAddress,
              // ),
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
                      fontWeight: FontWeight.w700
                  ),
                ),
                loader: (timeLeft) {
                  return Text(
                    "Wait | $timeLeft",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700
                    ),
                  );
                },
                onTap: (startTimer, btnState) {
                  if (btnState == ButtonState.Idle) {
                    startTimer(20);
                  }
                },
              ),

              SizedBox(height: h*0.07,),

              GestureDetector (
                onTap: ()  {

                 AuthService().signInWithGoogle();

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

              // ElevatedButton(
              //   onPressed: () {},
              //   child: Text("Go to signup"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}