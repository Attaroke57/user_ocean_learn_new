import 'package:get/get.dart';

class Lessoncontroller extends GetxController {
  // Reactive state for note mode
  var isNoteMode = false.obs;

  // Variables for notes
  var point1 = ''.obs;
  var point2 = ''.obs;

  // Function to toggle note mode
  void toggleNoteMode(bool value) {
    isNoteMode.value = value;
  }

  // Function to update Point 1
  void updatePoint1(String value) {
    point1.value = value;
  }

  // Function to update Point 2
  void updatePoint2(String value) {
    point2.value = value;
  }

  // Function to save notes (you can implement saving logic here)
  void saveNotes() {
    // Logic to save the notes
    print('Note Saved: Point 1 - ${point1.value}, Point 2 - ${point2.value}');
  }

  // Function to clear notes
  void clearNotes() {
    point1.value = '';
    point2.value = '';
  }
}
