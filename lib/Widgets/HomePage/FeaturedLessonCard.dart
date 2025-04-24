import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import 'package:user_ocean_learn/Model/course_model.dart';
import 'package:user_ocean_learn/Page/HomePage/Homecontroller.dart';
import 'package:user_ocean_learn/Page/LessonPage/LessonTitle.dart';
import 'package:user_ocean_learn/Services/CourseService.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/mytextfield.dart';

class FeaturedLessonCard extends StatelessWidget {
  final List<CourseModel> lessons;
  final CourseService courseService;
  final Future<void> Function(int) onRefresh;
  final HomeController controller;


  const FeaturedLessonCard({  
    super.key,
    required this.lessons,
    required this.courseService,
    required this.onRefresh,
    required this.controller,
  });

  @override
Widget build(BuildContext context) {
  final filtered = controller.filteredLessons;
  final hasLesson = lessons.isNotEmpty;
  final title = hasLesson ? lessons.first.title : 'No Lessons Yet';
  final date = hasLesson
      ? DateFormat('MMMM d yyyy').format(lessons.first.date)
      : 'Add your first lesson';
  final imagePath = 'Assets/images/home.svg';

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // ======= CARD LESSON ========
      GestureDetector(
        onTap: hasLesson
            ? () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseDetailPage(
                      course: lessons.first,
                      lessonService: courseService,
                    ),
                  ),
                );
                onRefresh(courseService.currentPage);
              }
            : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              SvgPicture.asset(
                imagePath,
                height: 150,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: hasLesson
                    ? () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseDetailPage(
                              course: lessons.first,
                              lessonService: courseService,
                            ),
                          ),
                        );
                        onRefresh(courseService.currentPage);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue.shade100,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'More Detail..',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 5),
    ],
  );
}
}