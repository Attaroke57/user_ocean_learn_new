import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleController {
  // State variables
  DateTime _selectedMonth = DateTime(2025, 3); // Default to March 2025 as shown in the image
  List<DateTime> _highlightedDates = [];

  // Getters
  DateTime get selectedMonth => _selectedMonth;
  List<DateTime> get highlightedDates => _highlightedDates;
  String get formattedMonth => DateFormat('MMMM yyyy').format(_selectedMonth);

  // Calendar data methods
  int get firstWeekdayOfMonth {
    final firstDayOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    return firstDayOfMonth.weekday % 7;
  }

  int get lastDayOfMonth {
    final lastDay = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    return lastDay.day;
  }

  int get totalCalendarDays => lastDayOfMonth + firstWeekdayOfMonth;
  
  int get totalCalendarRows => (totalCalendarDays / 7).ceil();

  // Actions
  void previousMonth({required bool isVisitor, required VoidCallback onUpdate}) {
    if (isVisitor) return; // Prevent navigation for visitors
    
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1, 1);
    onUpdate();
  }

  void nextMonth({required bool isVisitor, required VoidCallback onUpdate}) {
    if (isVisitor) return; // Prevent navigation for visitors
    
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1);
    onUpdate();
  }

  bool isDateHighlighted(DateTime date) {
    return _highlightedDates.any((d) => 
      d.year == date.year && d.month == date.month && d.day == date.day);
  }

  // Method to load or refresh data
  Future<void> loadScheduleData() async {
    // Initialize with the highlighted dates shown in the screenshot
    _highlightedDates = [
      DateTime(2025, 3, 8),  // March 8, 2025
      DateTime(2025, 3, 19), // March 19, 2025
      DateTime(2025, 3, 24), // March 24, 2025
      DateTime(2025, 3, 30), // March 30, 2025
    ];
  }
  
  // Method to get schedule details for a specific date
  Future<Map<String, dynamic>?> getScheduleDetails(DateTime date) async {
    // Check if the date has a scheduled event
    if (isDateHighlighted(date)) {
      int weekNumber = 0;
      
      // Determine week number based on the date
      if (date.day == 8) {
        weekNumber = 1;
      } else if (date.day == 19) {
        weekNumber = 2;
      } else if (date.day == 24) {
        weekNumber = 3;
      } else if (date.day == 30) {
        weekNumber = 4;
      }
      
      return {
        'week': weekNumber,
        'title': 'Lecture Title',
        'date': DateFormat('MMMM d yyyy').format(date),
      };
    }
    return null;
  }
  
  // Method to mark attendance for a lecture
  Future<bool> markAttendance(int weekNumber) async {
    // Implementation would connect to your backend service
    // This is a placeholder that simulates a successful API call
    return true;
  }
}