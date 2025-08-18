import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Page/ForgotPasswordPage/ForgotPasswordVerificationController.dart';
import 'package:user_ocean_learn/Widgets/mybutton.dart';
import 'package:user_ocean_learn/Widgets/mytextfield.dart';
import 'package:user_ocean_learn/Widgets/mytext.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';

class ForgotPasswordVerificationPage extends StatelessWidget {
  final ForgotPasswordVerificationController controller = Get.put(ForgotPasswordVerificationController());
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: netralcolor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        
        title: MyText(
          text: "Verify OTP & Reset Password",
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800]!,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Header Section with Animation
                TweenAnimationBuilder(
                  duration: Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24),
                          margin: EdgeInsets.only(bottom: 32),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                secondarycolor.withOpacity(0.1),
                                secondarycolor.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: secondarycolor.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: secondarycolor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.security,
                                  size: 40,
                                  color: secondarycolor,
                                ),
                              ),
                              SizedBox(height: 16),
                              MyText(
                                text: "Security Verification",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800]!,
                              ),
                              SizedBox(height: 8),
                              MyText(
                                text: "Enter the verification code sent to your email and create a new password",
                                fontSize: 14,
                                color: Colors.grey[600]!,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Form Section with Staggered Animation
                ...List.generate(3, (index) {
                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 600 + (index * 100)),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(30 * (1 - value), 0),
                        child: Opacity(
                          opacity: value,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  offset: Offset(0, 4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: _buildTextField(index),
                          ),
                        ),
                      );
                    },
                  );
                }),

                const SizedBox(height: 32),

                // Submit Button with Animation
                TweenAnimationBuilder(
                  duration: Duration(milliseconds: 1000),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: 0.8 + (0.2 * value),
                      child: Opacity(
                        opacity: value,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: secondarycolor.withOpacity(0.3),
                                offset: Offset(0, 8),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: Obx(() => controller.isLoading.value
                              ? Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: secondarycolor.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: textcolor,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        MyText(
                                          text: "Verifying...",
                                          color: textcolor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : MyButton(
                                  text: "Verify & Reset Password",
                                  isPrimary: true,
                                  backgroundColor: secondarycolor,
                                  textColor: textcolor,
                                  fullWidth: true,
                                  onTap: () {
                                    final email = Get.arguments?['email'] ?? '';
                                    if (email.isNotEmpty) {
                                      controller.verifyForgotPassword(email);
                                    } else {
                                      Get.snackbar(
                                        'Error',
                                        'Email not found. Please try again.',
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                    }
                                  },
                                )),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Footer Info with Animation
                TweenAnimationBuilder(
                  duration: Duration(milliseconds: 1200),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue[600],
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: MyText(
                                text: "Check your email for the verification code. It may take a few minutes to arrive.",
                                fontSize: 12,
                                color: Colors.blue[700]!,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(int index) {
    switch (index) {
      case 0:
        return MyTextField(
          hintText: "Enter OTP code",
          suffixIcon: Icon(Icons.send_outlined),
          controller: controller.otpController,
          keyboardType: TextInputType.number,
        );
      case 1:
  return Obx(() => MyTextField(
        hintText: "Enter new password",
        controller: controller.newPasswordController,
        obscureText: controller.obscureNewPassword.value,
        suffixIcon: IconButton(
          icon: Icon(
            controller.obscureNewPassword.value
                ? Icons.visibility_off_outlined // mata tertutup
                : Icons.visibility_outlined,    // mata terbuka
          ),
          onPressed: () {
            controller.obscureNewPassword.value =
                !controller.obscureNewPassword.value;
          },
        ),
      ));

case 2:
  return Obx(() => MyTextField(
        hintText: "Confirm new password",
        controller: controller.newPasswordConfirmationController,
        obscureText: controller.obscureConfirmPassword.value,
        suffixIcon: IconButton(
          icon: Icon(
            controller.obscureConfirmPassword.value
                ? Icons.visibility_off_outlined // mata tertutup
                : Icons.visibility_outlined,    // mata terbuka
          ),
          onPressed: () {
            controller.obscureConfirmPassword.value =
                !controller.obscureConfirmPassword.value;
          },
        ),
      ));

      default:
        return Container();
    }
  }
}