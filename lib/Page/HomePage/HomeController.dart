import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Observable variables
  final isLoading = false.obs;
  final userName = 'Samudra'.obs;
  final lessons = <Lesson>[].obs;
  final featuredLecture = Rx<Lecture?>(null);
  
  // Search functionality
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  
  // Filtered lessons
  List<Lesson> get filteredLessons => searchQuery.isEmpty 
      ? lessons 
      : lessons.where((lesson) => 
          lesson.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  
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
    
    // Set lessons
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
        date: 'March 5 2025',
        iconUrl: 'Assets/images/lesson_icon.png',
      ),
      Lesson(
        id: '3',
        title: 'Building UI with Flutter',
        date: 'March 5 2025',
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
  
  // Method to navigate to lesson details
  void goToLessonDetails(String lessonId) {
    Get.toNamed('/lesson-details', arguments: lessonId);
  }
  
  // Method to navigate to featured lecture details
  void goToFeaturedLectureDetails() {
    if (featuredLecture.value != null) {
      Get.toNamed('/lecture-details', arguments: featuredLecture.value!.id);
    }
  }
  
  // Method to show filter options
  void showFilterOptions() {
    // Implement filter functionality
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
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
              leading: Icon(Icons.calendar_today),
              title: Text('Sort by Date'),
              onTap: () {
                lessons.sort((a, b) => a.date.compareTo(b.date));
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