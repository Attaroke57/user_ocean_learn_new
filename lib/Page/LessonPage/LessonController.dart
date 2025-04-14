import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LessonController extends GetxController {
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

  void toggleNoteMode(bool value) {
    isNoteMode.value = value;
    
    // Clear text fields if closing note mode
    if (!value) {
      clearNotes();
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
    
    print('Notes Saved:');
    print('Point 1a: ${point1a.value}');
    print('Point 1b: ${point1b.value}');
    print('Point 1c: ${point1c.value}');
    print('Point 2a: ${point2a.value}');
    print('Point 2b: ${point2b.value}');
    print('Point 2c: ${point2c.value}');
    
    // Here you can add logic to save notes to a database or local storage
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