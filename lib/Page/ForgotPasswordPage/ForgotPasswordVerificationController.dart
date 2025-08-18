import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';
import 'package:user_ocean_learn/Services/LoginService.dart';
import 'package:user_ocean_learn/Model/login_service_model.dart';

class ForgotPasswordVerificationController extends GetxController {
  var obscureNewPassword = true.obs;
  var obscureConfirmPassword = true.obs;
  // Controllers untuk input
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newPasswordConfirmationController = TextEditingController();

  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    otpController.dispose();
    newPasswordController.dispose();
    newPasswordConfirmationController.dispose();
    super.onClose();
  }

  Future<void> verifyForgotPassword(String email) async {
    if (!_validateInputs()) return;

    try {
      isLoading.value = true;

      final response = await LoginService.verifyForgotPassword(
        email: email,
        otp: otpController.text.trim(),
        newPassword: newPasswordController.text.trim(),
        newPasswordConfirmation: newPasswordConfirmationController.text.trim(),
      );

      // Check if response is successful or if it contains success message despite status being false
      if (response.status == true || 
          (response.message != null && 
           (response.message!.contains('berhasil') || 
            response.message!.contains('success') || 
            response.message!.contains('Success')))) {
        Get.snackbar(
          'Success',
          response.message ?? 'Password berhasil diubah',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        clearForm();
        Get.offAllNamed(OceanLearnRoutes.loginPage); // Kembali ke halaman login
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Gagal mengubah password',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('Verify forgot password error: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan. Silakan coba lagi.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInputs() {
    if (otpController.text.trim().isEmpty) {
      _showError('Kode OTP tidak boleh kosong');
      return false;
    }
    if (newPasswordController.text.trim().isEmpty) {
      _showError('Password baru tidak boleh kosong');
      return false;
    }
    if (newPasswordConfirmationController.text.trim().isEmpty) {
      _showError('Konfirmasi password baru tidak boleh kosong');
      return false;
    }
    if (newPasswordController.text.trim() != newPasswordConfirmationController.text.trim()) {
      _showError('Password baru dan konfirmasi tidak cocok');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void clearForm() {
    otpController.clear();
    newPasswordController.clear();
    newPasswordConfirmationController.clear();
  }
}
