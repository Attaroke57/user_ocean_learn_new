import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import 'package:user_ocean_learn/Model/course_model.dart';
import 'package:user_ocean_learn/Page/HomePage/HomeController.dart';
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
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

  Future<void> _handleLessonAccess(
      BuildContext context, CourseModel lesson) async {
    // Use synchronous check based on observables instead of async canAccessLesson
    final isfree = controller.isfree.value;
    final isPremium = controller.isPremium.value;
    final isExpired = controller.isMembershipExpired.value;

    if (isfree) {
      _showMembershipDialog(context);
      return;
    }

    if (lesson.isLocked && (!isPremium || isExpired)) {
      _showMembershipDialog(context);
      return;
    }

    // Jika bisa akses, navigate ke lesson detail
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
      final isfree = controller.isfree.value;
      final isPremium = controller.isPremium.value;
      final isMembershipExpired = controller.isMembershipExpired.value;
      final dateFormatted = DateFormat('MMMM d, yyyy').format(lesson.date);

      final canAccess =
          (isPremium && !isMembershipExpired) || (isfree && !lesson.isLocked);

// Ganti semua showLockedUI dengan !canAccess
      return Stack(
        children: [
          GestureDetector(
            onTap:
                canAccess ? () => _handleLessonAccess(context, lesson) : null,
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: !canAccess ? Colors.grey.shade600 : Colors.black,
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
                  // Image with lock overlay
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: !canAccess ? 0.3 : 1.0,
                        child: SvgPicture.asset(
                          'Assets/images/home.svg',
                          height: 150,
                        ),
                      ),
                      if (!canAccess)
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade400,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade200,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
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
                      onPressed: canAccess
                          ? () => _handleLessonAccess(context, lesson)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !canAccess
                            ? Colors.grey.shade300
                            : Colors.lightBlue.shade100,
                        foregroundColor:
                            !canAccess ? Colors.grey.shade600 : Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!canAccess) ...[
                            Icon(
                              Icons.lock_outline,
                              size: 18,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            !canAccess ? 'Premium Required' : 'More Detail..',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!canAccess)
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.7),
                child: Center(
                  child: Icon(Icons.lock, size: 48, color: Colors.blue),
                ),
              ),
            ),
        ],
      );
    });
  }
}
