import 'package:flutter/material.dart';

class StampScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Stamps'),
      ),
      body: Center(
        child: Image.asset('img/comingSoon.png'),
      ),
    );
  }
}
