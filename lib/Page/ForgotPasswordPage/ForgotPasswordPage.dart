import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Page/ForgotPasswordPage/ForgotPasswordController.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/mybutton.dart';
import 'package:user_ocean_learn/Widgets/mycard.dart';
import 'package:user_ocean_learn/Widgets/mytext.dart';
import 'package:user_ocean_learn/Widgets/mytextfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ForgotPasswordController forgotPasswordController = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: netralcolor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          onPressed: () => Get.back(),
        ),
        title: MyText(
          text: "Forgot Password",
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
              children: [
                const SizedBox(height: 20),

                // Illustration
                SvgPicture.asset(
                  'Assets/images/login.svg', // Make sure you have this asset
                  fit: BoxFit.contain,
                  height: 250,
                  width: double.infinity,
                ),
                const SizedBox(height: 30),

                // Title
                MyText(
                  text: "Forgot Your Password?",
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800]!,
                ),
                const SizedBox(height: 15),

                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MyText(
                    text: "Don't worry! Enter your email address and we'll send you an OTP to reset your password.",
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[600]!,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),

                // Form Card
                MyCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email Label
                      MyText(
                        text: "Email Address",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700]!,
                      ),
                      const SizedBox(height: 8),

                      // Email TextField
                      MyTextField(
                        hintText: "Enter your email address",
                        suffixIcon: Icons.email_outlined,
                        controller: forgotPasswordController.emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 24),

                      // Send OTP Button
                      Obx(() => forgotPasswordController.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(color: secondarycolor),
                          )
                        : MyButton(
                            text: "Send OTP",
                            isPrimary: true,
                            backgroundColor: secondarycolor,
                            textColor: textcolor,
                            fullWidth: true,
                            onTap: () => forgotPasswordController.sendForgotPasswordOTP(),
                          ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Back to Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(
                      text: "Remember your password? ",
                      fontSize: 14,
                      color: Colors.grey[600]!,
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: MyText(
                        text: "Sign In",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: secondarycolor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}