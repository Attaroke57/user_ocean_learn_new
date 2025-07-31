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
  var isPremium = false.obs; // Pastikan default false!
  var isLoadingUser = true.obs;
  var isMembershipExpired = false.obs;
  var isMembershipLoaded = false.obs; // New observable to indicate membership loaded

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
    // Reload user data from UserStorage to get latest info
    await loadUserName();
    await loadMembershipStatus();

    // Additional: clear and reload lessons to reflect any changes
    lessons.clear();
    await loadInitialLessons();
  }

  Future<void> loadMembershipStatus() async {
    final status = UserStorage.getMembershipStatus();
    membershipStatus.value = status;
    isVisitor.value = status == 'visitor';
    final isPremiumUser = UserStorage.isPremiumUser();
    final expired = await UserStorage.isMembershipExpired();

    // Set isPremium hanya jika user premium dan tidak expired
    isPremium.value = isPremiumUser && !expired;
    isMembershipExpired.value = expired;

    print('Membership Status: $status');
    print('Is Visitor: ${isVisitor.value}');
    print('Is Premium: ${isPremium.value}');
    print('Is Membership Expired: ${isMembershipExpired.value}');

    // Debug: print UserStorage data
    UserStorage.printStorageData();

    // Reload lessons only if membership is active (not expired)
    if (isPremium.value && !isMembershipExpired.value) {
      await loadInitialLessons();
    }

    isMembershipLoaded.value = true; // Set loaded true after status set
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

  // Get user access level for display
  String getUserAccessLevelDisplay() {
    if (isVisitor.value) return 'Visitor';
    if (isPremium.value) return 'Premium Member';
    return 'Basic Member';
  }

  // Method to handle lesson access - PERBAIKAN UTAMA
  Future<bool> canAccessLesson(CourseModel lesson) async {
    if (isVisitor.value) return false;
    // Enforce locking for free users regardless of API flag
    if (!isPremium.value && lesson.isLocked == false) {
      // Treat lesson as locked for free users
      return false;
    }
    if (!lesson.isLocked) return true;
    return isPremium.value; // Tidak perlu cek expired lagi
  }

  // Method untuk cek apakah user bisa akses premium content
  Future<bool> canAccessPremiumContent() async {
    // Use observable instead of async call
    return isPremium.value && !isMembershipExpired.value;
  }

  // Method untuk cek apakah membership expired
  Future<bool> checkMembershipExpired() async {
    return isMembershipExpired.value;
  }

  // Method untuk mendapatkan informasi status akses
  Future<String> getAccessStatusMessage(CourseModel lesson) async {
    if (isVisitor.value) {
      return 'Please register to access lessons';
    }

    if (lesson.isLocked && !isPremium.value) {
      return 'Premium membership required';
    }

    if (lesson.isLocked && isPremium.value && isMembershipExpired.value) {
      return 'Premium membership expired';
    }

    return 'Access granted';
  }

  // Refresh membership status (call this after payment success)
  Future<void> refreshMembershipStatus() async {
    await loadMembershipStatus();
    await loadInitialLessons();
  }

  void checkMembership() async {
  isLoadingUser.value = true;
  try {
    await loadMembershipStatus();
  } catch (e) {
    print('Error checkMembership: $e');
  }
  isLoadingUser.value = false;
}
}
