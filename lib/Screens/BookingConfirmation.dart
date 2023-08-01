import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paytm/paytm.dart';
import 'dart:math';

import 'BookingConfirmed.dart';

class BookingConfirmation extends StatelessWidget {
  final String animal;
  final String location;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String address;
  final String type;
  final String price;
  final String name;

  BookingConfirmation({
    required this.animal,
    required this.location,
    required this.selectedDate,
    required this.selectedTime,
    required this.address,
    required this.type,
    required this.price,
    required this.name,
  });

  Future<void> paytmPay() async {
    // Get the Paytm credentials from your server.
    // String mid = "YOUR_MID";
    // String mkey = "YOUR_MKEY";
    // String orderId = generateRandomOrderId();
    // String amount = price;
    //
    // // Open the Paytm payment window.
    // Paytm paytm = Paytm(mid, mkey);
    //
    // // Initialize the payment.
    // await paytm.initialize(orderId, amount);
    //
    // // Open the payment window.
    // await paytm.open();
  }
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String createOrder() {
    String userUid = FirebaseAuth.instance.currentUser!
        .uid; // Replace this with your actual user UID logic.
    int randomNumber = Random().nextInt(10000000);
    return userUid + randomNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Confirmation'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Navigator.pop(context); // Go back when back button is pressed
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildConfirmationItem(
                'Service:',
                Text(
                  type,
                  style: TextStyle(fontSize: 14),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            buildConfirmationItem(
                'Animal:',
                Text(
                  animal,
                  style: TextStyle(fontSize: 14),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            buildConfirmationItem(
                'Location:',
                Text(
                  location,
                  style: TextStyle(fontSize: 14),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            buildConfirmationItem(
                'Address:',
                Text(
                  address,
                  style: TextStyle(fontSize: 14),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            buildConfirmationItem(
              'Time Slot:',
              Text(
                '${DateFormat('yyyy-MM-dd').format(selectedDate)} at ${selectedTime.format(context)}',
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Billing Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Row(
                  children: [
                    Text(
                      'view coupons',
                      style: TextStyle(
                          fontSize: 14, decoration: TextDecoration.underline),
                    ),
                    // Add any widgets related to coupons on the right side
                    // E.g., Text('Coupon Code: XYZ123', style: TextStyle(fontSize: 14),),
                  ],
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Amount:',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'Rs $price',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discount:',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'Rs 0',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Divider(
              // Horizontal line to separate sections
              color: Colors.grey,
              height: 1,
              thickness: 1,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'To Pay:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                // Calculate and display the difference of order amount and discount
                Text(
                  'Rs 400',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.07,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color(0xFF07203F),
        ),
        child: Center(
          child: FloatingActionButton.extended(
            label: Text(
              'Pay Now',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Pay Now'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.payment),
                          title: Text('Pay with Paytm'),
                          onTap: () async {
                            // Handle Paytm payment
                            await paytmPay();
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.money),
                          title: Text('Pay with Cash'),
                          onTap: () async {
                            String orderId = createOrder();

                            // Store the data in Firestore
                            await FirebaseFirestore.instance
                                .collection('orders')
                                .doc(orderId)
                                .set({
                              'animal': animal,
                              'selectedDate': selectedDate,
                              'selectedTime': selectedTime.toString(),
                              'location': location,
                              'type': type,
                              'price': price,
                              'address': address,
                              'orderId': orderId,
                              'name': name,
                            });
                            await FirebaseFirestore.instance
                                .collection('usersdata')
                                .doc(userId)
                                .collection('orders')
                                .doc(orderId)
                                .set({
                              'animal': animal,
                              'selectedDate': selectedDate,
                              'selectedTime': selectedTime.toString(),
                              'location': location,
                              'type': type,
                              'price': price,
                              'address': address,
                              'orderId': orderId,
                              'name': name,
                            }).then((_) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingConfirmed(
                                    animal: animal!,
                                    location: location!,
                                    selectedDate: selectedDate!,
                                    selectedTime: selectedTime!,
                                    address: address,
                                    type: type,
                                    price: price,
                                    orderId: orderId,
                                  ),
                                ),
                              );
                            }).catchError((error) {
                              // Handle any errors that occur during data storage.
                              print("Error storing data: $error");
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildConfirmationItem(String heading, Widget content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          child: Text(
            heading,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 8),
        Expanded(child: content),
      ],
    );
  }
}
