import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Observable variables for user information
  final userName = "Samudra".obs;
  final userTitle = "Divers".obs;
  final profileImagePath = "Assets/images/profile.png".obs;
  final isSubscribed = false.obs;
  final subscriptionType = "".obs;
  final isLoading = false.obs;
  
  // User personal details
  final email = "samudra@example.com".obs;
  final phone = "+62 812 3456 7890".obs;
  final address = "Jakarta, Indonesia".obs;
  
  @override
  void onInit() {
    super.onInit();
    // Fetch user profile data when controller initializes
    fetchUserData();
  }
  
  // Method to fetch user data from API/database
  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;
      
      // Simulate API call delay
      await Future.delayed(Duration(seconds: 1));
      
      // In a real app, you would fetch data from an API or local storage
      // and then update the observable variables
      userName.value = "Samudra";
      userTitle.value = "Divers";
      isSubscribed.value = true;
      subscriptionType.value = "Premium";
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print("Error fetching user data: $e");
      // You might want to show an error message to the user
    }
  }
  
  // Method to navigate to subscription page
  void goToSubscriptionPage() {
    Get.toNamed('/subscription');
  }
  
  // Method to navigate to change password page
  void goToChangePasswordPage() {
    Get.toNamed('/change-password');
  }
  
  // Method to navigate to edit profile page
  void goToEditProfilePage() {
    Get.toNamed('/edit-profile');
  }
  
  // Method to handle logout
  Future<void> logout() async {
    try {
      isLoading.value = true;
      
      // Simulate API call delay
      await Future.delayed(Duration(seconds: 1));
      
      // Clear user session/token
      // In a real app, you would clear user session data
      
      isLoading.value = false;
      
      // Navigate to login screen
      Get.offAllNamed('/login');
    } catch (e) {
      isLoading.value = false;
      print("Error during logout: $e");
      // You might want to show an error message to the user
    }
  }
  
  // Method to show logout confirmation dialog
  void showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text('Logout Confirmation'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              logout();
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
  
  // Method to update profile picture
  Future<void> updateProfilePicture(String newImagePath) async {
    try {
      isLoading.value = true;
      
      // Simulate API call delay
      await Future.delayed(Duration(seconds: 1));
      
      // Update profile picture path
      profileImagePath.value = newImagePath;
      
      isLoading.value = false;
      
      // Show success message
      Get.snackbar(
        'Success',
        'Profile picture updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isLoading.value = false;
      print("Error updating profile picture: $e");
      // You might want to show an error message to the user
    }
  }
}