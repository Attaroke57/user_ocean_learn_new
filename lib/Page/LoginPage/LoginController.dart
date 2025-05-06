import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';
import 'package:user_ocean_learn/Services/LoginService.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';


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

      if (token.isNotEmpty) {
        if (rememberMe.value) {
          await UserStorage.saveUserData(
            token: token,
            email: response.accountInfo!.email,
            name: response.accountInfo!.name,
            role: response.accountInfo!.role,
          );
        }
        
        print('Token saved: ${UserStorage.getToken()}');
        Get.offNamed('/home');
      } else {
        _showErrorDialog('Token not found in response');
      }
    } else {
      _showErrorDialog(response.message);
    }
  }

  void logout() async {
  final token = UserStorage.getToken() ?? '';
  print('Token before logout: $token');

  if (token.isNotEmpty) {
    final result = await LoginService.logout(token);
    print('Logout result: $result');

    await UserStorage.clearUserData();

    final success = result['success'] == true; // safer check
    if (success) {
      print('Navigating to: ${OceanLearnRoutes.homePage}');
      Get.offNamed(OceanLearnRoutes.homePage);
    } else {
      final message = result['message'] ?? 'Unknown error during logout';
      _showErrorDialog(message);
    }
  } else {
    print('Token is empty, navigating to login');
    Get.offAllNamed(OceanLearnRoutes.loginPage);
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