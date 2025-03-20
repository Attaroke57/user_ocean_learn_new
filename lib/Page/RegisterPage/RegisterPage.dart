import 'package:flutter/material.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/mybutton.dart';
import 'package:user_ocean_learn/Widgets/mytextfield.dart';
import 'package:user_ocean_learn/Widgets/mycard.dart';
import 'package:user_ocean_learn/Widgets/mytext.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user_ocean_learn/Page/LoginPage/loginpage.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                          onTap: () {
                            // Navigate back to login screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: MyButton(
                          text: "Sign Up",
                          isHeaderStyle: true,
                          isActive: true,
                          backgroundColor: Colors.transparent,
                          textColor: Colors.blue,
                          onTap: () {
                            
                          },
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
                      MyTextField(
                        hintText: "Email",
                        suffixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 30),
                      
                      MyButton(
                        text: "Sign Up",
                        isPrimary: true,
                        backgroundColor: secondarycolor,
                        textColor: textcolor,
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