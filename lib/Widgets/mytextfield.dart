import 'package:flutter/material.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final Widget? suffixIcon;   // ⬅ ubah dari IconData? ke Widget?
  final Widget? prefixIcon;   // ⬅ sama biar fleksibel
  final bool obscureText;
  final int? maxLines;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final TextEditingController? controller;

  const MyTextField({
    Key? key,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.maxLines,
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
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        maxLines: obscureText ? 1 : maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          suffixIcon: suffixIcon,   // ⬅ sekarang bisa Icon atau IconButton
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}
