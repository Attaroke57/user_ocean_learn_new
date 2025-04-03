import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Api/LoginApi.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var loginStatus = "".obs;
  var token = "".obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Loginapi _loginService = Loginapi();

  Future<void> login() async {
    isLoading.value = true;
    try {
      final response = await _loginService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (response["status"] == true) {
        loginStatus.value = response["message"];
        token.value = response["token"];
        
        // Navigasi ke HomePage jika login berhasil
        Get.toNamed(OceanLearnRoutes.homePage);

        // Tampilkan pesan sukses
        Get.snackbar("Success", "Login berhasil",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        loginStatus.value = "Login failed";
        Get.snackbar("Error", response["message"] ?? "Login gagal",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      loginStatus.value = "Error: ${e.toString()}";
      Get.snackbar("Error", "Terjadi kesalahan",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
