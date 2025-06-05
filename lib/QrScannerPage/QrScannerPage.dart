import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:user_ocean_learn/QrScannerPage/QrController.dart';

class ScanQRPage extends StatefulWidget {
  @override
  State<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  final QRController controller = Get.put(QRController());
  bool hasScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan QR untuk Absen')),
      body: Obx(() => Stack(
            children: [
              MobileScanner(
                controller: MobileScannerController(
                  detectionSpeed: DetectionSpeed.noDuplicates,
                  facing: CameraFacing.back,
                ),
                onDetect: (BarcodeCapture capture) {
                  final String? code = capture.barcodes.first.rawValue;
                  if (code != null && !hasScanned) {
                    hasScanned = true;
                    controller.scanAndSendQR(code).then((_) {
                      // Reset hasScanned agar bisa scan lagi setelah delay
                      Future.delayed(Duration(seconds: 2), () {
                        hasScanned = false;
                      });
                    });
                  }
                },
              ),
              if (controller.isLoading.value)
                Center(child: CircularProgressIndicator()),
            ],
          )),
    );
  }
}
