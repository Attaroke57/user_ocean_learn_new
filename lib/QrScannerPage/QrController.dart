import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QRController extends GetxController {
  var isLoading = false.obs;

  Future<void> scanAndSendQR(String qrData) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('https://ocean-learn-api.rplrus.com/api/v1/scan'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'qr_data': qrData,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Get.snackbar('Sukses', 'Absensi berhasil!',
            snackPosition: SnackPosition.BOTTOM);
        print('RESPON: $data');
      } else {
        Get.snackbar('Gagal', 'Status: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
