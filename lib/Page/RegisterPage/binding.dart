import 'package:get/get.dart';
import 'package:user_ocean_learn/Page/RegisterPage/controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}