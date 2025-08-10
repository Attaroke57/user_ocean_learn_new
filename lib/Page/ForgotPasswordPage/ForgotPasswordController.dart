import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';
import 'package:user_ocean_learn/Services/LoginService.dart';


class ForgotPasswordController extends GetxController {
  // Text controllers
  final TextEditingController emailController = TextEditingController();
  
  // Observable variables
  final RxBool isLoading = false.obs;
  
  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  // Send forgot password OTP
  Future<void> sendForgotPasswordOTP() async {
    // Validate email
    if (!_validateEmail()) return;

    try {
      isLoading.value = true;
      
      final response = await LoginService.forgotPassword(emailController.text.trim());
      print('Forgot password response status: ${response.status}');
      print('Forgot password response message: ${response.message}');
      print('Forgot password raw response: $response');
      
      // Check if the response status is false but the message indicates success
      if (response.status == true || (response.status == false && response.message != null && response.message!.contains('OTP dikirim'))) {
        // Success - show success message and navigate to OTP verification
        Get.snackbar(
          'Success',
          response.message ?? 'OTP sent successfully to your email',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        
        // Navigate to OTP verification screen with email parameter
       Get.offAllNamed(OceanLearnRoutes.ForgotPasswordVerificationPage, arguments: {'email': emailController.text.trim()});
      } else {
        // Error from API
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to send OTP',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      // Handle any other errors
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      print('Forgot password error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Validate email input
  bool _validateEmail() {
    final email = emailController.text.trim();
    
    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email address',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    return true;
  }

  // Clear form
  void clearForm() {
    emailController.clear();
  }
}