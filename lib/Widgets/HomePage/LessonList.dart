import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Model/course_model.dart';
import 'package:user_ocean_learn/Page/HomePage/Homecontroller.dart';
import 'package:user_ocean_learn/Page/LessonPage/LessonTitle.dart';
import 'package:user_ocean_learn/Services/CourseService.dart';

class LessonList extends StatelessWidget {
  final List<CourseModel> lessons;
  final CourseService courseService;
  final Future<void> Function(int) onRefresh;
  final HomeController controller;

  const LessonList({
    super.key,
    required this.lessons,
    required this.courseService,
    required this.onRefresh,
    required this.controller,
  });

  void _showMembershipDialog(BuildContext context, CourseModel lesson) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.lock_outline, color: Colors.orange.shade600, size: 28),
            const SizedBox(width: 8),
            const Text("Premium Required"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "\"${lesson.title}\" is a premium lesson.",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            const Text(
              "Upgrade to premium to unlock:",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            _buildFeatureItem("🔓 All premium lessons"),
            _buildFeatureItem("📱 Download for offline viewing"),
            _buildFeatureItem("📝 Lesson notes & materials"),
            _buildFeatureItem("🎯 Progress tracking"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child:
                Text("Not Now", style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _navigateToMembershipPage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade600,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Get Premium",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  void _navigateToMembershipPage() {
    Get.snackbar(
      "Premium Upgrade",
      "Redirecting to premium membership...",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.shade100,
      colorText: Colors.orange.shade800,
      duration: const Duration(seconds: 2),
    );
  }

  void _handleLessonTap(BuildContext context, CourseModel lesson) {
    print('Tapped lesson: ${lesson.title}');
    print('Locked: ${lesson.isLocked}');
    print('Visitor: ${controller.isVisitor.value}');
    print('Premium: ${controller.isPremium.value}');
    print('Can access: ${controller.canAccessLesson(lesson)}');
    if (!controller.canAccessLesson(lesson)) {
      _showMembershipDialog(context, lesson);
      return;
    }

    if (lesson.isLocked) {
      Get.snackbar(
        "Coming Soon",
        "This lesson will be available soon!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.shade100,
        colorText: Colors.blue.shade800,
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailPage(
          course: lesson,
          lessonService: courseService,
        ),
      ),
    );
    onRefresh(courseService.currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isVisitor = controller.isVisitor.value;

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          final formattedDate = DateFormat('MMMM d yyyy').format(lesson.date);
          final isLocked = !controller.canAccessLesson(lesson);

          return GestureDetector(
            onTap: isLocked ? null : () => _handleLessonTap(context, lesson),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: isVisitor
                    ? Border.all(color: Colors.orange.shade200, width: 1.5)
                    : null,
              ),
              child: Stack(
                children: [
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isLocked
                                ? Colors.grey.shade200
                                : Colors.lightBlue.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isLocked
                                ? Icons.play_circle_outline
                                : Icons.play_circle_filled,
                            color: isLocked
                                ? Colors.grey.shade400
                                : Colors.lightBlue.shade600,
                            size: 24,
                          ),
                        ),
                        if (isVisitor)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade600,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.lock,
                                  color: Colors.white, size: 12),
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      lesson.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isLocked ? Colors.grey.shade600 : Colors.black,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color: isLocked
                                ? Colors.grey.shade400
                                : Colors.black54,
                          ),
                        ),
                        if (isVisitor) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "PREMIUM",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    trailing: isVisitor
                        ? Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.workspace_premium,
                                color: Colors.orange.shade600, size: 20),
                          )
                        : lesson.isLocked
                            ? Icon(Icons.schedule, color: Colors.grey.shade400)
                            : Icon(Icons.arrow_forward_ios,
                                color: Colors.grey.shade400, size: 16),
                  ),
                  if (isLocked)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(Icons.lock_outline,
                              size: 36, color: Colors.grey),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
