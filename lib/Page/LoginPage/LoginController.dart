import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';
import 'package:user_ocean_learn/Services/LoginService.dart';


class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool rememberMe = false.obs;

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Please enter email and password');
      return;
    }

    isLoading.value = true;

    final response = await LoginService.login(email, password);
    isLoading.value = false;

    if (response.status && response.accountInfo != null) {
      final token = response.accountInfo!.tokens.isNotEmpty
          ? response.accountInfo!.tokens[0].token
          : '';

          final prefs = await SharedPreferences.getInstance();
      if (token.isNotEmpty) {
        if (rememberMe.value) {
          await prefs.setString('token', token);
          await prefs.setString('email', response.accountInfo!.email);
          await prefs.setString('name', response.accountInfo!.name);
          await prefs.setString('role', response.accountInfo!.role); 
        }
      print(prefs.getString('token'));
        Get.offNamed('/home');
      } else {
        _showErrorDialog('Token not found in response');  
      }
    } else {
      _showErrorDialog(response.message);
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isNotEmpty) {
      final result = await LoginService.logout(token);
      await prefs.clear();
      if (result['success']) {
            print(prefs.getString('token'));
        Get.offNamed(OceanLearnRoutes.homePage);

      } else {
        _showErrorDialog(result['message']);
      }
    } else {
      Get.offAllNamed('/');
    }
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}