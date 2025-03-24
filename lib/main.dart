import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Routing/oceab_learn_pages.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: OceanLearnPages.pages,
      initialRoute: OceanLearnRoutes.SplashScreen,

    );
  }
}