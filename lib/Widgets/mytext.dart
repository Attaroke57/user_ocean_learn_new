import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;

  const MyText({
    Key? key,
    required this.text,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
  }) : super(key: key);

  // Title text style
  factory MyText.title(String text, {Color color = Colors.black}) => MyText(
        text: text,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
      );

  // Subtitle text style
  factory MyText.subtitle(String text, {Color color = Colors.grey}) => MyText(
        text: text,
        fontSize: 14,
        color: color,
      );

  // Header text style
  factory MyText.header(String text) => MyText(
        text: text,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  // Date text style
  factory MyText.date(String text) => MyText(
        text: text,
        fontSize: 14,
        color: Colors.grey,
      );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
