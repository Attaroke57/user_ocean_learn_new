// lib/Widgets/HomePage/ProfileGuideDialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileGuideDialog extends StatelessWidget {
  const ProfileGuideDialog({super.key});

  static void show() {
    Get.dialog(const ProfileGuideDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade600, size: 24),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "How Subscriptions Work",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGuideStep(
                      "1",
                      "Get Subscription",
                      "You can subscribe to access premium content.",
                      Icons.library_books,
                      Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    _buildGuideStep(
                      "2",
                      "Digital Payments",
                      "You can pay using digital payment methods.",
                      Icons.search,
                      Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _buildGuideStep(
                      "3",
                      "Access Levels",
                      "🆓 Free • 🔒 Premium",
                      Icons.security,
                      Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    _buildGuideStep(
                      "4",
                      "Start Learning",
                      "Tap lessons to begin",
                      Icons.play_circle,
                      Colors.purple,
                    ),
                    const SizedBox(height: 16),
                    _buildTipsSection(),
                  ],
                ),
              ),
            ),
            // Action
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Got it!",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideStep(String number, String title, String description, IconData icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$number. $title",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipsSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "💡 Quick Tips:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          const Text("• Pull down to refresh", style: TextStyle(fontSize: 12)),
          const Text("• Use menu (☰) for options", style: TextStyle(fontSize: 12)),
          const Text("• Premium = all content", style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}