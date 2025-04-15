import 'package:get/get.dart';
import 'package:user_ocean_learn/Dashboard/dashboard.dart';
import 'package:user_ocean_learn/Page/HomePage/Homepage.dart';
import 'package:user_ocean_learn/Page/IntroPage/IntroPage.dart';
import 'package:user_ocean_learn/Page/LessonPage/LessonTitle.dart';
import 'package:user_ocean_learn/Page/LoginPage/LoginPage.dart';
import 'package:user_ocean_learn/Page/ProfilePage/ProfilePage.dart';
import 'package:user_ocean_learn/Page/ProfilePage/SubscriptionPage.dart';
import 'package:user_ocean_learn/Page/RegisterPage/RegisterPage.dart';
import 'package:user_ocean_learn/Page/SchedulePage/SchedulePage.dart';
import 'package:user_ocean_learn/Page/SplashScreen/SplashScreen.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';

class OceanLearnPages {
  static final List<GetPage> pages = [
    //GetPage(name: name, page: page)
    GetPage(name: OceanLearnRoutes.loginPage, page: () => LoginScreen()),
    GetPage(name: OceanLearnRoutes.homePage, page: () => Homepage()),
    GetPage(name: OceanLearnRoutes.dashboard, page: () => NavDrawer()),
    GetPage(name: OceanLearnRoutes.profilePage, page: () => ProfilePage()),
    GetPage(name: OceanLearnRoutes.schedulePage, page: () => SchedulePage()),
    GetPage(name: OceanLearnRoutes.registerScreen, page: () => RegisterScreen()),
    GetPage(name: OceanLearnRoutes.subscriptionPage, page: () => SubscriptionPage()),
    GetPage(name: OceanLearnRoutes.introPage, page: () => IntroPage()),
    GetPage(name: OceanLearnRoutes.splashScreen, page: () => SplashScreen()),
    GetPage(name: OceanLearnRoutes.lessonTitle, page: () => LessonDetailPage()),
   
  ];
}
