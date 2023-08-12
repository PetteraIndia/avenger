import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

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
  final String serviceprovidercontact;

  BookingConfirmation({
    required this.animal,
    required this.location,
    required this.selectedDate,
    required this.selectedTime,
    required this.address,
    required this.type,
    required this.price,
    required this.name,
    required this.serviceprovidercontact,
  });

  String userId = FirebaseAuth.instance.currentUser!.uid;
  String createOrder() {
    String userUid = FirebaseAuth.instance.currentUser!
        .uid; // Replace this with your actual user UID logic.
    int randomNumber = Random().nextInt(10000000);
    return userUid + randomNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String username = '';
    String userContact = '';

    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        username = data?['Username'] ?? '';
        userContact = data?['phone'] ?? '';
      } else {
        print('User document does not exist.');
      }
    }).catchError((error) {
      print('Error fetching user data: $error');
    });

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
                  "Rs $price",
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
              'Book Now',
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
                              'datePublished': now.toUtc(),
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
                              'datePublished': now.toUtc(),
                            }).then((_) async {
                              await sendCustomMessage();
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

Future<void> sendCustomMessage() async {
  final String apiUrl =
      'https://graph.facebook.com/v17.0/115655814950394/messages';
  final String accessToken =
      'EAAfqFTnxC0IBO8aKHnZAZBgY7eVZA0J8FGi8y3919ZC8ZAws4aBXlKNOhrng1hPmihnP8pbOJ21ZBd8WeQGusLqPYPpjB5zkUtWFZAhgoBYzgRlQa0iZBS4dpecbJuXZBXmdc9pyt7ZAq7RlINB7PmMeO6YTDubZCqrZAbMzylERetgkrxIHgEsZBeZBHYWva3Ku6dGfZBj1NuKKIaBz7bHfe0kjqoZD';

  final Map<String, dynamic> messageData = {
    "messaging_product": "whatsapp",
    "to":
        "919953495751", // Replace with the recipient's phone number in E.164 format (without the + sign).
    "type": "text", // Use 'text' for a simple text message.
    "text": {
      "body":
          "Hello, this is a custom message sent from my Flutter app using the WhatsApp API!"
    }
  };

  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  final response = await http.post(Uri.parse(apiUrl),
      headers: headers, body: jsonEncode(messageData));

  if (response.statusCode == 200) {
    print('Message sent successfully!');
    print('Response body: ${response.body}');
  } else {
    print('Failed to send message. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
