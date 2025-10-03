import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';
import 'package:user_ocean_learn/Services/RegisterService.dart';

class RegisterController extends GetxController {
  // Observable variables for form fields
  final username = ''.obs;
  final password = ''.obs;
  final email = ''.obs;

  // States
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final obscurePassword = true.obs;

  // Form validation
  bool get isValidUsername =>
      username.value.isNotEmpty && username.value.length >= 4;
  bool get isValidPassword =>
      password.value.isNotEmpty && password.value.length >= 6;
  bool get isValidEmail => GetUtils.isEmail(email.value);
  bool get isFormValid => isValidUsername && isValidPassword && isValidEmail;

  // Update methods for text fields
  void updateUsername(String value) {
    username.value = value;
    errorMessage.value = ''; // Clear error message when user types
  }

  void updatePassword(String value) {
    password.value = value;
    errorMessage.value = ''; // Clear error message when user types
  }

  void updateEmail(String value) {
    email.value = value;
    errorMessage.value = ''; // Clear error message when user types
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Validate input fields with specific error messages
  String? validateForm() {
    if (username.value.isEmpty) {
      return 'Username cannot be empty';
    } else if (username.value.length < 4) {
      return 'Username must be at least 4 characters';
    }

    if (password.value.isEmpty) {
      return 'Password cannot be empty';
    } else if (password.value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    if (email.value.isEmpty) {
      return 'Email cannot be empty';
    } else if (!GetUtils.isEmail(email.value)) {
      return 'Please enter a valid email address';
    }

    return null; // No errors
  }

  // Sign up method
  // registercontroller.dart
Future<void> signUp() async {
  final validationError = validateForm();
  if (validationError != null) {
    errorMessage.value = validationError;
    return;
  }

  try {
    isLoading.value = true;
    errorMessage.value = '';
    
    final result = await RegisterService.register(
      username.value,
      password.value,
      email.value,
    );

    if (result != null && result['success'] == true) {
      // Simpan email & password supaya bisa auto login setelah OTP
      Get.offNamed(OceanLearnRoutes.verificationpage, arguments: {
        'email': email.value,
        'password': password.value, // ⬅️ simpan password
      });
    } else {
      errorMessage.value = result['message'];
    }
  } catch (e) {
    errorMessage.value = 'Registration failed: ${e.toString()}';
  } finally {
    isLoading.value = false;
  }
}


  // Clear form fields
  void clearForm() {
    username.value = '';
    password.value = '';
    email.value = '';
    errorMessage.value = '';
  }
}
