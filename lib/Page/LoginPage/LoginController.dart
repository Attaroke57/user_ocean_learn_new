import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/mybutton.dart';
import 'package:user_ocean_learn/Api/LoginApi.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';
import 'package:user_ocean_learn/Services/LoginService.dart';

class LoginController extends GetxController {
  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // Observable variables
  var isLoading = false.obs;
  var loginStatus = "".obs;
  var token = "".obs;
  var errorMessage = "".obs;
  var rememberMe = false.obs;

  final Loginapi _loginService = Loginapi();

  Future<void> login() async {
    // Reset error message
    errorMessage.value = '';
    
    // Validate inputs
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      _showErrorDialog('Please enter email and password');
      return;
    }
    
    isLoading.value = true;
    
    try {
      final response = await _loginService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      
      if (response["status"] == true) {
        loginStatus.value = response["message"];
        token.value = response["token"];
        
        // Save to SharedPreferences if remember me is checked
        if (rememberMe.value) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token.value);
          await prefs.setString('email', emailController.text.trim());
        }
        
        // Navigate to HomePage
        Get.toNamed(OceanLearnRoutes.homePage);

        // Show success message
        Get.snackbar(
          "Success", 
          "Login berhasil",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white
        );
      } else {
        loginStatus.value = "Login failed";
        Get.snackbar(
          "Error", 
          response["message"] ?? "Login gagal",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white
        );
      }
    } catch (e) {
      loginStatus.value = "Error: ${e.toString()}";
      errorMessage.value = 'Failed to login: ${e.toString()}';
      Get.snackbar(
        "Error", 
        "Terjadi kesalahan",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Method to toggle remember me checkbox
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  // Method to show error dialog
  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Okay'),
            onPressed: () => Get.back(),
          )
        ],
      ),
    );
  }

  // Method to handle social media login (Google)
  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      // TODO: Implement Google Sign-In
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed('/home');
    } catch (e) {
      errorMessage.value = 'Google Sign-In failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Method to handle social media login (Facebook)
  Future<void> loginWithFacebook() async {
    try {
      isLoading.value = true;
      // TODO: Implement Facebook Sign-In
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed('/home');
    } catch (e) {
      errorMessage.value = 'Facebook Sign-In failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
  
  // Method to navigate to forgot password screen
  void goToForgotPassword() {
    Get.toNamed('/forgot-password');
  }
  
  // Method to navigate to register screen
  void goToRegister() {
    Get.toNamed('/register');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}