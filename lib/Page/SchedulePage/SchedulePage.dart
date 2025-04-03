import 'package:flutter/material.dart';
import 'package:user_ocean_learn/Page/SchedulePage/ScheduleController.dart';
import 'package:user_ocean_learn/Widgets/mybutton.dart';
import 'package:user_ocean_learn/Widgets/mycard.dart';
import 'package:user_ocean_learn/Dashboard/dashboard.dart';
import 'package:user_ocean_learn/Widgets/mytext.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatefulWidget {
  final bool isVisitor; // Add this property to determine if user is a visitor
  
  const SchedulePage({
    Key? key,
    this.isVisitor = false, // Default to regular user mode
  }) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Create an instance of the controller
  final ScheduleController _controller = ScheduleController();

  @override
  void initState() {
    super.initState();
    // Load initial data
    _loadData();
  }

  Future<void> _loadData() async {
    await _controller.loadScheduleData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFE8F4FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8F4FB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Here's your schedule Samudra!",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
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
      drawer: NavDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Calendar Card
                _buildCalendar(),
                
                const SizedBox(height: 16),
                
                // Upcoming Lectures with attendance buttons
                ..._buildLectureList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Month navigation
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous month button
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.black),
                    onPressed: () => _controller.previousMonth(
                      isVisitor: widget.isVisitor,
                      onUpdate: () => setState(() {}),
                    ),
                  ),
                  Text(
                    _controller.formattedMonth,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // Next month button
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.black),
                    onPressed: () => _controller.nextMonth(
                      isVisitor: widget.isVisitor,
                      onUpdate: () => setState(() {}),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Weekday headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text('SUN', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('MON', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('TUE', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('WED', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('THU', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('FRI', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('SAT', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Calendar grid - READ ONLY
            for (int row = 0; row < _controller.totalCalendarRows; row++) 
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (col) {
                    final dayIndex = row * 7 + col - _controller.firstWeekdayOfMonth + 1;
                    
                    if (dayIndex < 1 || dayIndex > _controller.lastDayOfMonth) {
                      return const SizedBox(width: 30, height: 30);
                    }
                    
                    final date = DateTime(_controller.selectedMonth.year, _controller.selectedMonth.month, dayIndex);
                    final isHighlighted = _controller.isDateHighlighted(date);
                    
                    // Read-only date cell - no GestureDetector or InkWell
                    return Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isHighlighted ? Colors.blue : Colors.transparent,
                      ),
                      child: Center(
                        child: Text(
                          '$dayIndex',
                          style: TextStyle(
                            color: isHighlighted ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLectureList() {
    // Fixed dates for the lectures based on the image
    final lectureData = [
      {
        'week': '1',
        'title': 'Lecture Title',
        'date': DateTime(2025, 3, 8), // March 8, 2025
      },
      {
        'week': '2',
        'title': 'Lecture Title',
        'date': DateTime(2025, 3, 19), // March 19, 2025
      },
      {
        'week': '3',
        'title': 'Lecture Title',
        'date': DateTime(2025, 3, 24), // March 24, 2025
      },
      {
        'week': '4',
        'title': 'Lecture Title',
        'date': DateTime(2025, 3, 30), // March 30, 2025
      },
    ];

    return lectureData.map((lecture) {
      final formattedDate = DateFormat('MMMM d yyyy').format(lecture['date'] as DateTime);
      return _buildLectureCard(
        week: lecture['week'] as String,
        title: lecture['title'] as String,
        date: lecture['date'] as DateTime,
      );
    }).toList();
  }

  Widget _buildLectureCard({required String week, required String title, required DateTime date}) {
    final formattedDate = DateFormat('MMMM d yyyy').format(date);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Week $week: $title',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Incoming on $formattedDate',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            // Attendance button
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4FB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () {
                  // Mark attendance functionality
                },
                child: const Text(
                  'Mark your attendance',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}