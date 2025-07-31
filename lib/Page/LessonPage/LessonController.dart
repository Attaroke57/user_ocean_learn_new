import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Model/course_model.dart';
import 'package:user_ocean_learn/Services/CourseService.dart';
import 'package:user_ocean_learn/Services/LessonService.dart';

class LessonController extends GetxController {
  // Lesson information
  final lessonId = ''.obs;
  final lessonTitle = ''.obs;
  final lessonDate = ''.obs;
  final isLoading = false.obs;
  var lessonVideoUrl = ''.obs;
  var courses = <CourseModel>[].obs;

  Future<void> loadCourses(String userRole) async {
  final service = CourseService(); // buat instance-nya
  await service.loadLessons(1); // panggil method untuk ambil data dari API
  courses.value = service.getLessons(); // ambil hasilnya
}


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

      
      isLoading.value = false;
    });
  }
  
  @override
  void onClose() {
    super.onClose();
  }
}