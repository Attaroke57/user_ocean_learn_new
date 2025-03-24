import 'package:get/get.dart';
import 'package:user_ocean_learn/Page/ProfilePage/ProfileController.dart'; // Adjust import path based on your project structure

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Register the ProfileController
    Get.lazyPut<ProfileController>(() => ProfileController());
    
    // You can add other dependencies that ProfileController might need
    // For example, if you have a UserService:
    // Get.lazyPut<UserService>(() => UserService());
  }
}