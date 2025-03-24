
import 'package:get/get.dart';
import 'package:user_ocean_learn/Dashboard/dashboard.dart';
import 'package:user_ocean_learn/Page/HomePage/HomePage.dart';
import 'package:user_ocean_learn/Page/IntroPage/IntroPage.dart';
import 'package:user_ocean_learn/Page/LoginPage/LoginPage.dart';
import 'package:user_ocean_learn/Page/ProfilePage/ProfilePage.dart';
import 'package:user_ocean_learn/Page/ProfilePage/SubscriptionPage.dart';
import 'package:user_ocean_learn/Page/RegisterPage/RegisterPage.dart';
import 'package:user_ocean_learn/Page/SchedulePage/SchedulePage.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';


class OceanLearnPages {
  static final List<GetPage> pages = [
    //GetPage(name: name, page: page)
    GetPage(name: OceanLearnRoutes.loginPage, page: () => LoginScreen()),
    GetPage(name: OceanLearnRoutes.homePage, page: () => Homepage()),
    GetPage(name: OceanLearnRoutes.dashboard, page: () => NavDrawer()),
    GetPage(name: OceanLearnRoutes.profilepage, page: () => ProfilePage()),
    GetPage(name: OceanLearnRoutes.schedulepage, page: () => SchedulePage()),
    GetPage(name: OceanLearnRoutes.RegisterScreen, page: () => RegisterScreen()),
    GetPage(name: OceanLearnRoutes.SubscriptionPage, page: () => SubscriptionPage()),
    GetPage(name: OceanLearnRoutes.IntroPage, page: () => IntroPage()),
   
  ];
}
