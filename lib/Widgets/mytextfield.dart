import 'package:flutter/material.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;  // Added this parameter
  final Function(String)? onChanged;  // Added this parameter
  
  const MyTextField({
    Key? key,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.controller,  // Add controller parameter
    this.onChanged,  // Add onChanged parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primarycolor),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: Colors.black)
              : null,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Colors.black)
              : null,
        ),
      ),
    );
  }
}