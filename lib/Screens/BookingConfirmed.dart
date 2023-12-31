import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:petterav1/Screens/socialmediapage.dart';
import 'package:share_plus/share_plus.dart';

import '../main.dart';

class BookingConfirmed extends StatelessWidget {
  final String animal;
  final String location;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String address;
  final String type;
  final String price;
  final String orderId;

  const BookingConfirmed({super.key, 
    required this.animal,
    required this.location,
    required this.selectedDate,
    required this.selectedTime,
    required this.address,
    required this.type,
    required this.price,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    const String discount ='0';
    return WillPopScope(
        onWillPop: () async {
      // Handle the back button press here
      // Navigate to the initial route when the back button is pressed
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyApp()), // Replace 'MyApp' with your main app widget
                (route) => false,
          );
      return false;
    },
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Confirmed'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SocialMediaPage(Si: 1, ci: 0), // Replace 'HomePage' with your actual page widget
              ),
            ); // Go back when back button is pressed
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
                  style: const TextStyle(fontSize: 14),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            buildConfirmationItem(
                'OrderId:',
                Text(
                  orderId ,
                  style: const TextStyle(fontSize: 14),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            buildConfirmationItem(
                'Animal:',
                Text(
                  animal,
                  style: const TextStyle(fontSize: 14),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            buildConfirmationItem(
                'Location:',
                Text(
                  location,
                  style: const TextStyle(fontSize: 14),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            buildConfirmationItem(
                'Address:',
                Text(
                  address,
                  style: const TextStyle(fontSize: 14),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            buildConfirmationItem(
              'Time Slot:',
              Text(
                '${DateFormat('yyyy-MM-dd').format(selectedDate)} at ${selectedTime.format(context)}',
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            const Row(
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
                const Text(
                  'Order Amount:',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'Rs $price',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discount:',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'Rs $discount',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Mode:',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'Cash',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            const Divider(
              // Horizontal line to separate sections
              color: Colors.grey,
              height: 1,
              thickness: 1,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'To Pay:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                // Calculate and display the difference of order amount and discount
                Text(
                  "RS $price",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle the 'Home' tap action here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SocialMediaPage(Si: 1, ci: 0), // Replace 'HomePage' with your actual page widget
                      ),
                    );
                  },

                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.04,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color(0xFF07203F),
                    ),
                    child: const Center(
                      child: Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: () {

                      // Handle the 'Download' tap action here
                    },
                    child: RepaintBoundary(
                        child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.04,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color(0xFF07203F),
                      ),
                      child: InkWell(
                        onTap: () async {

                            String postInfo =
                                "The Appointment of your Pet *$animal* has been Sheduled: \n\n *Order Id:* $orderId\n\n *Date of appointment:* ${DateFormat('yyyy-MM-dd').format(selectedDate)}\n\n "
                                "*Time:* $selectedTime \n\n *Location:* $address"  ;



                            await Share.share(postInfo);

                        },
                        child: const Center(
                          child: Text(
                            'Share',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ))),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget buildConfirmationItem(String heading, Widget content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            heading,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: content),
      ],
    );
  }
}
