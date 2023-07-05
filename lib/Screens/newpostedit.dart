import 'package:flutter/material.dart';
import 'package:petterav1/Screens/newpost.dart';
import 'globals.dart';
import 'dart:io';

File? image = selectedImage;


class newpostedit extends StatefulWidget {
  const newpostedit({Key? key}) : super(key: key);

  @override
  State<newpostedit> createState() => _newposteditState();
}

class _newposteditState extends State<newpostedit> {
  int selectedIndex = 0;
  List<String> filters = [
    'vivid',
    'Humid',
    'Sunburn',
    // Add more filter names here
  ];
  void _selectIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Post',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => newpost()),
            );
          },
        ),

        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 0.6,
                ),
              ),
            ),
          ),
        ),
      ),

      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: w * 0.18),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: selectedIndex == 0 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(width: w * 0.18),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: Text(
                    '|',
                    style: TextStyle(
                      fontSize: 16.0,
                      // fontWeight: selectedTextIndex == 1 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(width: w * 0.18),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                  child: Text(
                    'Edits',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: selectedIndex == 2 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.038),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 0.2,
                ),
              ),
              height: h * 0.25,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (selectedImage != null)
                    Align(
                      alignment: Alignment.center,
                      child: Image.file(selectedImage!, fit: BoxFit.contain),
                    ),

                ],
              ),
            ),
            SizedBox(height: h * 0.02),
            Text(
              'Available Filters:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              height: 60.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Apply the selected filter
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 8.0),
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.grey[300],
                      ),
                      child: Text(
                        filters[index],
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),




    );
  }
}
