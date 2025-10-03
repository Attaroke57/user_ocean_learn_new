// SubscriptionPage.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
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
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 12.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                  Center(
                    child: MyText.header('Manage your subscription here!'),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  padding: EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      MyText(
                        text: 'Oceans Divers!',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 24),

                      // Illustration
                      Center(
                        child: SvgPicture.asset(
                          'Assets/images/subscribe.svg',
                          fit: BoxFit.contain,
                          height: 200,
                          width: double.infinity,
                        ),
                      ),
                      SizedBox(height: 32),

                      // Features section title
                      MyText(
                        text: 'Exclusive Features:',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 20),

                      // Feature 1
                      _buildFeatureItem(
                        icon: Icons.book_outlined,
                        title: 'Unlimited Class Access',
                        description:
                            'Get full access to all materials & save personal notes.',
                      ),
                      SizedBox(height: 20),

                      // Feature 2
                      _buildFeatureItem(
                        icon: Icons.alarm,
                        title: 'Smart Reminders & Attendance',
                        description:
                            'Never miss a class, stay on track with friendly reminders!',
                      ),
                      SizedBox(height: 20),

                      // Feature 3
                      _buildFeatureItem(
                        icon: Icons.question_answer_outlined,
                        title: 'Ask Your Mentor Anything!',
                        description:
                            'Get exclusive Q&A sessions with mentors for deeper learning.',
                      ),
                      SizedBox(height: 40),

                      // Price section
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFFE8F4FD),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: MyText(
                          text: 'Rp 160.000 per Month',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Subscribe Now Button - Modified to show bottom sheet
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _showPaymentBottomSheet(context);
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

  // Modified Bottom Sheet for Payment Options (removed transfer dialog)
  void _showPaymentBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            
            // Title
            MyText(
              text: 'Choose Payment Method',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 24),
            
            // Cash Payment Option
            GestureDetector(
              onTap: () {
                Get.back();
                _subscriptionController.handleCashPayment(context);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.money, color: Colors.green.shade700, size: 24),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: 'Cash Payment',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade800,
                          ),
                          MyText(
                            text: 'Pay directly at our office',
                            fontSize: 12,
                            color: Colors.green.shade600,
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.green.shade600, size: 16),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 12),
            
            // Transfer Payment Option - Modified to only create pending invoice
            GestureDetector(
              onTap: () {
                Get.back();
                _subscriptionController.handleTransferPaymentSimplified(context);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  border: Border.all(color: Colors.orange.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.account_balance, color: Colors.orange.shade700, size: 24),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: 'Bank Transfer',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange.shade800,
                          ),
                          MyText(
                            text: 'Create pending invoice for transfer',
                            fontSize: 12,
                            color: Colors.orange.shade600,
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.orange.shade600, size: 16),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Cancel Button
            TextButton(
              onPressed: () => Get.back(),
              child: MyText(
                text: 'Cancel',
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
          child: Icon(icon, size: 24, color: Colors.grey.shade700),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: title,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 4),
              MyText(
                text: description,
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ],
    );
  }
}