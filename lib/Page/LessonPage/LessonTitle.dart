import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Page/LessonPage/LessonController.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/mybutton.dart';
import 'package:user_ocean_learn/Widgets/mytext.dart';
import 'package:user_ocean_learn/Widgets/mycard.dart';

class LessonDetailPage extends StatefulWidget {
  final String lessonTitle;
  final String lessonDate;

  LessonDetailPage({
    this.lessonTitle ='', 
    this.lessonDate = ''
  });

  @override
  _LessonDetailPageState createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  bool _isNoteMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: MyText(
          text: widget.lessonTitle,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Incoming Class Info
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFFF0F8FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: 'Incoming Class',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      MyText(
                        text: widget.lessonDate,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text('Attendance'),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // SVG Illustration
            SvgPicture.asset(
              'Assets/images/home.svg',
              height: 200,
              fit: BoxFit.contain,
            ),

            SizedBox(height: 24),

            // Buttons and Note Section
            if (!_isNoteMode)
              Column(
                children: [
                  MyButton(
                    text: "Let's check the lessons!",
                    backgroundColor: Color(0xFFF0F8FF),
                    textColor: Colors.black,
                    fullWidth: true,
                    onPressed: () {
                      // Implement lesson check functionality
                    }, 
                    onTap: () {},
                  ),
                  SizedBox(height: 16),
                  MyButton(
                    text: 'I want to write a note',
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    fullWidth: true,
                    onPressed: () {
                      setState(() {
                        _isNoteMode = true;
                      });
                    }, 
                    onTap: () {},
                  ),
                ],
              )
            else
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Point 1:',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12),
                          ),
                          maxLines: null,
                        ),
                        Divider(),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Point 2:',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12),
                          ),
                          maxLines: null,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: MyButton(
                          text: 'Save note',
                          backgroundColor: Color(0xFFF0F8FF),
                          textColor: Colors.black,
                          fullWidth: true,
                          onPressed: () {
                            // Save note functionality
                          },
                          onTap: () {},
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _isNoteMode = false;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}