import 'package:flutter/material.dart';

class BoardingScreen3 extends StatefulWidget {
  const BoardingScreen3({super.key});

  @override
  State<BoardingScreen3> createState() => _BoardingScreen3State();
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height - 50, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class _BoardingScreen3State extends State<BoardingScreen3> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          // Container with wavy bottom
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: h * .2,
              color: Colors.blue,
              child: Center(
                child: Text(
                  'Personal Details',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
