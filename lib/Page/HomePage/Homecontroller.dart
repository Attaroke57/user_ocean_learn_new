import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  // Observable variables
  final isLoading = false.obs;
  final userName = 'Samudra'.obs;
  final lessons = <Lesson>[].obs;
  final featuredLecture = Rx<Lecture?>(null);
  
  // Search functionality
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  
  // Sort order
  final sortOrder = Rx<SortOrder>(SortOrder.none);
  
  // Filtered lessons
  List<Lesson> get filteredLessons {
    List<Lesson> result = searchQuery.isEmpty 
      ? List<Lesson>.from(lessons) 
      : lessons.where((lesson) => 
          lesson.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    
    // Apply sorting based on sortOrder
    switch (sortOrder.value) {
      case SortOrder.newest:
        result.sort((a, b) => _compareDates(b.date, a.date)); // b before a for descending (newest first)
        break;
      case SortOrder.oldest:
        result.sort((a, b) => _compareDates(a.date, b.date)); // a before b for ascending (oldest first)
        break;
      case SortOrder.none:
      default:
        // No sorting applied
        break;
    }
    
    return result;
  }
  
  // Helper method to compare date strings
  int _compareDates(String dateStr1, String dateStr2) {
    try {
      // Try to parse dates like "March 5 2025"
      DateTime? date1 = _parseDate(dateStr1);
      DateTime? date2 = _parseDate(dateStr2);
      
      if (date1 != null && date2 != null) {
        return date1.compareTo(date2);
      }
      
      // Fallback to string comparison if parsing fails
      return dateStr1.compareTo(dateStr2);
    } catch (e) {
      print('Error comparing dates: $e');
      return 0;
    }
  }
  
  // Helper method to parse date strings
  DateTime? _parseDate(String dateStr) {
    try {
      // Try various date formats
      List<String> formats = [
        'MMMM d yyyy', // March 5 2025
        'MMM d yyyy',  // Mar 5 2025
        'yyyy-MM-dd',  // 2025-03-05
      ];
      
      for (String format in formats) {
        try {
          return DateFormat(format).parse(dateStr);
        } catch (_) {
          // Try next format
        }
      }
      
      // If all formats fail, return null
      print('Unable to parse date: $dateStr');
      return null;
    } catch (e) {
      print('Error parsing date: $e');
      return null;
    }
  }
  
  @override
  void onInit() {
    super.onInit();
    // Initialize with dummy data
    loadDummyData();
    
    // Listen to search query changes
    debounce(
      searchQuery,
      (_) => filterLessons(),
      time: const Duration(milliseconds: 500),
    );
  }
  
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
  
  // Method to load dummy data (replace with API calls later)
  void loadDummyData() {
    isLoading.value = true;
    
    // Set featured lecture
    featuredLecture.value = Lecture(
      id: '1',
      title: 'Advanced Flutter Architecture',
      date: 'March 8 2025',
      imageUrl: 'Assets/images/home.svg',
    );
    
    // Set lessons with different dates to demonstrate sorting
    lessons.assignAll([
      Lesson(
        id: '1',
        title: 'Introduction to GetX',
        date: 'March 5 2025',
        iconUrl: 'Assets/images/lesson_icon.png',
      ),
      Lesson(
        id: '2',
        title: 'Flutter State Management',
        date: 'March 10 2025', // newer date
        iconUrl: 'Assets/images/lesson_icon.png',
      ),
      Lesson(
        id: '3',
        title: 'Building UI with Flutter',
        date: 'February 28 2025', // older date
        iconUrl: 'Assets/images/lesson_icon.png',
      ),
      Lesson(
        id: '4',
        title: 'Flutter Animations',
        date: 'April 2 2025', // newest date
        iconUrl: 'Assets/images/lesson_icon.png',
      ),
    ]);
    
    isLoading.value = false;
  }
  
  // Method to filter lessons based on search query
  void filterLessons() {
    // This triggers a rebuild of the UI showing filtered lessons
    // No need to do anything here since we're using a getter
  }
  
  // Method to handle search input changes
  void onSearchChanged(String query) {
    searchQuery.value = query;
  }
  
  // Method to clear search
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }
  
  // Method to clear sorting
  void clearSorting() {
    sortOrder.value = SortOrder.none;
  }
  
  // Method to navigate to lesson details
  void goToLessonDetails(String lessonId) {
    try {
      // Find lesson based on ID
      final lesson = lessons.firstWhere((lesson) => lesson.id == lessonId);
      
      // Debug print for troubleshooting
      print('Navigating to lesson detail with:');
      print('ID: $lessonId');
      print('Title: ${lesson.title}');
      print('Date: ${lesson.date}');
      
      // Navigate to detail page with lesson data
      Get.toNamed('/lesson-detail', arguments: {
        'lessonId': lessonId,
        'lessonTitle': lesson.title,
        'lessonDate': lesson.date,
      });
    } catch (e) {
      print('Error navigating to lesson details: $e');
      Get.snackbar(
        'Error',
        'Could not open lesson details',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }
  
  // Method to navigate to featured lecture details
  void goToFeaturedLectureDetails() {
    if (featuredLecture.value != null) {
      try {
        Get.toNamed('/lecture-detail', arguments: {
          'lectureId': featuredLecture.value!.id,
          'lectureTitle': featuredLecture.value!.title,
          'lectureDate': featuredLecture.value!.date,
        });
      } catch (e) {
        print('Error navigating to lecture details: $e');
        Get.snackbar(
          'Error',
          'Could not open lecture details',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
      }
    }
  }
  
  // Method to show filter options
  void showFilterOptions() {
    // Implement filter functionality
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Filter Options', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.sort),
              title: Text('No Sorting'),
              trailing: sortOrder.value == SortOrder.none ? Icon(Icons.check, color: Colors.green) : null,
              onTap: () {
                sortOrder.value = SortOrder.none;
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.arrow_upward),
              title: Text('Newest First'),
              trailing: sortOrder.value == SortOrder.newest ? Icon(Icons.check, color: Colors.green) : null,
              onTap: () {
                sortOrder.value = SortOrder.newest;
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.arrow_downward),
              title: Text('Oldest First'),
              trailing: sortOrder.value == SortOrder.oldest ? Icon(Icons.check, color: Colors.green) : null,
              onTap: () {
                sortOrder.value = SortOrder.oldest;
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.sort_by_alpha),
              title: Text('Sort by Title'),
              onTap: () {
                lessons.sort((a, b) => a.title.compareTo(b.title));
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Sort order enum
enum SortOrder {
  none,
  newest,
  oldest
}

// Model classes
class Lesson {
  final String id;
  final String title;
  final String date;
  final String iconUrl;
  
  Lesson({
    required this.id,
    required this.title,
    required this.date,
    required this.iconUrl,
  });
}

class Lecture {
  final String id;
  final String title;
  final String date;
  final String imageUrl;
  
  Lecture({
    required this.id,
    required this.title,
    required this.date,
    required this.imageUrl,
  });
}