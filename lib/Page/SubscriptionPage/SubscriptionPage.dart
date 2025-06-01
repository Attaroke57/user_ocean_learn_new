// SubscriptionPage.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Widgets/mycard.dart';
import 'package:user_ocean_learn/Widgets/mytext.dart';
import 'package:user_ocean_learn/Page/SubscriptionPage/SubscriptionController.dart';

class SubscriptionPage extends StatelessWidget {
  final SubscriptionController _subscriptionController =
      Get.put(SubscriptionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back),
                  ),
                  MyText.header('Manage your subscription here!'),
                  Icon(Icons.notifications_outlined),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: MyText(
                          text: 'Oceans Divers!',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Using MyCard for images
                      MyCard(
                        child: Center(
                          child: SvgPicture.asset(
                            'Assets/images/subscribe.svg',
                            fit: BoxFit.contain,
                            height: 200,
                            width: 120,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      // Features section
                      MyText(
                        text: 'Exclusive Features:',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 16),
                      // Feature 1
                      MyCard(
                        child: _buildFeatureItem(
                          icon: Icons.book_outlined,
                          title: 'Unlimited Class Access',
                          description:
                              'Get full access to all materials & save personal notes.',
                        ),
                      ),
                      SizedBox(height: 16),
                      // Feature 2
                      MyCard(
                        child: _buildFeatureItem(
                          icon: Icons.alarm,
                          title: 'Smart Reminders & Attendance',
                          description:
                              'Never miss a class, stay on track with friendly reminders!',
                        ),
                      ),
                      SizedBox(height: 16),
                      // Feature 3
                      MyCard(
                        child: _buildFeatureItem(
                          icon: Icons.question_answer_outlined,
                          title: 'Ask Your Mentor Anything!',
                          description:
                              'Get exclusive Q&A sessions with mentors for deeper learning.',
                        ),
                      ),
                      SizedBox(height: 40),
                      // Price and subscription button
                      MyCard(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MyText(
                                text: 'Rp 160.000 per Month',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12),

                              // Subscribe Now Button
                              Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _subscriptionController
                                        .showPaymentOptions();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFD6EEFB),
                                    foregroundColor: Colors.blue.shade800,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: MyText(
                                    text: 'Subscribe Now',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade800,
                                  ),
                                ),
                              ),

                              // Payment Options (Cash & Transfer)
                              Obx(() {
                                if (_subscriptionController
                                    .showPaymentButtons.value) {
                                  return Column(
                                    children: [
                                      SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                _subscriptionController
                                                    .handleCashPayment(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.green.shade100,
                                                foregroundColor:
                                                    Colors.green.shade800,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 24,
                                                    vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: MyText(
                                                text: 'Cash',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.green.shade800,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                _subscriptionController
                                                    .handleTransferPayment(
                                                        context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.orange.shade100,
                                                foregroundColor:
                                                    Colors.orange.shade800,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 24,
                                                    vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: MyText(
                                                text: 'Transfer',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.orange.shade800,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 24),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText.title(title),
              SizedBox(height: 4),
              MyText.subtitle(description),
            ],
          ),
        ),
      ],
    );
  }
}
