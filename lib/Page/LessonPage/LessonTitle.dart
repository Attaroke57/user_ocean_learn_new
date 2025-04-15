import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user_ocean_learn/Page/LessonPage/LessonController.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/mybutton.dart';
import 'package:user_ocean_learn/Widgets/mytext.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Widgets/mytextfield.dart';

class LessonDetailPage extends StatelessWidget {
  final String lessonTitle;
  final String lessonDate;

  LessonDetailPage(
      {Key? key, this.lessonTitle = "",  this.lessonDate =""})
      : super(key: key);

  final LessonController controller = Get.put(LessonController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: netralcolor,
      appBar: AppBar(
        backgroundColor: netralcolor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: MyText(
          text: lessonTitle,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Obx(() => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Card containing lesson info and content
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Incoming Class Info
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
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
                                      text: lessonDate,
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: MyButton(
                                    backgroundColor: secondarycolor,
                                    text: 'Attendance',
                                    textColor: textcolor,
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24),

                          // SVG Illustration
                          SvgPicture.asset(
                            'Assets/images/lesson.svg',
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Note-Taking Section
                  if (!controller.isNoteMode.value)
                    Column(
                      children: [
                        // Let's check the lessons button
                        MyButton(
                          text: "Let's check the lessons!",
                          backgroundColor: secondarycolor,
                          textColor: Colors.black,
                          fullWidth: true,
                          onTap: () {
                            // Implement lesson check functionality
                          },
                        ),

                        SizedBox(height: 16),

                        // I want to write a note button
                        MyButton(
                          text: "I want to write a note!",
                          backgroundColor: secondarycolor,
                          textColor: Colors.black,
                          fullWidth: true,
                          onTap: () {
                            controller.toggleNoteMode(true);
                          },
                        ),
                      ],
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Save Note and Close button
                            Row(
                              children: [
                                Expanded(
                                  child: MyButton(
                                    text: "save note",
                                    backgroundColor: secondarycolor,
                                    textColor: Colors.black,
                                    onTap: () {
                                      controller.saveNotes();
                                      controller.toggleNoteMode(false);
                                    },
                                  ),
                                ),
                                SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    controller.toggleNoteMode(false);
                                  },
                                ),
                              ],
                            ),

                            SizedBox(height: 16),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    height:
                                        100, // dibuat lebih tinggi supaya muat beberapa baris
                                    child: MyTextField(
                                      hintText: 'Enter point a',
                                      controller: controller.point1aController,
                                      maxLines:
                                          null,
                                      keyboardType: TextInputType
                                          .multiline, 
                                      onChanged: (value) {
                                       
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )),
    );
  }
}
