import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Page/LessonPage/LessonController.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/mybutton.dart';
import 'package:user_ocean_learn/Widgets/mytext.dart';
import 'package:user_ocean_learn/Widgets/mycard.dart';

class LessonTitle extends StatelessWidget {
  LessonTitle({Key? key}) : super(key: key);

  final LessonController controller = Get.put(LessonController());

  @override
  Widget build(BuildContext context) {
    final String lessonTitle = Get.arguments?['lessonTitle'] ?? 'Lesson Title';
    final String lessonDate = Get.arguments?['lessonDate'] ?? 'March 8 2025';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: MyText(
          text: lessonTitle,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Incoming Class Info
            MyCard(
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
                    child: MyText(
                      text: 'Attendance',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
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
            Obx(() => !controller.isNoteMode.value
                ? Column(
                    children: [
                      MyButton(
                        text: "Let's check the lessons!",
                        backgroundColor: Color(0xFFF0F8FF),
                        textColor: Colors.black,
                        fullWidth: true,
                        height: 50.0, // Added height parameter
                        borderRadius: 12,
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
                        height: 50.0, // Added height parameter
                        borderRadius: 12,
                        onPressed: () {
                          controller.toggleNoteMode(true);
                        },
                        onTap: () {},
                      ),
                    ],
                  )
                : Column(
                    children: [
                      MyCard(
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Point 1:',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(12),
                              ),
                              onChanged: controller.updatePoint1,
                              maxLines: null,
                            ),
                            Divider(),
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Point 2:',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(12),
                              ),
                              onChanged: controller.updatePoint2,
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
                              height: 50.0, // Added height parameter
                              borderRadius: 12,
                              onPressed: () {
                                controller.saveNotes();
                              },
                              onTap: () {},
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              controller.clearNotes();
                            },
                          ),
                        ],
                      ),
                    ],
                  )),
          ],
        ),
      ),
    );
  }
}