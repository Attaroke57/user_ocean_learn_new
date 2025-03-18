import 'package:flutter/material.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/mybutton.dart';
import 'package:user_ocean_learn/Widgets/mycard.dart';
import 'package:user_ocean_learn/Widgets/mytextfield.dart';
import 'package:user_ocean_learn/Widgets/mytext.dart'; // Import MyText widget
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user_ocean_learn/Dashboard/dashboard.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: netralcolor,
      appBar: AppBar(
        backgroundColor: netralcolor,
        elevation: 0,
        title: const MyText(
          text: 'Great to see you here, Samudra!',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              // Implement notifications functionality
            },
          ),
        ],
      ),
      drawer: NavDrawer(), // Using the NavDrawer from dashboard.dart
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Featured lecture card
                MyCard(
                  child: Column(
                    children: [
                      MyText.title('Lecture Title'),
                      SizedBox(height: 4),
                      MyText.date('March 8 2025'),
                      SizedBox(height: 16),

                      SvgPicture.asset(
                        'Assets/images/home.svg',
                        fit: BoxFit.contain,
                        height: 180,
                        width: 120,
                      ),

                      const SizedBox(height: 16),
                    
                      MyButton(
                        text: 'More Detail..',
                        isPrimary: false,
                        backgroundColor: secondarycolor,
                        textColor: Colors.black,
                        onPressed: () {
                         
                        },
                        fullWidth: true,
                        onTap: () {
                          // Implement navigation to lecture details
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Search bar
                Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        hintText: 'Find your lesson',
                        prefixIcon: Icons.search, 
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.filter_list),
                        color: primarycolor,
                        onPressed: () {
                          // Implement filter functionality
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Lesson list
                _buildLessonItem('Lesson Title', 'March 5 2025'),
                const SizedBox(height: 12),
                _buildLessonItem('Lesson Title', 'March 5 2025'),
                const SizedBox(height: 12),
                _buildLessonItem('Lesson Title', 'March 5 2025'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonItem(String title, String date) {
    return MyCard(
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4FB),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText.header(title),
                MyText.date(date),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Implement more options functionality
            },
          ),
        ],
      ),
    );
  }
}