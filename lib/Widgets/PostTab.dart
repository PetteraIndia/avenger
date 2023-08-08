import 'package:flutter/material.dart';
import 'package:petterav1/Widgets/fullScreenImage.dart';

class PostGridView extends StatelessWidget {
  final List<String> postImageUrls;

  const PostGridView({super.key, required this.postImageUrls});

  @override
  Widget build(BuildContext context) {
    if (postImageUrls.isEmpty) {
      // If postImageUrls is empty, display "No posts found" message
      return const Center(
        child: Text('No posts found'),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: postImageUrls.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(
                        imageUrl: postImageUrls[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[200],
                  ),
                  child: Image.network(
                    postImageUrls[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: 16.0,
          ), // Add spacing between the grid and the empty row
          Container(
            height: 120, // Adjust the height as desired
          ),
        ],
      ),
    );
  }
}
