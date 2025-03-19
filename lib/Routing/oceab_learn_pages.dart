
import 'package:get/get.dart';
import 'package:user_ocean_learn/Dashboard/dashboard.dart';
import 'package:user_ocean_learn/Page/HomePage/HomePage.dart';
import 'package:user_ocean_learn/Page/LoginPage/LoginPage.dart';
import 'package:user_ocean_learn/Page/ProfilePage/ProfilePage.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';


class OceanLearnPages {
  static final List<GetPage> pages = [
    //GetPage(name: name, page: page)
    GetPage(name: OceanLearnRoutes.loginPage, page: () => LoginScreen()),
    GetPage(name: OceanLearnRoutes.homePage, page: () => Homepage()),
    GetPage(name: OceanLearnRoutes.dashboard, page: () => NavDrawer()),
    GetPage(name: OceanLearnRoutes.profilepage, page: () => ProfilePage()),
   
  ];
}
