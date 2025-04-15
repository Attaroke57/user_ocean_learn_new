import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // Test function - call this first to see if basic navigation works
  void testNavigation() {
    Get.snackbar(
      "Test", 
      "Testing navigation",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white
    );
    
    Future.delayed(Duration(milliseconds: 500), () {
      Get.toNamed(OceanLearnRoutes.homePage);
    });
  }
  
  // Test function - call this to test with dummy data
  Future<void> testLogin() async {
    isLoading.value = true;
    
    try {
      final response = await LoginService.loginDummy(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      
      if (response["status"] == true) {
        loginStatus.value = response["message"];
        token.value = response["token"];
        
        Get.snackbar(
          "Success", 
          "Test login berhasil",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white
        );
        
        Future.delayed(Duration(milliseconds: 500), () {
          Get.offAll(OceanLearnRoutes.homePage);
        });
      } else {
        Get.snackbar(
          "Error", 
          response["message"] ?? "Test login gagal",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error", 
        "Test error: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Main login function
  Future<void> login() async {
    // Reset error message
    errorMessage.value = '';
    
    // Validate inputs
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      Get.snackbar(
        "Error", 
        "Please enter email and password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
      return;
    }
    
    isLoading.value = true;
    
    try {
      final response = await LoginService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      
      if (response["status"] == true) {
        loginStatus.value = response["message"];
        token.value = response["token"];
        
        // Save to SharedPreferences if remember me is checked
        if (rememberMe.value) {
          try {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', token.value);
            await prefs.setString('email', emailController.text.trim());
          } catch (e) {
            print("Error saving preferences: $e");
          }
        }
        
        Get.snackbar(
          "Success", 
          "Login berhasil",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white
        );
        
        Future.delayed(Duration(milliseconds: 500), () {
          Get.toNamed(OceanLearnRoutes.homePage);
        });
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
        "Terjadi kesalahan: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Other methods remain the same...
}