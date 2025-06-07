import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:user_ocean_learn/Model/course_model.dart';
import 'package:user_ocean_learn/Page/QrScannerPage/QrController.dart';
import 'package:user_ocean_learn/Widgets/CoursePage/QrScannerOverlay.dart';


class ScanQRPage extends StatefulWidget {
  
  @override
  State<ScanQRPage> createState() => _ScanQRPageState();
  
}

class _ScanQRPageState extends State<ScanQRPage> {
  final qrController = Get.put(QRController());
  bool isScanned = false;
  MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _resetScanner() {
    setState(() {
      isScanned = false;
    });
    qrController.resetResult();
    cameraController.start();
  }

  void _toggleFlash() {
    cameraController.toggleTorch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on, color: Colors.white),
            onPressed: _toggleFlash,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Fullscreen Camera
          MobileScanner(
            controller: cameraController,
            onDetect: (BarcodeCapture capture) async {
              if (isScanned) return;

              final List<Barcode> barcodes = capture.barcodes;
              final String? code = barcodes.first.rawValue;

              if (code != null) {
                setState(() {
                  isScanned = true;
                });
                
                // Stop camera sementara
                await cameraController.stop();
                
                // Scan QR Code
                await qrController.scanQRCode(code);
              }
            },
          ),
          
          // Overlay dengan scanning frame
          const QrScannerOverlay(
            borderColor: Colors.white,
            borderRadius: 16,
            borderLength: 30,
            borderWidth: 8,
            cutOutSize: 250,
          ),
          
          // Bottom instruction panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Arahkan kamera ke QR Code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'QR Code akan otomatis terdeteksi',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    
                    // Loading indicator saat scanning
                    Obx(() => qrController.isLoading.value
                        ? Column(
                            children: [
                              const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Memproses QR Code...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        : isScanned
                            ? ElevatedButton.icon(
                                onPressed: _resetScanner,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Scan Ulang'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}