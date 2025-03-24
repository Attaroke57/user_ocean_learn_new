import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Observable variables
  final isRememberMe = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  
  // TextEditing controllers to handle form inputs
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  
  @override
  void onInit() {
    super.onInit();
    // Any initialization code can go here
  }
  
  @override
  void onClose() {
    // Dispose controllers when the controller is closed
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  
  // Method to toggle remember me checkbox
  void toggleRememberMe() {
    isRememberMe.value = !isRememberMe.value;
  }
  
  // Method to handle login
  Future<void> login() async {
    // Reset error message
    errorMessage.value = '';
    
    // Get username and password from controllers
    final username = usernameController.text.trim();
    final password = passwordController.text;
    
    // Validate inputs
    if (username.isEmpty || password.isEmpty) {
      errorMessage.value = 'Please enter both username and password';
      return;
    }
    
    try {
      // Set loading state
      isLoading.value = true;
      
      // TODO: Implement your actual authentication logic here
      // This could be an API call or Firebase authentication
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
      
      // If authentication is successful, navigate to home page
      Get.offAllNamed('/home');
      
    } catch (e) {
      // Handle any errors
      errorMessage.value = 'Failed to login: ${e.toString()}';
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
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
}