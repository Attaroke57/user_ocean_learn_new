import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Page/OtpVerification/OtpController.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';
import 'package:user_ocean_learn/Services/OtpService.dart';
import 'package:user_ocean_learn/Services/ResendOtpService.dart';
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
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _otpController = OtpController();
  }

  @override
  void dispose() {
    _otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              OtpCardWidget(
                email: widget.email,
                controller: _otpController,
                onCompleted: _handleOtpCompleted,
                onResend: _handleResendCode,
              ),
              const SizedBox(height: 20),
              // ...input password...
              const SizedBox(height: 12),
              // ...input confirm password...
              // Hapus tombol dari sini!
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
      child: Container(
        width: double.infinity,
        height: 56,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              child: const Text(
                "Let's get started",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            );
          },
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

  void _handleResendCode() async {
    // Handle resend code
    final result = await ResendOtpService.resendOtp(widget.email);

    if (result['success']) {
      // Successfully resent OTP
      _otpController.clearOtp();
      _otpController.restartResendCountdown();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification code has been resent'),
          backgroundColor: Color(0xFF00D4FF),
        ),
      );
    } else {
      // Failed to resend OTP
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(result['message'] ?? 'Failed to resend verification code'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
      Get.offAllNamed(OceanLearnRoutes.homePage);
    } else {
      // Gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Verification failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
