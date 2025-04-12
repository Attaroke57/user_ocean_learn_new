import 'package:flutter/material.dart';
import 'package:user_ocean_learn/Services/RegisterService.dart';
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
  // Controllers for the text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  // State variables
  bool _isLoading = false;
  String _errorMessage = '';
  bool _obscurePassword = true;

  // Validate form inputs
  bool _validateInputs() {
    setState(() {
      _errorMessage = '';
    });
    
    if (_usernameController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Username cannot be empty';
      });
      return false;
    }
    
    if (_passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Password cannot be empty';
      });
      return false;
    }
    
    if (_emailController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Email cannot be empty';
      });
      return false;
    }
    
    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_emailController.text)) {
      setState(() {
        _errorMessage = 'Please enter a valid email address';
      });
      return false;
    }
    
    return true;
  }

  // Handle the registration process using the separated service
  Future<void> _register() async {
    if (!_validateInputs()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final result = await RegisterService.register(
        _usernameController.text,
        _passwordController.text,
        _emailController.text,
      );
      
      if (result['success']) {
        // Registration successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful! Please login.'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } else {
        // Registration failed
        setState(() {
          _errorMessage = result['message'];
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
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
                if (_errorMessage.isNotEmpty)
                  Container(
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
                            _errorMessage,
                            style: TextStyle(color: Colors.red.shade800),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                MyCard(
                  child: Column(
                    children: [
                      MyTextField(
                        controller: _usernameController,
                        hintText: "username",
                        suffixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: 12),
                      MyTextField(
                        controller: _passwordController,
                        hintText: "password",
                        suffixIcon: _obscurePassword 
                          ? Icons.visibility_outlined 
                          : Icons.visibility_off_outlined,
                        obscureText: _obscurePassword,
                        
                      ),
                      const SizedBox(height: 12),
                      MyTextField(
                        controller: _emailController,
                        hintText: "Email",
                        suffixIcon: Icons.email_outlined,
                      
                      ),
                      const SizedBox(height: 30),
                      
                      _isLoading
                        ? CircularProgressIndicator(color: secondarycolor)
                        : MyButton(
                            text: "Sign Up",
                            isPrimary: true,
                            backgroundColor: secondarycolor,
                            textColor: textcolor,
                            fullWidth: true,
                            onTap: _register,
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