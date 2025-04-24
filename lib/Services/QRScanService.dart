import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QRScannerPage extends StatelessWidget {
  const QRScannerPage({super.key});
  
  static void openQRScanner(BuildContext context) {
    Get.to(() => const QRScannerPage());
  }

  void sendQRDataToAPI(String qrData) async {
    final url = Uri.parse("https://ocean-learn-api.rplrus.com/api/v1/scan");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer YOUR_TOKEN', // kalau perlu
      },
      body: jsonEncode({"qr_data": qrData}),
    );

    if (response.statusCode == 200) {
      Get.snackbar("Success", "Attendance recorded!");
      Get.back(); // kembali ke halaman sebelumnya
    } else {
      Get.snackbar("Failed", "Error: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan QR Code")),
      body: MobileScanner(
        controller: MobileScannerController(
          facing: CameraFacing.back,
        ),
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;

          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;

            if (code != null) {
              sendQRDataToAPI(code);
            } else {
              Get.snackbar("Scan Error", "QR code tidak terbaca");
            }
          }
        },
      ),
    );
  }
}
