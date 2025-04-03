import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Page/SplashScreen/SplashController.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  // Initialize the controller
  final SplashScreenController controller = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          netralcolor, // Light blue background color as shown in the image
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'Assets/images/sidebar.png',
              width: 120,
              height: 120,
            ),

            // Alternatively, if you're using a PNG image
            /* 
            Image.asset(
              'Assets/images/logo.png',
              width: 120,
              height: 120,
            ),
            */
          ],
        ),
      ),
    );
  }
}
