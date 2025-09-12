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
  RxBool isLoggingOut = false.obs; // Tambahkan loading state untuk logout

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
          role: response.accountInfo!.role ?? 'visitor',
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
            if ((response.accountInfo?.role ?? '') == 'student') {
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
      _showErrorDialog('Incorrect password or email');
    }
  }

  Future<void> forgotPassword(String email) async {
    if (email.isEmpty) {
      _showErrorDialog('Please enter your email address');
      return;
    }

    isLoading.value = true;
    final response = await LoginService.forgotPassword(email);
    isLoading.value = false;

    if (response.status) {
      Get.dialog(
        AlertDialog(
          title: const Text('Success'),
          content: Text(response.message),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
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

  // FIXED LOGOUT METHOD
  Future<void> logout() async {
    try {
      isLoggingOut.value = true;
      print('🔄 Starting logout process...');

      final token = UserStorage.getToken();
      print('🔑 Token before logout: ${token ?? "No token found"}');

      // Step 1: Call server logout API (if token exists)
      if (token != null && token.isNotEmpty) {
        try {
          print('🌐 Calling server logout API...');
          final result = await LoginService.logout(token);
          print('📥 Logout API result: $result');
          
          // Check if server logout was successful
          final success = result['success'] == true;
          if (!success) {
            final message = result['message'] ?? 'Server logout failed';
            print('⚠️ Server logout warning: $message');
            // Continue with local cleanup even if server logout fails
          } else {
            print('✅ Server logout successful');
          }
        } catch (e) {
          print('❌ Error calling logout API: $e');
          // Continue with local cleanup even if API call fails
        }
      } else {
        print('⚠️ No token found, skipping server logout');
      }

      // Step 2: Clear all local data
      print('🧹 Clearing local storage...');
      await _clearAllLocalData();

      // Step 3: Reset controllers
      print('🔄 Resetting controllers...');
      await _resetControllers();

      // Step 4: Navigate to login page
      print('🚀 Navigating to login page...');
      Get.offAllNamed(OceanLearnRoutes.loginPage);
      
      print('✅ Logout completed successfully');

    } catch (e) {
      print('❌ Error during logout: $e');
      
      // Even if there's an error, still try to clear data and navigate
      try {
        await _clearAllLocalData();
        Get.offAllNamed(OceanLearnRoutes.loginPage);
      } catch (clearError) {
        print('❌ Critical error during cleanup: $clearError');
      }
      
      _showErrorDialog('Logout failed: $e');
    } finally {
      isLoggingOut.value = false;
    }
  }

  // Helper method to clear all local data
  Future<void> _clearAllLocalData() async {
    try {
      print('🧹 Clearing UserStorage data...');
      await UserStorage.clearUserData();
      
      print('🧹 Clearing SharedPreferences...');
      final prefs = await SharedPreferences.getInstance();
      
      // Clear specific keys
      await prefs.remove('access_level');
      await prefs.remove('membership_expiry');
      await prefs.remove('subscription_status');
      await prefs.remove('subscription_expiration');
      
      // Optional: Clear all preferences if needed
      // await prefs.clear();
      
      print('✅ Local data cleared successfully');
    } catch (e) {
      print('❌ Error clearing local data: $e');
      rethrow;
    }
  }

  // Helper method to reset controllers
  Future<void> _resetControllers() async {
    try {
      // Clear form fields
      emailController.clear();
      passwordController.clear();
      rememberMe.value = false;
      
      // Reset other controllers if they exist
      if (Get.isRegistered<DashboardController>()) {
        final dashboardController = Get.find<DashboardController>();
        // Add any reset methods if available
      }
      
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        // Add any reset methods if available
      }
      
      if (Get.isRegistered<ProfileController>()) {
        final profileController = Get.find<ProfileController>();
        // Add any reset methods if available
      }
      
      print('✅ Controllers reset successfully');
    } catch (e) {
      print('❌ Error resetting controllers: $e');
      // Don't rethrow here, as this is not critical
    }
  }

  // Method untuk emergency logout (jika logout biasa gagal)
  Future<void> forceLogout() async {
    try {
      print('🚨 Force logout initiated...');
      
      await _clearAllLocalData();
      await _resetControllers();
      
      // Force navigation
      Get.offAllNamed(OceanLearnRoutes.loginPage);
      
      Get.snackbar(
        'Logout',
        'Force logout completed',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      
    } catch (e) {
      print('❌ Force logout error: $e');
      _showErrorDialog('Force logout failed: $e');
    }
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