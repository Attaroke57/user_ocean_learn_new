import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import 'package:user_ocean_learn/Model/course_model.dart';
import 'package:user_ocean_learn/Page/HomePage/HomeController.dart';
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
    final isMembershipExpired = controller.isMembershipExpired.value;

    if (isfree) {
      _showMembershipDialog(context);
      return;
    }

    if (lesson.isLocked && (!isPremium || isMembershipExpired)) {
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
    if (lessons.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "No lessons found",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Obx(() {
      final isfree = controller.isfree.value;
      final isPremium = controller.isPremium.value;
      final isMembershipExpired = controller.isMembershipExpired.value;

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          final dateFormatted = DateFormat('MMMM d, yyyy').format(lesson.date);

          // Logika akses yang benar
          final canAccess = (isPremium && !isMembershipExpired) ||
              (isfree && !lesson.isLocked);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              onTap:
                  canAccess ? () => _handleLessonAccess(context, lesson) : null,
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  // Lesson Image/Icon dengan lock overlay
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: canAccess ? 1.0 : 0.3,
                          child: Icon(
                            Icons.play_circle_outline,
                            size: 30,
                            color: canAccess
                                ? Colors.blue.shade600
                                : Colors.grey.shade400,
                          ),
                        ),
                        if (!canAccess)
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Lesson Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          lesson.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color:
                                canAccess ? Colors.black : Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Date
                        Text(
                          dateFormatted,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Status Badge
                        Row(
                          children: [
                            if (!canAccess) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.lock_outline,
                                      size: 12,
                                      color: Colors.orange.shade600,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Premium',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.orange.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Arrow Icon
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color:
                        canAccess ? Colors.grey.shade400 : Colors.grey.shade300,
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
