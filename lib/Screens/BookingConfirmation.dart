import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:upi_pay/upi_pay.dart';

class BookingConfirmation extends StatefulWidget {
  final String animal;
  final String location;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String address;
  final String type;
  final String price;

  BookingConfirmation({
    required this.animal,
    required this.location,
    required this.selectedDate,
    required this.selectedTime,
    required this.address,
    required this.type,
    required this.price,
  });

  @override
  _BookingConfirmationState createState() => _BookingConfirmationState();
}

class _BookingConfirmationState extends State<BookingConfirmation> {
  final _upiAddressController = TextEditingController();
  final _amountController = TextEditingController();

  String? _upiAddrError;
  bool _isUpiEditable = false;
  List<ApplicationMeta>? _apps;

  @override
  void initState() {
    super.initState();

    _amountController.text =
        (Random.secure().nextDouble() * 10).toStringAsFixed(2);

    Future.delayed(Duration(milliseconds: 0), () async {
      _apps = await UpiPay.getInstalledUpiApplications(
          statusType: UpiApplicationDiscoveryAppStatusType.all);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _upiAddressController.dispose();
    super.dispose();
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
                  widget.type,
                  style: TextStyle(fontSize: 14),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            buildConfirmationItem(
                'Animal:',
                Text(
                  widget.animal,
                  style: TextStyle(fontSize: 14),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            buildConfirmationItem(
                'Location:',
                Text(
                  widget.location,
                  style: TextStyle(fontSize: 14),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            buildConfirmationItem(
                'Address:',
                Text(
                  widget.address,
                  style: TextStyle(fontSize: 14),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            buildConfirmationItem(
              'Time Slot:',
              Text(
                '${DateFormat('yyyy-MM-dd').format(widget.selectedDate)} at ${widget.selectedTime.format(context)}',
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
                  'Rs ${widget.price}',
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
                  'Rs ${calculateToPay()}',
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
            onPressed: () => initiatePayment(context),
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

  void initiatePayment(BuildContext context) async {
    final err = _validateUpiAddress(_upiAddressController.text);
    if (err != null) {
      setState(() {
        _upiAddrError = err;
      });
      return;
    }
    setState(() {
      _upiAddrError = null;
    });

    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    print("Starting transaction with id $transactionRef");

    try {
      final a = await UpiPay.initiateTransaction(
        amount: widget.price,
        app: UpiApplication.paytm, // You can choose the UPI app here.
        receiverName: 'Sharad',
        receiverUpiAddress: _upiAddressController.text,
        transactionRef: transactionRef,
        transactionNote: 'UPI Payment',
      );

      print(a);
      // TODO: Handle the payment success or failure here
      // E.g., show a dialog with the payment status
    } catch (e) {
      print('Error while making payment: $e');
      // TODO: Handle payment error
      // E.g., show a dialog with the error message
    }
  }

  String? _validateUpiAddress(String value) {
    if (value.isEmpty) {
      return 'UPI VPA is required.';
    }
    if (value.split('@').length != 2) {
      return 'Invalid UPI VPA';
    }
    return null;
  }

  String calculateToPay() {
    // Calculate the difference of order amount and discount here
    // For this example, I'm assuming the discount is 0, so the toPay amount is the same as the order amount
    return widget.price;
  }
}
