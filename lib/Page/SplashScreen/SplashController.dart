import 'package:get/get.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Start the splash screen timer
    _startSplashScreen();
  }

  // Function to handle splash screen duration and navigation
  void _startSplashScreen() async {
    // Wait for 3 seconds (typical splash screen duration)
    await Future.delayed(Duration(seconds: 3));
    
    // Navigate to the next screen (usually intro or login page)
    // You can add your logic here to determine where to navigate
    // For example, check if user is already logged in

    // Option 1: Navigate to intro page
    Get.offNamed(OceanLearnRoutes.IntroPage);
    
    // Option 2: Navigate directly to login page
    // Get.offNamed(OceanLearnRoutes.loginPage);
    
    // Option 3: Check if user has seen intro and navigate accordingly
    /*
    bool hasSeenIntro = await _checkIfUserHasSeenIntro();
    if (hasSeenIntro) {
      Get.offNamed(OceanLearnRoutes.loginPage);
    } else {
      Get.offNamed(OceanLearnRoutes.introPage);
    }
    */
  }

  // Example function to check if user has seen intro
  Future<bool> _checkIfUserHasSeenIntro() async {
    // Implement your local storage check here
    // For example, using GetStorage or SharedPreferences
    return false; // Default to false (show intro)
  }
}