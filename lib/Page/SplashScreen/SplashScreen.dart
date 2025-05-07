import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _animationController.forward();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkAuthentication();
      }
    });
  }

  Future<void> _checkAuthentication() async {
    final token = UserStorage.getToken();
    final userRole = UserStorage.getRole();
    print('Token from GetStorage: $token');
    print('User role: $userRole');
    await Future.delayed(const Duration(seconds: 1));

    if (token != null && token.isNotEmpty) {
      if (userRole != null && userRole.toLowerCase() == 'admin') {
        Get.offNamed(OceanLearnRoutes.homePage);
      } else {
        await UserStorage.clearUserData();
        Get.offNamed(OceanLearnRoutes.introPage);
      }
    } else {
      Get.offNamed(OceanLearnRoutes.introPage);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: netralcolor,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'Assets/images/ocean.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              Text(
                'Ocean Learn Student',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primarycolor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}