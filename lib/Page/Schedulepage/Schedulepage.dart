import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:user_ocean_learn/Dashboard/dashboard.dart';
import 'package:user_ocean_learn/Page/LessonPage/LessonTitle.dart';
import 'package:user_ocean_learn/Page/Schedulepage/Schedulecontroller.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/SchedulePage/ScheduleCalendar.dart';
import 'package:user_ocean_learn/Widgets/SchedulePage/ScheduleCard.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(ScheduleController());

    return Scaffold(
      backgroundColor: netralcolor,
      appBar: AppBar(
        backgroundColor: netralcolor,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Here Is Your Schedule, ${controller.name.value}!",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
         actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Colors.black),
                onPressed: () {},
              ),
            ],
       
      ),
      drawer: NavDrawer(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadCourses(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                const SizedBox(height: 16),
                CalendarWidget(controller: controller),
                const SizedBox(height: 16),
                _buildLectureSection(controller, context),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLectureSection(
      ScheduleController controller, BuildContext context) {
    return Obx(() {
      final courses = controller.getCoursesForCurrentMonth();

      if (courses.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              "No courses scheduled for this month.\nCourses you create will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              "This Month's Courses",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          ...courses.asMap().entries.map((entry) {
            final index = entry.key;
            final course = entry.value;
            final isPast = controller.isDatePast(course.date);
            final formattedDate = DateFormat('MMMM d yyyy').format(course.date);

            return Padding(
              padding:
                  EdgeInsets.only(bottom: index < courses.length - 1 ? 16 : 0),
              child: ScheduleCard(
                weekNumber: index + 1,
                date: formattedDate,
                isPast: isPast,
                title: course.title,
                isFreeUser: controller.isVisitor.value || !controller.isPremium.value,
                onViewDetails: () {
                  if (controller.isVisitor.value || !controller.isPremium.value) {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Access Denied'),
                        content: const Text('Please upgrade to premium to view course details.'),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetailPage(
                        course: course,
                        lessonService: controller.courseService,
                      ),
                    ),
                  ).then((_) => controller.loadCourses());
                },
              ),
            );
          }).toList(),
        ],
      );
    });
  }
}
