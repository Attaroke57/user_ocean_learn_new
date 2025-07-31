import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_ocean_learn/Dashboard/dashboardcontroller.dart';
import 'package:user_ocean_learn/Page/HomePage/HomeController.dart';
import 'package:user_ocean_learn/Page/ProfilePage/ProfileController.dart';
import 'package:user_ocean_learn/Page/SubscriptionPage/SubscriptionPage.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';
import 'package:user_ocean_learn/Services/FirebaseService.dart';
import 'package:user_ocean_learn/Services/LoginService.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';


class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool rememberMe = false.obs;

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Please enter email and password');
      return;
    }

    isLoading.value = true;
    final response = await LoginService.login(email, password);
    isLoading.value = false;

    if (response.status && response.accountInfo != null) {
      final token = response.accountInfo!.tokens.isNotEmpty
          ? response.accountInfo!.tokens[0].token
          : '';

      if (token.isNotEmpty) {
        // Simpan rememberMe status
        await UserStorage.saveRememberMe(rememberMe.value);

        // Simpan user data
        await UserStorage.saveUserData(
          token: token,
          email: response.accountInfo!.email,
          name: response.accountInfo!.name,
          role: response.accountInfo!.role,
        );

        final subscription = response.accountInfo?.subscription;

        // Default: visitor
        String membership = 'visitor';

        // Jika ada subscription info
        if (subscription != null) {
          await UserStorage.saveSubscription(subscription);

        // expired_at
        if (subscription['expired_at'] != null) {
          final expiry = DateTime.tryParse(subscription['expired_at']);
          if (expiry != null) {
            print('Setting membership expiry to: $expiry');
            await UserStorage.setMembershipExpiry(expiry);
          }
        }

          // status membership dari API
          if (subscription['status'] != null) {
            membership = subscription['status'];
          } else {
            // fallback ke role jika tidak ada status
            if (response.accountInfo!.role == 'student') {
              membership = 'basic';
            }
          }
        }

        // Simpan status membership
        await UserStorage.saveMembershipStatus(membership);

        // Jika bukan premium/pro, anggap expired
        if (membership != 'premium' && membership != 'pro') {
          await UserStorage.setMembershipExpiry(
            DateTime.now().subtract(Duration(days: 1)),
          );
        }

        // Load user ke dashboard
        final dashboardController = Get.find<DashboardController>();
        await dashboardController.loadUserData();

        // Refresh membership status and lessons immediately after login
        if (!Get.isRegistered<HomeController>()) {
          Get.lazyPut(() => HomeController());
        }
        final homeController = Get.find<HomeController>();
        await homeController.refreshMembershipStatus();

        // Refresh ProfileController subscription status to update UI immediately
        if (!Get.isRegistered<ProfileController>()) {
          Get.lazyPut(() => ProfileController());
        }
        final profileController = Get.find<ProfileController>();
        await profileController.refreshSubscriptionStatus();

        print('Token saved: ${UserStorage.getToken()}');
        FirebaseService.saveFcmTokenToServer();

        Get.offNamed(OceanLearnRoutes.homePage);
      } else {
        _showErrorDialog('Token not found in response');
      }
    } else {
      _showErrorDialog(response.message);
    }
  }

  void goToSubscriptionPage() {
    Get.to(() => SubscriptionPage());
  }

  Future<void> showSubscriptionInfo() async {
    try {
      final expiry = await UserStorage.getMembershipExpiry();

      if (expiry == null) {
        Get.snackbar(
          'No Membership Info',
          'No membership data found.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (DateTime.now().isBefore(expiry)) {
        final formatted = DateFormat('dd MMMM yyyy').format(expiry);
        Get.defaultDialog(
          title: 'Membership Active',
          content: Text('Your membership is active until $formatted'),
          confirm: ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        );
      } else {
        Get.defaultDialog(
          title: 'Membership Expired',
          content: const Text('Your membership has expired. Please renew.'),
          confirm: ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to check subscription: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void logout() async {
    final token = UserStorage.getToken() ?? '';
    print('Token before logout: $token');

    if (token.isNotEmpty) {
      final result = await LoginService.logout(token);
      print('Logout result: $result');

      await UserStorage.clearUserData();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_level');

      final success = result['success'] == true;
      if (success) {
        print('Navigating to: ${OceanLearnRoutes.homePage}');
        Get.offNamed(OceanLearnRoutes.homePage);
      } else {
        final message = result['message'] ?? 'Unknown error during logout';
        _showErrorDialog(message);
      }
    } else {
      print('Token is empty, navigating to login');
      Get.offAllNamed(OceanLearnRoutes.loginPage);
    }

    Get.offNamed(OceanLearnRoutes.loginPage);
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
