import 'package:flutter/material.dart';
import 'package:user_ocean_learn/Widgets/mybutton.dart';
import 'package:user_ocean_learn/Widgets/myimage.dart';
import 'package:user_ocean_learn/Widgets/mytextfield.dart';
import 'package:user_ocean_learn/Widgets/mycard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSignIn = true; // Track which tab is active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blue.shade100,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      MyButton(
                        text: "Sign In",
                        isHeaderStyle: true,
                        isActive: isSignIn,
                        backgroundColor: Colors.transparent,
                        textColor:
                            isSignIn ? Colors.blue : Colors.grey.shade400,
                        onTap: () {
                          setState(() {
                            isSignIn = true;
                          });
                        },
                      ),
                      MyButton(
                        text: "Sign Out",
                        isHeaderStyle: true,
                        isActive: !isSignIn,
                        backgroundColor: Colors.transparent,
                        textColor:
                            !isSignIn ? Colors.blue : Colors.grey.shade400,
                        onTap: () {
                          setState(() {
                            isSignIn = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Welcome text
                Text(
                  "Welcome back!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 15),

                // Illustration
                MyImage(
                  child: Image.asset(
                    'Assets/images/login.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 30),

                // Login form
                MyCard(
                  child: Column(
                    children: [
                      MyTextField(
                        hintText: "username",
                        suffixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: 12),
                      MyTextField(
                        hintText: "password",
                        suffixIcon: Icons.lock_outline,
                        obscureText: true,
                      ),
                      const SizedBox(height: 12),

                      // Remember me and forgot password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: false,
                                  onChanged: (value) {},
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "remember me",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "forgot password?",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
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
                            child: Text(
                              "Sign in with",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: Colors.grey[300]),
                          ),
                        ],
                      ),

                      SizedBox(height: 30),

                      // Sign in with social media icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyImage(
                            height: 40,
                            width: 40,
                            isCircular: true,
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
                            isCircular: true,
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

                      const SizedBox(
                      height: 30), 
                      MyButton(
                        text: "Sign In",
                        isPrimary: true,
                        backgroundColor: Colors.blue[300]!,
                        textColor: Colors.white,
                        fullWidth: true,
                        onTap: () {},
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
