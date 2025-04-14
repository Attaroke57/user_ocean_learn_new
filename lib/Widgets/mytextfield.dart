import 'package:flutter/material.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final bool obscureText;
  final int? maxLines;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final TextEditingController? controller; // This is defined but not used

  const MyTextField({
    Key? key,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.maxLines, // <<< tambahkan ini
    this.keyboardType,
    this.onChanged,
    this.controller,
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
        controller: controller, // Add this line to use the controller
        obscureText: obscureText,
        onChanged: onChanged,
        maxLines: obscureText ? 1 : maxLines, // <<< tambahkan ini
        keyboardType: keyboardType, // Make sure this is included too
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          suffixIcon:
              suffixIcon != null ? Icon(suffixIcon, color: Colors.black) : null,
          prefixIcon:
              prefixIcon != null ? Icon(prefixIcon, color: Colors.black) : null,
        ),
      ),
    );
  }
}
