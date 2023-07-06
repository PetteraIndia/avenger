import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class socialpostwidget extends StatelessWidget {
  const socialpostwidget({
    super.key,
    required this.screenSize,
    required this.postContainerHeight,
    required this.floatingBarHeight,
  });

  final Size screenSize;
  final double postContainerHeight;
  final double floatingBarHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: screenSize.height * 0.01), // Space below floating bar
        Expanded(
          child: Stack(
            children: [
              ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    height: postContainerHeight,
                    width: screenSize.width,
                    color: Colors.grey[200],
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text('Post $index'),
                  );
                },
              ),
              Positioned(
                bottom: screenSize.height * 0.1,
                right: screenSize.width * 0.05,
                child: GestureDetector(
                  onTap: () {
                    // Add your desired functionality when the plus icon is pressed
                  },
                  child: Container(
                    height: screenSize.height * 0.07,
                    width: screenSize.height * 0.07,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add, color: Colors.white,),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: floatingBarHeight * 0.3), // Space below floating bar
      ],
    );
  }
}