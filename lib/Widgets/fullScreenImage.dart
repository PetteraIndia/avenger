import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
          ),
          Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.vertical,
            onDismissed: (_) {
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.transparent,
              child: PhotoView(
                imageProvider: NetworkImage(imageUrl),
                initialScale: PhotoViewComputedScale.contained,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
