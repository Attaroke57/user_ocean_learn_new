import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LessonController extends GetxController {
  // Lesson information
  final lessonId = ''.obs;
  final lessonTitle = ''.obs;
  final lessonDate = ''.obs;
  final isLoading = false.obs;
  
  // Note mode variables
  var isNoteMode = false.obs;
  var point1a = ''.obs;
  var point1b = ''.obs;
  var point1c = ''.obs;
  var point2a = ''.obs;
  var point2b = ''.obs;
  var point2c = ''.obs;

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
    
    // Load any saved notes for this lesson
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
      point1bController.text = point1b.value;
      point1cController.text = point1c.value;
      point2aController.text = point2a.value;
      point2bController.text = point2b.value;
      point2cController.text = point2c.value;
    }
  }

  void saveNotes() {
    // Save notes from controllers to observable variables
    point1a.value = point1aController.text;
    point1b.value = point1bController.text;
    point1c.value = point1cController.text;
    point2a.value = point2aController.text;
    point2b.value = point2bController.text;
    point2c.value = point2cController.text;
    
    print('Notes Saved for lesson "${lessonTitle.value}":');
    print('Point 1a: ${point1a.value}');
    print('Point 1b: ${point1b.value}');
    print('Point 1c: ${point1c.value}');
    print('Point 2a: ${point2a.value}');
    print('Point 2b: ${point2b.value}');
    print('Point 2c: ${point2c.value}');
    
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
    point1bController.clear();
    point1cController.clear();
    point2aController.clear();
    point2bController.clear();
    point2cController.clear();
    
    // Clear observable variables
    point1a.value = '';
    point1b.value = '';
    point1c.value = '';
    point2a.value = '';
    point2b.value = '';
    point2c.value = '';
    
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
    point1bController.dispose();
    point1cController.dispose();
    point2aController.dispose();
    point2bController.dispose();
    point2cController.dispose();
    super.onClose();
  }
}