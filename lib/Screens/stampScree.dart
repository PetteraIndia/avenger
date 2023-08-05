import 'package:flutter/material.dart';

class StampScreen extends StatelessWidget {
  const StampScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Stamps'),
      ),
      body: Center(
        child: Image.asset('img/comingSoon.png'),
      ),
    );
  }
}
