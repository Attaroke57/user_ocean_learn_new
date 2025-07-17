import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import 'package:user_ocean_learn/Model/course_model.dart';
import 'package:user_ocean_learn/Page/HomePage/Homecontroller.dart';
import 'package:user_ocean_learn/Page/LessonPage/LessonTitle.dart';
import 'package:user_ocean_learn/Services/CourseService.dart';

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

  void _showMembershipDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.lock_outline, color: Colors.orange.shade600, size: 28),
            const SizedBox(width: 8),
            const Text("Premium Access Required"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "This lesson is available for premium members only.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Premium Benefits:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBenefitItem("🔓 Access to all lessons"),
                  _buildBenefitItem("📚 Unlimited course materials"),
                  _buildBenefitItem("💬 Priority support"),
                  _buildBenefitItem("📱 Offline access"),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Maybe Later",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _navigateToMembershipPage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Upgrade Now",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  void _navigateToMembershipPage() {
    Get.snackbar(
      "Coming Soon",
      "Membership upgrade page will be available soon!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.shade100,
      colorText: Colors.orange.shade800,
    );
  }

  void _handleLessonAccess(BuildContext context, CourseModel lesson) async {
    final canAccess = controller.canAccessLesson(lesson);

    if (!canAccess) {
      _showMembershipDialog(context);
      return;
    }

    if (lesson.isLocked && !controller.isPremium.value) {
      Get.snackbar(
        "Coming Soon",
        "This lesson is locked and requires a premium account.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.shade100,
        colorText: Colors.blue.shade800,
      );
      return;
    }

    await Get.to(() => CourseDetailPage(
          course: lesson,
          lessonService: courseService,
        ));

    onRefresh(courseService.currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (lessons.isEmpty) {
        return const Center(child: Text("No featured lesson available."));
      }

      final lesson = lessons.first;
      final isVisitor = controller.isVisitor.value;
      final canAccess = controller.canAccessLesson(lesson);
      final dateFormatted = DateFormat('MMMM d, yyyy').format(lesson.date);
      
      // Debug print
      print('FeaturedCard - isVisitor: $isVisitor, canAccess: $canAccess, membershipStatus: ${controller.membershipStatus.value}');

      return GestureDetector(
        onTap: () => _handleLessonAccess(context, lesson),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Title
              Text(
                lesson.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              // Date
              Text(
                dateFormatted,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Image with lock overlay for visitors
              Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    'Assets/images/home.svg',
                    height: 150,
                  ),
                  // Lock overlay - tampilkan jika visitor ATAU tidak bisa akses
                  if (isVisitor || !canAccess)
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade400,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              // Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _handleLessonAccess(context, lesson),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue.shade100,
                    foregroundColor: Colors.black87,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'More Detail..',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}