import 'package:get/get.dart';
import 'package:user_ocean_learn/Dashboard/dashboard.dart';
import 'package:user_ocean_learn/Model/course_model.dart';
import 'package:user_ocean_learn/Page/HistoryPage/HistoryPage.dart';
import 'package:user_ocean_learn/Page/HomePage/Homepage.dart';
import 'package:user_ocean_learn/Page/IntroPage/IntroPage.dart';
import 'package:user_ocean_learn/Page/LessonPage/LessonTitle.dart';
import 'package:user_ocean_learn/Page/LessonPage/RoleSelectionPage.dart';
import 'package:user_ocean_learn/Page/LoginPage/LoginPage.dart';
import 'package:user_ocean_learn/Page/OtpVerification/OtpVerificationPage.dart';
import 'package:user_ocean_learn/Page/ProfilePage/ProfilePage.dart';
import 'package:user_ocean_learn/Page/SubscriptionPage/SubscriptionPage.dart';
import 'package:user_ocean_learn/Page/RegisterPage/RegisterPage.dart';
import 'package:user_ocean_learn/Page/SchedulePage/SchedulePage.dart';
import 'package:user_ocean_learn/Page/SplashScreen/SplashScreen.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';
import 'package:user_ocean_learn/Services/CourseService.dart';

class OceanLearnPages {
  static final List<GetPage> pages = [
    //GetPage(name: name, page: page)
    GetPage(name: OceanLearnRoutes.loginPage, page: () => LoginScreen()),
    GetPage(name: OceanLearnRoutes.homePage, page: () => HomePage()),
    GetPage(name: OceanLearnRoutes.dashboard, page: () => NavDrawer()),
    GetPage(name: OceanLearnRoutes.profilePage, page: () => ProfilePage()),
    GetPage(name: OceanLearnRoutes.schedulePage, page: () => SchedulePage()),
    GetPage(name: OceanLearnRoutes.registerScreen, page: () => RegisterScreen()),
    GetPage(name: OceanLearnRoutes.subscriptionPage, page: () => SubscriptionPage()),
    GetPage(name: OceanLearnRoutes.introPage, page: () => IntroPage()),
    GetPage(name: OceanLearnRoutes.splashScreen, page: () => SplashScreen()),
    GetPage(name: OceanLearnRoutes.historypage, page: () => PaymentPage()),
    GetPage(name: OceanLearnRoutes.verificationpage, page: () => OtpVerificationScreen()),
    GetPage(
  name: '/lesson-detail',
  page: () {
    final args = Get.arguments as Map<String, dynamic>;
    return CourseDetailPage(
      course: args['course'],
      lessonService: args['lessonService'],
    );
  },
),
GetPage(name: '/', page: () => RoleSelectionPage()),


      
   
  ];
}
