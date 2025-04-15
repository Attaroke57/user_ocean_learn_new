import 'package:flutter/material.dart';
import 'package:user_ocean_learn/Page/LoginPage/LoginController.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/mybutton.dart';
import 'package:user_ocean_learn/Widgets/myimage.dart';
import 'package:user_ocean_learn/Widgets/mytextfield.dart';
import 'package:user_ocean_learn/Widgets/mycard.dart';
import 'package:user_ocean_learn/Widgets/mytext.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSignIn = true; // Track which tab is active
  final LoginController loginController = Get.put(LoginController());
  
  // Create TextEditingController instances to use in the MyTextField widgets
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Add listeners to update the LoginController values when text changes
    _emailController.addListener(() {
      loginController.emailController.text = _emailController.text;
    });
    _passwordController.addListener(() {
      loginController.passwordController.text = _passwordController.text;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: netralcolor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                
                // Header with Sign In/Sign Out buttons
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
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
                          isActive: true,
                          backgroundColor: Colors.transparent,
                          textColor: Colors.blue,
                          onTap: () {
                            // Already on login screen
                          },
                        ),
                      ),
                      Expanded(
                        child: MyButton(
                          text: "Sign Up",
                          isHeaderStyle: true,
                          isActive: false,
                          backgroundColor: Colors.transparent,
                          textColor: Colors.grey.shade400,
                          onTap: () {
                            // Navigate to registration screen
                            Get.toNamed(OceanLearnRoutes.RegisterScreen);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Welcome text
                MyText(
                  text: "Welcome back!",
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800]!,
                ),
                const SizedBox(height: 15),

                SvgPicture.asset(
                  'Assets/images/login.svg',
                  fit: BoxFit.contain,
                  height: 200,
                  width: 120,
                ),
                const SizedBox(height: 30),

                // Login form
                MyCard(
                  child: Column(
                    children: [
                      // Use the local _emailController
                      MyTextField(
                        hintText: "Email",
                        suffixIcon: Icons.email_outlined,
                        controller: _emailController,
                      ),
                      const SizedBox(height: 12),
                      // Use the local _passwordController
                      MyTextField(
                        hintText: "Password",
                        suffixIcon: Icons.lock_outline,
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 12),

                      // Remember me and forgot password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Obx(() => SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: loginController.rememberMe.value,
                                  onChanged: (value) {
                                    loginController.rememberMe.value = value ?? false;
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              )),
                              const SizedBox(width: 8),
                              MyText(
                                text: "Remember me",
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800]!,
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to forgot password screen
                              // Add your navigation code here
                            },
                            child: MyText(
                              text: "Forgot password?",
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: textcolor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Sign in with text
                      Row(
                        children: [
                          Expanded(
                            child: Divider(color: Colors.grey[300]),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: MyText(
                              text: "Sign in with",
                              fontSize: 12,
                              color: Colors.grey[600]!,
                            ),
                          ),
                          Expanded(
                            child: Divider(color: Colors.grey[300]),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Sign in with social media icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyImage(
                            height: 40,
                            width: 40,                         
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'Assets/images/google.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          MyImage(
                            height: 40,
                            width: 40,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'Assets/images/facebook.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                      
                      // Sign In Button - Connected to API login
                      Obx(() => loginController.isLoading.value
                        ? CircularProgressIndicator(color: secondarycolor)
                        : MyButton(
                            text: "Sign In",
                            isPrimary: true,
                            backgroundColor: secondarycolor,
                            textColor: textcolor,
                            fullWidth: true,
                            onTap: () => loginController.login(),
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
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}