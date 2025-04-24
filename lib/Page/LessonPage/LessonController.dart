import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Services/LessonService.dart';

class LessonController extends GetxController {
  // Lesson information
  final lessonId = ''.obs;
  final lessonTitle = ''.obs;
  final lessonDate = ''.obs;
  final isLoading = false.obs;
  var lessonVideoUrl = ''.obs;

  Future<void> fetchLessonDetail() async {
    final data = await LessonService.fetchLessonDetail(1);

    if (data != null) {
      lessonTitle.value = data['title'];
      lessonDate.value = data['date'];
      lessonVideoUrl.value = data['video_url'];
    }
  }
  
  // Note mode variables
  var isNoteMode = false.obs;
  var point1a = ''.obs;

  // Text controllers for the text fields
  final TextEditingController point1aController = TextEditingController();
  final TextEditingController point1bController = TextEditingController();
  final TextEditingController point1cController = TextEditingController();
  final TextEditingController point2aController = TextEditingController();
  final TextEditingController point2bController = TextEditingController();
  final TextEditingController point2cController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    
    // Get arguments from navigation
    final Map<String, dynamic> args = Get.arguments ?? {};
    lessonId.value = args['lessonId'] ?? '';
    lessonTitle.value = args['lessonTitle'] ?? 'Lesson Title';
    lessonDate.value = args['lessonDate'] ?? '';
    
    // Debug output
    print('LessonController initialized with:');
    print('ID: ${lessonId.value}');
    print('Title: ${lessonTitle.value}');
    print('Date: ${lessonDate.value}');

    fetchLessonDetail();

    loadSavedNotes();
  }
  
  void loadSavedNotes() {
    // Here you would load saved notes from database or storage
    // For now, we'll just simulate it
    
    isLoading.value = true;
    Future.delayed(Duration(milliseconds: 500), () {
      // For demo purposes, let's just initialize with some example text
      // In a real app, you'd load notes associated with this lessonId
      
      // Uncomment below lines if you want to simulate pre-loaded notes
      /*
      point1a.value = 'Sample note 1a for ${lessonTitle.value}';
      point1b.value = 'Sample note 1b for ${lessonTitle.value}';
      point1c.value = 'Sample note 1c for ${lessonTitle.value}';
      point2a.value = 'Sample note 2a for ${lessonTitle.value}';
      point2b.value = 'Sample note 2b for ${lessonTitle.value}';
      point2c.value = 'Sample note 2c for ${lessonTitle.value}';
      
      // Update controllers to match the loaded values
      point1aController.text = point1a.value;
      point1bController.text = point1b.value;
      point1cController.text = point1c.value;
      point2aController.text = point2a.value;
      point2bController.text = point2b.value;
      point2cController.text = point2c.value;
      */
      
      isLoading.value = false;
    });
  }

  void toggleNoteMode(bool value) {
    isNoteMode.value = value;
    
    // Clear text fields if closing note mode without saving
    if (!value) {
      // Revert text controllers to current saved values
      point1aController.text = point1a.value;
    
    }
  }

  void saveNotes() {
    // Save notes from controllers to observable variables
    point1a.value = point1aController.text;
   
    
    print('Notes Saved for lesson "${lessonTitle.value}":');
    print('Point 1a: ${point1a.value}');
    
    // Here you can add logic to save notes to a database or local storage
    // For example:
    // saveNotesToDatabase(lessonId.value, {
    //   'point1a': point1a.value,
    //   'point1b': point1b.value,
    //   ...
    // });
    
    // Show success message
    Get.snackbar(
      'Success',
      'Notes saved successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[100],
      colorText: Colors.green[800],
      duration: Duration(seconds: 2),
    );
  }

  void clearNotes() {
    // Clear controllers
    point1aController.clear();
    
    // Clear observable variables
    point1a.value = '';
   
    
    // Show success message
    Get.snackbar(
      'Success',
      'Notes cleared',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue[100],
      colorText: Colors.blue[800],
      duration: Duration(seconds: 2),
    );
  }
  
  @override
  void onClose() {
    // Dispose controllers when the controller is closed
    point1aController.dispose();
  
    super.onClose();
  }
}