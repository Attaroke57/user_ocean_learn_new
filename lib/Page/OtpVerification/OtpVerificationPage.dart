import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Page/OtpVerification/OtpController.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';
import 'package:user_ocean_learn/Services/OtpService.dart';
import 'package:user_ocean_learn/Widgets/OtpVerification/Otpcard.dart';

class OtpVerificationScreen extends StatefulWidget {
final email = Get.arguments['email'] as String;
  
  OtpVerificationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late OtpController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = OtpController();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // OTP Card Widget
              OtpCardWidget(
                email: widget.email,
                controller: _otpController,
                onCompleted: _handleOtpCompleted,
                onResend: _handleResendCode,
              ),
              const Spacer(),
              // Let's get started button
              Container(
                width: double.infinity,
                height: 56,
                margin: const EdgeInsets.only(bottom: 20),
                child: ValueListenableBuilder<bool>(
                  valueListenable: _otpController.isCompleteNotifier,
                  builder: (context, isComplete, child) {
                    return ElevatedButton(
                      onPressed: isComplete ? _handleGetStarted : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00D4FF),
                        disabledBackgroundColor: const Color(0xFFE5F4F7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Let's get started",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isComplete ? Colors.white : Colors.grey[400],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleOtpCompleted(String otp) {
    // Handle OTP completion
    print('OTP Completed: $otp');
    // You can add your verification logic here
  }

  void _handleResendCode() {
    // Handle resend code
    _otpController.clearOtp();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verification code has been resent'),
        backgroundColor: Color(0xFF00D4FF),
      ),
    );
  }

void _handleGetStarted() async {
  final otp = _otpController.getOtp();
  final email = widget.email;

  final result = await OtpService.verifyOtp(email, otp);

  if (result['success']) {
    // Berhasil verifikasi
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verification successful!'),
        backgroundColor: Colors.green,
      ),
    );
    Get.offAllNamed(OceanLearnRoutes.loginPage); 
  } else {
    // Gagal
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message'] ?? 'Verification failed'),
        backgroundColor: Colors.red,
      ),
    );
  }
}}