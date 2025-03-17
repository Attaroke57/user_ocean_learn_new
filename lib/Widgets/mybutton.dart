import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final Color backgroundColor;
  final Color textColor;
  final bool hasBorder;
  final bool fullWidth;
  final VoidCallback? onPressed;
  final bool isHeaderStyle;
  final bool isActive;
  final VoidCallback onTap; // Keep as required

  const MyButton({
    Key? key,
    required this.text,
    this.isPrimary = false,
    required this.backgroundColor,
    required this.textColor,
    this.hasBorder = false,
    this.fullWidth = false,
    this.onPressed,
    this.isHeaderStyle = false,
    this.isActive = false,
    required this.onTap, // Keep this as required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // For header style buttons (Sign In/Sign Out)
    if (isHeaderStyle) {
      return Expanded(
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: isActive ? Colors.blue.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.blue.shade100,
              width: isActive ? 0 : 1.5,
            ),
          ),
          child: TextButton(
            onPressed: onTap, 
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isActive ? Colors.blue : Colors.grey.shade400,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }

    // Original button style
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onTap, // Use onTap instead of onPressed
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: EdgeInsets.symmetric(
            horizontal: 2,
            vertical: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: hasBorder
                ? BorderSide(color: Colors.grey[300]!)
                : BorderSide.none,
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}