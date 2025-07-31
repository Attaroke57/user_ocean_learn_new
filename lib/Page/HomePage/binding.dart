// lib/Page/HomePage/home_binding.dart
import 'package:get/get.dart';
import 'package:user_ocean_learn/Page/HomePage/HomeController.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
