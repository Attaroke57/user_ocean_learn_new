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

  @override
  void onInit() {
  super.onInit();
  // Wait for loadSavedCredentials to complete before validating token
  loadSavedCredentials().then((_) {
    print("Credentials loaded, token value: ${token.value.isNotEmpty ? 'exists' : 'empty'}");
    validateTokenAndAutoLogin();
  });
}

 Future<void> loadSavedCredentials() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    
    // Enhanced logging to debug
    final savedToken = prefs.getString('token');
    final savedEmail = prefs.getString('email');
    final savedRememberMe = prefs.getBool('rememberMe');
    
    print("SharedPreferences contents:");
    print("- token: ${savedToken ?? 'null'}");
    print("- email: ${savedEmail ?? 'null'}");
    print("- rememberMe: ${savedRememberMe ?? 'null'}");
    
    if (savedToken != null && savedToken.isNotEmpty) {
      token.value = savedToken;
      print("Token loaded successfully: ${token.value.substring(0, 5)}..."); // Show first 5 chars
      
      if (savedEmail != null && savedEmail.isNotEmpty) {
        emailController.text = savedEmail;
        print("Email loaded successfully: $savedEmail");
      }
      
      if (savedRememberMe != null) {
        rememberMe.value = savedRememberMe;
        print("Remember me preference loaded: ${rememberMe.value}");
      }
    } else {
      print("No token found in SharedPreferences");
    }
  } catch (e) {
    print("Error loading preferences: $e");
  }
}
  Future<void> validateTokenAndAutoLogin() async {
  if (token.value.isNotEmpty) {
    isLoading.value = true;
    try {
      print("Validating token: ${token.value}");
      final response = await LoginService.validateToken(token.value);
      print("Token validation response: $response");
      
      if (response["status"] == true) {
        // Token valid, langsung ke halaman utama
        print("Token valid, navigating to home");
        Get.offAllNamed(OceanLearnRoutes.homePage);
      } else {
        // Token tidak valid, hapus dari SharedPreferences
        print("Token invalid, clearing credentials");
        clearSavedCredentials();
      }
    } catch (e) {
      print("Token validation error: $e");
      clearSavedCredentials();
    } finally {
      isLoading.value = false;
    }
  } else {
    print("No token found");
  }
}
  Future<void> clearSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('email');
      await prefs.remove('rememberMe');
      token.value = '';
      rememberMe.value = false;
    } catch (e) {
      print("Error clearing preferences: $e");
    }
  }

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
      Get.offAllNamed(OceanLearnRoutes.homePage);
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
        
        // Save to SharedPreferences if remember me is checked
        if (rememberMe.value) {
          saveCredentials(token.value, emailController.text.trim());
        }
        
        Get.snackbar(
          "Success", 
          "Test login berhasil",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white
        );
        
        Future.delayed(Duration(milliseconds: 500), () {
          Get.offAllNamed(OceanLearnRoutes.homePage);
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
          saveCredentials(token.value, emailController.text.trim());
        }
        
        Get.snackbar(
          "Success", 
          "Login berhasil",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white
        );
        
        Future.delayed(Duration(milliseconds: 500), () {
          Get.offAllNamed(OceanLearnRoutes.homePage);
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

  // Helper function to save credentials consistently
  Future<void> saveCredentials(String tokenValue, String emailValue) async {
  try {
    print("Attempting to save credentials:");
    print("- token: ${tokenValue.substring(0, 5)}..."); // Show first 5 chars
    print("- email: $emailValue");
    print("- rememberMe: true");
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', tokenValue);
    await prefs.setString('email', emailValue);
    await prefs.setBool('rememberMe', true);
    
    // Verify the data was saved by reading it back
    final verifyToken = prefs.getString('token');
    final verifyEmail = prefs.getString('email');
    final verifyRememberMe = prefs.getBool('rememberMe');
    
    print("Verification after saving:");
    print("- token: ${verifyToken != null ? 'saved successfully' : 'failed'}");
    print("- email: ${verifyEmail != null ? 'saved successfully' : 'failed'}");
    print("- rememberMe: ${verifyRememberMe != null ? 'saved successfully' : 'failed'}");
  } catch (e) {
    print("Error saving preferences: $e");
  }
}
}