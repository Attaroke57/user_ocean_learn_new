import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:user_ocean_learn/Dashboard/dashboardcontroller.dart';
import 'package:user_ocean_learn/Page/LoginPage/LoginController.dart';
import 'package:user_ocean_learn/Routing/oceab_learn_pages.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

void main() async {
  await GetStorage.init();
  await UserStorage.init();
  Get.put(LoginController());
  Get.put(DashboardController());
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: OceanLearnPages.pages,
      initialRoute: OceanLearnRoutes.splashScreen,

    );
  }
}
