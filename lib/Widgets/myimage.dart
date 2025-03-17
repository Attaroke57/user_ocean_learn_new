import 'package:flutter/material.dart';

// Create a new widget for social icons
class MyImage extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final bool isCircular;
  
  const MyImage({
    Key? key,
    required this.child,
    this.height = 180,
    this.width,
    this.isCircular = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: isCircular ? BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ) : null,
      child: child,
    );
  }
}