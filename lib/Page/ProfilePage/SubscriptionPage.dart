import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user_ocean_learn/Widgets/mycard.dart';
class SubscriptionPage extends StatelessWidget {
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
                  Text(
                    'Manage your subscription here!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                        child: Text(
                          'Oceans Divers!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Using MyCard for the image section
                      MyCard(
                        child: Center(
                          child: SvgPicture.asset(
                            'Assets/images/login.svg',
                            fit: BoxFit.contain,
                            height: 200,
                            width: 120,
                          ),
                        ),
                      ),

                      SizedBox(height: 24),

                      // Features section
                      Text(
                        'Exclusive Features:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 16),

                      // Feature 1 wrapped in MyCard
                      MyCard(
                        child: _buildFeatureItem(
                          icon: Icons.book_outlined,
                          title: 'Unlimited Class Access',
                          description:
                              'Get full access to all materials & save personal notes.',
                        ),
                      ),

                      SizedBox(height: 16),

                      // Feature 2 wrapped in MyCard
                      MyCard(
                        child: _buildFeatureItem(
                          icon: Icons.alarm,
                          title: 'Smart Reminders & Attendance',
                          description:
                              'Never miss a class, stay on track with friendly reminders!',
                        ),
                      ),

                      SizedBox(height: 16),

                      // Feature 3 wrapped in MyCard
                      MyCard(
                        child: _buildFeatureItem(
                          icon: Icons.question_answer_outlined,
                          title: 'Ask Your Mentor Anything!',
                          description:
                              'Get exclusive Q&A sessions with mentors for deeper learning.',
                        ),
                      ),

                      SizedBox(height: 40),

                      // Price button wrapped in MyCard
                      MyCard(
                        child: GestureDetector(
                          onTap: () {
                            // Subscription purchase functionality would go here
                          },
                          child: Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Color(0xFFD6EEFB),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Rp 150.000 per Month',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade800,
                              ),
                            ),
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
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}