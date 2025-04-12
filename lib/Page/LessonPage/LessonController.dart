import 'package:get/get.dart';


class LessonController extends GetxController {
  // Reactive variables for note-taking
  final RxString point1 = RxString('');
  final RxString point2 = RxString('');
  final RxBool isNoteMode = RxBool(false);

  // Method to toggle note mode
  void toggleNoteMode(bool mode) {
    isNoteMode.value = mode;
  }
  void updatePoint1(String value) {
    point1.value = value;
  }
  void updatePoint2(String value) {
    point2.value = value;
  }


  // Method to save notes
  void saveNotes() {
    // Here you can add logic to save notes
    // For example, sending to a backend or storing locally
    print('Saving notes:');
    print('Point 1: ${point1.value}');
    print('Point 2: ${point2.value}');

    // Reset note mode after saving
    isNoteMode.value = false;
  }

  // Method to clear notes
  
  void clearNotes() {
    point1.value = '';
    point2.value = '';
  }
}

  // Function to save notes (you can implement saving logic here)
 

  // Function to clear notes


