import 'package:get/get.dart';
import 'package:user_ocean_learn/Page/LessonPage/LessonController.dart';

class LessonBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<LessonController>(() => LessonController());

  }
}