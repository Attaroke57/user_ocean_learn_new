import 'package:get/get.dart';
import 'package:user_ocean_learn/Dashboard/dashboardcontroller.dart';

class MyBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController() );

}
}