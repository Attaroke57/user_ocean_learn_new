import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';

class ThankYouButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ThankYouButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: secondarycolor,
          foregroundColor: primarycolor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              color: primarycolor, 
              width: 1,
            ),
          ),
          elevation: 0,
        ),
        child: Text(
          'Thank You!',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}