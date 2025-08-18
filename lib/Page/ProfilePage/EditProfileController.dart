import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_ocean_learn/Page/ProfilePage/ProfileController.dart';
import 'dart:io';
import 'package:user_ocean_learn/Services/ProfileService.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  
  final selectedImage = Rxn<File>();
  final currentAvatarUrl = ''.obs;
  final isLoading = false.obs;
  
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserData();
  }

  void _loadCurrentUserData() {
    nameController.text = UserStorage.getName() ?? '';
    emailController.text = UserStorage.getEmail() ?? '';
    
    // Load current avatar URL if exists
    _loadCurrentAvatar();
  }

  void _loadCurrentAvatar() async {
    try {
      // Try to get current avatar from storage or fetch from API
      final avatarUrl = UserStorage.getAvatarUrl();
      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        currentAvatarUrl.value = avatarUrl;
      } else {
        // If no avatar in storage, try to get from API
        final result = await ProfileService.getProfile();
        if (result['success'] && result['data'] != null) {
          final accountInfo = result['data']['account_info'];
          if (accountInfo['avatar'] != null) {
            final avatarPath = accountInfo['avatar'].toString().replaceFirst(RegExp(r'^/+'), '');
            final fullAvatarUrl = 'https://ocean-learn-api.rplrus.com/storage/$avatarPath';
            currentAvatarUrl.value = fullAvatarUrl;
            await UserStorage.saveAvatarUrl(fullAvatarUrl);
          }
        }
      }
    } catch (e) {
      print('Error loading current avatar: $e');
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> saveProfile() async {
    final name = nameController.text.trim();
    
    // Validation
    if (name.isEmpty) {
      _showErrorSnackbar('Name cannot be empty');
      return;
    }
    
    if (name.length < 2) {
      _showErrorSnackbar('Name must be at least 2 characters long');
      return;
    }
    
    if (name.length > 50) {
      _showErrorSnackbar('Name cannot be more than 50 characters');
      return;
    }

    isLoading.value = true;

    try {
      final result = await ProfileService.updateProfile(
        name: name,
        avatarFile: selectedImage.value,
      );

      if (result['success']) {
        // Update local storage with new data
        await UserStorage.saveUserData(
          token: UserStorage.getToken() ?? '',
          email: emailController.text,
          name: name,
          role: UserStorage.getRole() ?? '',
        );

        // Save avatar URL if provided in response
        if (result['avatarUrl'] != null) {
          await UserStorage.saveAvatarUrl(result['avatarUrl']);
        }

        // Try to update ProfileController if exists
        try {
          if (Get.isRegistered<ProfileController>()) {
            final profileController = Get.find<ProfileController>();
            if (profileController.toString().contains('ProfileController')) {
              profileController.refreshUserData();
            }
          }
        } catch (e) {
          print('ProfileController not found or method not available: $e');
        }

        _showSuccessSnackbar('Profile updated successfully!');

        // Go back to profile page after a short delay
        await Future.delayed(const Duration(milliseconds: 500));
        Get.back();
      } else {
        _showErrorSnackbar(result['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      print('Error updating profile: $e');
      _showErrorSnackbar('Failed to update profile. Please check your internet connection and try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}