import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Model/course_model.dart';
import 'package:user_ocean_learn/Services/CourseService.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

class HomeController extends GetxController {
  final CourseService courseService = CourseService();

  var isLoading = true.obs;
  var isLoadingMore = false.obs;
  var isVisitor = false.obs;
  var name = ''.obs;
  var lessons = <CourseModel>[].obs;
  var searchQuery = ''.obs;
  var sortByNewest = true.obs;
  var membershipStatus = 'visitor'.obs;
  var isPremium = false.obs;
  

  List<CourseModel> get filteredLessons {
    var filtered = lessons.where((lesson) =>
        lesson.title.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();

    filtered.sort((a, b) => sortByNewest.value
        ? b.date.compareTo(a.date)
        : a.date.compareTo(b.date));

    return filtered;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void toggleSortOrder() {
    sortByNewest.value = !sortByNewest.value;
  }

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadInitialLessons();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadUserData() async {
    await loadUserName();
    await loadMembershipStatus();
  }

  Future<void> loadMembershipStatus() async {
    final status = UserStorage.getMembershipStatus();
    membershipStatus.value = status;
    isVisitor.value = status == 'visitor';
    isPremium.value = UserStorage.isPremiumUser();
    
    print('Membership Status: $status');
    print('Is Visitor: ${isVisitor.value}');
    print('Is Premium: ${isPremium.value}');
  }

  Future<void> loadUserName() async {
    name.value = UserStorage.getName() ?? 'User';
  }

  Future<void> loadInitialLessons() async {
    isLoading.value = true;
    try {
      await courseService.loadLessons(1);
      final sorted = courseService.getLessons()
        ..sort((a, b) => b.date.compareTo(a.date));
      lessons.assignAll(sorted);
    } catch (e) {
      print('Error loading lessons: $e');
      Get.snackbar(
        'Error',
        'Failed to load lessons. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Method to upgrade user membership
  Future<void> upgradeMembership(String membershipType) async {
    try {
      // Calculate expiry date (30 days from now for example)
      final expiryDate = DateTime.now().add(const Duration(days: 30));
      
      await UserStorage.upgradeToPremium(
        expiryDate: expiryDate,
        membershipType: membershipType,
      );
      
      // Reload membership status
      await loadMembershipStatus();
      
      Get.snackbar(
        'Success!',
        'Welcome to $membershipType membership!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );
      
      // Refresh lessons to show unlocked content
      await loadInitialLessons();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upgrade membership. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Check if user can access premium content
  // bool canAccessPremiumContent() {
    
  //   return isPremium.value && !UserStorage.isMembershipExpired();
  // }

  // Get user access level for display
  String getUserAccessLevelDisplay() {
    if (isVisitor.value) return 'Visitor';
    if (isPremium.value) return 'Premium Member';
    return 'Basic Member';
  }

  // Method to handle lesson access
  bool canAccessLesson(CourseModel lesson) {
  if (isVisitor.value) return false;

  if (lesson.isLocked) {
    return isPremium.value; // Premium user boleh akses yang dikunci
  }

  return true; // Jika tidak locked, semua kecuali visitor boleh
}



  // Refresh membership status (call this after payment success)
  Future<void> refreshMembershipStatus() async {
    await loadMembershipStatus();
    await loadInitialLessons();
  }
}