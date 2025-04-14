import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Page/RegisterPage/controller.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/mybutton.dart';
import 'package:user_ocean_learn/Widgets/mytextfield.dart';
import 'package:user_ocean_learn/Widgets/mycard.dart';
import 'package:user_ocean_learn/Widgets/mytext.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  
  // Initialize the controller using GetX
  final RegisterController controller = Get.put(RegisterController());
  
  // Using TextEditingControllers instead of initialValue
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    // Set up listeners to sync GetX state with text controllers
    ever(controller.username, (value) {
      if (_usernameController.text != value) {
        _usernameController.text = value;
      }
    });
    
    ever(controller.password, (value) {
      if (_passwordController.text != value) {
        _passwordController.text = value;
      }
    });
    
    ever(controller.email, (value) {
      if (_emailController.text != value) {
        _emailController.text = value;
      }
    });
    
    // Set up listeners to update GetX state when text changes
    _usernameController.addListener(() {
      controller.updateUsername(_usernameController.text);
    });
    
    _passwordController.addListener(() {
      controller.updatePassword(_passwordController.text);
    });
    
    _emailController.addListener(() {
      controller.updateEmail(_emailController.text);
    });
    
    return Scaffold(
      backgroundColor: netralcolor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header with Sign In/Sign Up buttons
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blue.shade100,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: MyButton(
                          text: "Sign In",
                          isHeaderStyle: true,
                          isActive: false,
                          backgroundColor: Colors.transparent,
                          textColor: Colors.grey.shade400,
                          onTap: () => Get.offNamed('/login'),
                        ),
                      ),
                      Expanded(
                        child: MyButton(
                          text: "Sign Up",
                          isHeaderStyle: true,
                          isActive: true,
                          backgroundColor: Colors.transparent,
                          textColor: Colors.blue,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                
                MyText(
                  text: "Nice to meet You!",
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800]!,
                ),
                SizedBox(height: 15),
                
                SvgPicture.asset(
                  'Assets/images/register.svg', 
                  fit: BoxFit.contain,
                  height: 200,
                ),
                SizedBox(height: 30),
                
                // Display error message if there's any
                Obx(() => controller.errorMessage.value.isNotEmpty
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              controller.errorMessage.value,
                              style: TextStyle(color: Colors.red.shade800),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
                ),
                
                MyCard(
                  child: Column(
                    children: [
                      // Username field with controller
                      MyTextField(
                        controller: _usernameController,
                        hintText: "Username",
                        suffixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: 12),
                      
                      // Password field with controller
                      Obx(() => MyTextField(
                        controller: _passwordController,
                        hintText: "Password",
                        obscureText: controller.obscurePassword.value,
                        suffixIcon: controller.obscurePassword.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      )),
                      const SizedBox(height: 12),
                      
                      // Email field with controller
                      MyTextField(
                        controller: _emailController,
                        hintText: "Email",
                        suffixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 30),
                      
                      // Register button
                      Obx(() => controller.isLoading.value
                        ? CircularProgressIndicator(color: secondarycolor)
                        : MyButton(
                            text: "Sign Up",
                            isPrimary: true,
                            backgroundColor: secondarycolor,
                            textColor: textcolor,
                            fullWidth: true,
                            onTap: controller.signUp,
                          ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}