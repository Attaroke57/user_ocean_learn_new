import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Page/HomePage/HomePage.dart';
import 'package:user_ocean_learn/Page/LessonPage/LessonTitle.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';
import 'package:user_ocean_learn/Services/CourseService.dart';
import 'package:user_ocean_learn/Services/QrService.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

class QRController extends GetxController {
  var isLoading = false.obs;
  var result = ''.obs;
  
  

  Future<void> scanQRCode(String qrData) async {
    if (!QRService.isValidQRFormat(qrData)) {
      _showErrorSnackbar('QR Code tidak valid');
      return;
    }

    isLoading.value = true;

    final token = UserStorage.getToken() ?? '';

    if (token.isEmpty) {
      _showErrorSnackbar('Token tidak ditemukan. Silakan login ulang.');
      isLoading.value = false;
      return;
    }

    try {
      final response = await QRService.scanQR(qrData, token);

      if (response['success']) {
        result.value = response['message'];
        _showSuccessSnackbar(response['message']);

        // Delay sebentar sebelum navigasi agar snackbar sempat muncul
        await Future.delayed(const Duration(milliseconds: 1500));
        
      } else {
        final errorMessage = response['message'] ?? 'Scan gagal';
        result.value = errorMessage;
        _showErrorSnackbar(errorMessage);
      }
    } catch (e) {
      result.value = 'Terjadi kesalahan saat memproses QR Code';
      _showErrorSnackbar('Terjadi kesalahan saat memproses QR Code');
    }

    isLoading.value = false;
  }

  void resetResult() {
    result.value = '';
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Berhasil!',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(
        Icons.check_circle_outline,
        color: Colors.white,
        size: 24,
      ),
      shouldIconPulse: false,
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
    Get.offNamed(OceanLearnRoutes.homePage);
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error!',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(
        Icons.error_outline,
        color: Colors.white,
        size: 24,
      ),
      shouldIconPulse: false,
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }
}