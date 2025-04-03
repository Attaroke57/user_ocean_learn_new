// my_slider.dart
import 'package:flutter/material.dart';
import 'package:user_ocean_learn/Widgets/colorpallete.dart';
import 'package:user_ocean_learn/Widgets/mytext.dart';

class MySlider extends StatelessWidget {
  final String img;
  final String title;
  final String description;

  const MySlider({
    Key? key,
    required this.img,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 96),
          MyText(
              text: title,
              fontSize: 24,
              color: textcolor,
              textAlign: TextAlign.center),
          SizedBox(height: 24),
          Image.asset(
            img,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 24),
          MyText(
              text: description,
              fontSize: 16,
              color: textcolor,
              textAlign: TextAlign.center)
        ],
      ),
    );
  }
}
