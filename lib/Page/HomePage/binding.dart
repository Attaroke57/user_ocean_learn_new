import 'package:get/get.dart';
import 'package:user_ocean_learn/Page/HomePage/HomeController.dart'; // Adjust import path based on your project structure

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Register the HomeController
    Get.lazyPut<HomeController>(() => HomeController());
  }
}