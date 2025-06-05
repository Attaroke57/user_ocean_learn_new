import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Page/OtpVerification/OtpController.dart';

class OtpCardWidget extends StatelessWidget {
  final String email;
  final OtpController controller;
  final Function(String) onCompleted;
  final VoidCallback onResend;

  OtpCardWidget({
    Key? key,
    required this.email,
    required this.controller,
    required this.onCompleted,
    required this.onResend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            '6-digit code',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          
          // Subtitle
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.4,
              ),
              children: [
                const TextSpan(text: 'Please enter the code we\'ve sent to\n'),
                TextSpan(
                  text: email,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // OTP Input Fields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              return SizedBox(
                width: 45,
                height: 56,
                child: ValueListenableBuilder<List<String>>(
                  valueListenable: controller.otpNotifier,
                  builder: (context, otpValues, child) {
                    return TextField(
                      controller: controller.textControllers[index],
                      focusNode: controller.focusNodes[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5E7EB),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5E7EB),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF00D4FF),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1.5,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: otpValues[index].isNotEmpty 
                            ? const Color(0xFFF0F9FF) 
                            : Colors.white,
                      ),
                      onChanged: (value) {
                        controller.updateOtp(index, value);
                        if (value.isNotEmpty && index < 5) {
                          controller.focusNodes[index + 1].requestFocus();
                        }
                        if (controller.isComplete) {
                          onCompleted(controller.getOtp());
                        }
                      },
                      onTap: () {
                        // Clear current field when tapped
                        controller.textControllers[index].clear();
                        controller.updateOtp(index, '');
                      },
                    );
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          
          // Error message and resend code
          ValueListenableBuilder<bool>(
            valueListenable: controller.hasErrorNotifier,
            builder: (context, hasError, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasError) ...[
                    const Text(
                      'Incorrect verification code. Please try again.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onResend,
                        child: const Text(
                          'Resend Code in 00:08',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF00D4FF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      // Handle sign in with existing account
                    },
                    child: const Text(
                      'Already have an account? Sign in',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF00D4FF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}