import 'package:get/get.dart';
import 'package:user_ocean_learn/Page/LoginPage/LoginController.dart'; // Adjust import path based on your project structure

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Register the LoginController
    Get.lazyPut<LoginController>(() => LoginController());
    }
}
  