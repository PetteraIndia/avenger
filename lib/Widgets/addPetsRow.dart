import 'package:flutter/material.dart';

class AddPetRow extends StatefulWidget {
  @override
  _AddPetRowState createState() => _AddPetRowState();
}

class _AddPetRowState extends State<AddPetRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6, // Number of avatars in the row
        itemBuilder: (context, index) {
          if (index == 0) {
            // First avatar for "Add Pet"
            return Container(
              margin: EdgeInsets.all(8),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            );
          } else {
            // Other avatars
            return Container(
              margin: EdgeInsets.all(8),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                    'https://thumbs.dreamstime.com/b/cute-cartoon-pet-animals-circle-round-frame-pets-white-background-pet-animals-round-frame-design-177791540.jpg'), // Replace with your avatar image
              ),
            );
          }
        },
      ),
    );
  }
}

// Example usage in a Flutter app

