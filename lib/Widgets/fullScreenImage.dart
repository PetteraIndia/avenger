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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0), // Add padding to the right
            child: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm Delete'),
                      content:
                          Text('Are you sure you want to delete this post?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Yes'),
                          onPressed: () {
                            // Perform delete operation here
                            Navigator.of(context).pop();
                            // You can also call Navigator.pop(context) if you want to exit the screen after deletion
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
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
