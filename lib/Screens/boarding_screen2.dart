import 'package:flutter/material.dart';

class BoardingScreen2 extends StatefulWidget {
  const BoardingScreen2({super.key});

  @override
  State<BoardingScreen2> createState() => _BoardingScreen2State();
}

class _BoardingScreen2State extends State<BoardingScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boarding Screen 2'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to the previous screen
          },
        ),
      ),
      body: Center(
        child: Text('Welcome to Boarding Screen 2'),
      ),
    );
  }
}
