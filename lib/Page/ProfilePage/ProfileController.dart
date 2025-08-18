import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:user_ocean_learn/Dashboard/dashboardcontroller.dart';
import 'package:user_ocean_learn/Model/login_service_model.dart';
import 'package:user_ocean_learn/Model/subscribtion_model.dart';
import 'package:user_ocean_learn/Page/LoginPage/LoginController.dart';
import 'package:user_ocean_learn/Page/ProfilePage/EditProfile.dart';
import 'package:user_ocean_learn/Page/SubscriptionPage/SubscriptionPage.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';
import 'package:user_ocean_learn/Services/HistoryService.dart';
import 'package:user_ocean_learn/Services/ProfileService.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';
import 'package:user_ocean_learn/Services/LoginService.dart';

class ProfileController extends GetxController {
  
  final _subscriptionButtonText = 'My Subscription'.obs;
  final _subscriptionButtonColor = secondarycolor.obs;
  final _subscriptionTextColor = primarycolor.obs;
  final _membershipExpiry = Rxn<DateTime>();
  final _isLoading = true.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var avatarUrl = ''.obs;
  var loginResponse = Rxn<LoginResponseModel>();

  String get subscriptionButtonText => _subscriptionButtonText.value;
  Color get subscriptionButtonColor => _subscriptionButtonColor.value;
  Color get subscriptionTextColor => _subscriptionTextColor.value;
  DateTime? get membershipExpiry => _membershipExpiry.value;
  
  var isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    refreshSubscriptionStatus();
    checkSubscription();
    fetchUserProfile();
  }

  void _loadUserData() {
    userName.value = UserStorage.getName() ?? 'User';
    userEmail.value = UserStorage.getEmail() ?? 'email@example.com';
    avatarUrl.value = UserStorage.getAvatarUrl() ?? '';
  }
 Future<void> fetchUserProfile() async {
  try {
    isLoading.value = true;
    final response = await ProfileService.getProfile();

    if (response['success']) {
      final data = response['data'];

      userName.value = data['name'] ?? userName.value;
      userEmail.value = data['email'] ?? userEmail.value;

      final newAvatar = data['avatar'] ?? '';
      if (newAvatar.isNotEmpty) {
        // ✅ Add timestamp to prevent caching
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final avatarWithTimestamp = '$newAvatar?t=$timestamp';
        
        avatarUrl.value = avatarWithTimestamp;
        await UserStorage.saveAvatarUrl(avatarWithTimestamp);
        
        print("✅ Avatar URL updated in fetchUserProfile: $avatarWithTimestamp");
      }

      // ✅ Force UI update
      avatarUrl.refresh();
      update();
      
    } else {
      print("❌ Failed to fetch profile: ${response['message']}");
    }
  } catch (e) {
    print("❌ Error in fetchUserProfile: $e");
  } finally {
    isLoading.value = false;
  }
}
  // ✅ Update method updateProfile di ProfileController
Future<void> updateProfile(String name, {String? avatarPath}) async {
  try {
    isLoading.value = true;
    final response = await ProfileService.updateProfile(
      name: name,
      avatarFile: avatarPath != null ? File(avatarPath) : null,
    );

    if (response['success']) {
      userName.value = name;
      await UserStorage.saveName(name);

      // ✅ Handle avatar URL update properly
      if (response['avatarUrl'] != null && response['avatarUrl'].isNotEmpty) {
        final newAvatarUrl = response['avatarUrl'];
        
        // ✅ Clear old cached image first
        final oldUrl = avatarUrl.value;
        avatarUrl.value = '';
        
        // ✅ Set new URL after small delay to ensure cache is cleared
        await Future.delayed(Duration(milliseconds: 100));
        avatarUrl.value = newAvatarUrl;
        await UserStorage.saveAvatarUrl(newAvatarUrl);
        
        print("✅ Avatar URL updated: $newAvatarUrl");
        print("✅ Old URL was: $oldUrl");
        
        // ✅ Force UI update
        avatarUrl.refresh();
        update();
      }

      Get.snackbar("Success", response['message'] ?? "Profile updated");
      
      // ✅ Fetch fresh profile data to ensure consistency
      await Future.delayed(Duration(milliseconds: 500));
      await fetchUserProfile();
      
    } else {
      Get.snackbar("Error", response['message'] ?? "Update failed");
    }
  } catch (e) {
    print("❌ Error in updateProfile: $e");
    Get.snackbar("Error", "Something went wrong");
  } finally {
    isLoading.value = false;
  }
}

  Future<void> _processSubscriptionFromAPI(Map<String, dynamic> subscription) async {
    try {
      final status = subscription['status'];
      final expirationString = subscription['expiration_date'];

      if (status == 'premium' && expirationString != null) {
        final expiryDate = DateTime.parse(expirationString);
        _membershipExpiry.value = expiryDate;

        // ✅ Simpan ke storage
        await UserStorage.setMembershipExpiry(expiryDate);
        await UserStorage.saveMembershipStatus(status);

        // Refresh DashboardController subscription status
        final dashboardController = Get.find<DashboardController>();
        await dashboardController.refreshSubscriptionStatus();

        final now = DateTime.now();
        if (now.isBefore(expiryDate)) {
          final formatted = DateFormat('dd MMMM yyyy').format(expiryDate);
          _subscriptionButtonText.value = 'Active until $formatted';
          _subscriptionButtonColor.value = Colors.green.shade100;
          _subscriptionTextColor.value = Colors.green.shade800;
        } else {
          _subscriptionButtonText.value = 'Membership Expired - Renew Now';
          _subscriptionButtonColor.value = Colors.red.shade100;
          _subscriptionTextColor.value = Colors.red.shade800;
        }
      } else {
        _subscriptionButtonText.value = 'Get Premium Membership';
        _subscriptionButtonColor.value = secondarycolor;
        _subscriptionTextColor.value = primarycolor;
      }
    } catch (e) {
      print('❌ Error processing subscription: $e');
      throw e;
    }
  }

  Future<void> checkSubscription() async {
  _isLoading.value = true;
  try {
    final sub = UserStorage.getSubscription();
    print('🔥 Loaded subscription from storage: $sub');
    final expiry = await UserStorage.getMembershipExpiry();
    print('📅 Stored expiry date: $expiry');
    final status = UserStorage.getMembershipStatus();
    print('💡 Stored membership status: $status');

    if (sub != null) {
      await _processSubscriptionFromAPI(sub);
    } else {
      await _loadSubscriptionStatusFromHistory();
    }
  } catch (e) {
    print('❌ Gagal checkSubscription: $e');
  } finally {
    _isLoading.value = false;
  }
}


  Future<void> _loadSubscriptionStatusFromHistory() async {
    try {
      final subscriptions = await Historyservice.getSubscriptions();

      if (subscriptions.isNotEmpty) {
        // Include offline payment subscriptions as active
        final activeSubscriptions = subscriptions
            //.where((sub) => sub.detail.paymentMethod != 'offline payment')
            .toList();

        if (activeSubscriptions.isNotEmpty) {
          activeSubscriptions.sort((a, b) => b.date.compareTo(a.date));
          final latest = activeSubscriptions.first;
          final expiryDate = latest.date.add(const Duration(days: 30));

          _membershipExpiry.value = expiryDate;
          await UserStorage.setMembershipExpiry(expiryDate);
          await UserStorage.saveMembershipStatus('premium');

          final now = DateTime.now();
          if (now.isBefore(expiryDate)) {
            final formatted = DateFormat('dd MMMM yyyy').format(expiryDate);
            _subscriptionButtonText.value = 'Active until $formatted';
            _subscriptionButtonColor.value = Colors.green.shade100;
            _subscriptionTextColor.value = Colors.green.shade800;
          } else {
            _subscriptionButtonText.value = 'Membership Expired - Renew Now';
            _subscriptionButtonColor.value = Colors.red.shade100;
            _subscriptionTextColor.value = Colors.red.shade800;
          }
        } else {
          _subscriptionButtonText.value = 'Get Premium Membership';
        }
      } else {
        _subscriptionButtonText.value = 'Get Premium Membership';
      }
    } catch (e) {
      _subscriptionButtonText.value = 'My Subscription';
    }
  }

  void handleSubscriptionButtonTap() async {
    if (_isLoading.value) return;

    final expired = await UserStorage.isMembershipExpired();
    final isPremium = UserStorage.isPremiumUser();

    if (isPremium && !expired) {
      // ❌ Sudah aktif dan belum expired → tombol tidak bisa ditekan
      return;
    }

    if (subscriptionButtonText.contains('until') || subscriptionButtonText.contains('expires today')) {
      showMembershipDetails();
    } else {
      Get.to(() => SubscriptionPage());
    }
  }

  void showMembershipDetails() {
    if (membershipExpiry != null) {
      final remainingDays = membershipExpiry!.difference(DateTime.now()).inDays;
      final formattedDate = DateFormat('dd MMMM yyyy').format(membershipExpiry!);

      Get.defaultDialog(
        title: remainingDays > 0 ? 'Membership Active' : 'Membership Expired',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              remainingDays > 0 ? Icons.check_circle : Icons.warning,
              size: 48,
              color: remainingDays > 0 ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              remainingDays > 0
                  ? 'Your premium membership is active until $formattedDate\n\n$remainingDays days remaining'
                  : 'Your membership expired on $formattedDate',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        confirm: ElevatedButton(
          onPressed: () => Get.back(),
          child: const Text('OK'),
        ),
      );
    }
  }

  void handleEditPersonalDetails() {
  Get.toNamed(OceanLearnRoutes.editProfilePage);
}

// Add this method
void refreshUserData() {
    _loadUserData();
    // Force UI update for GetBuilder
    update();
    // Also trigger reactive updates
    userName.refresh();
    userEmail.refresh();
  }
  
  

  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              final loginController = Get.find<LoginController>();
              loginController.logout();
            },
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }

 Future<void> refreshSubscriptionStatus() async {
  print('ProfileController: refreshSubscriptionStatus called');
  _isLoading.value = true;

  const int maxRetries = 5;
  const Duration retryDelay = Duration(seconds: 3);
  int retryCount = 0;

  while (retryCount < maxRetries) {
    try {
      // Fetch fresh user data from backend
      final response = await LoginService.getAccountInfoWithToken();
      print('ProfileController: full backend response: $response');
      final user = response.accountInfo;
      final subscription = user?.subscription;

      print('ProfileController: subscription data from backend: $subscription');

      if (user != null && subscription != null) {
        final expirationDateRaw = subscription['expiration_date'];
        final expirationDate = expirationDateRaw != null ? DateTime.tryParse(expirationDateRaw) : null;
        final accessLevel = subscription['status'] ?? 'free';

        print('ProfileController: parsed expirationDate: $expirationDate, accessLevel: $accessLevel');

        if (expirationDate != null) {
          // Update UserStorage with fresh data
          await UserStorage.saveUserData(
            token: user.tokens.first.token,
            email: user.email,
            name: user.name,
            role: user.role,
          );
          await UserStorage.saveMembershipStatus(accessLevel);
          await UserStorage.setMembershipExpiry(expirationDate);

          // Process subscription to update UI
          await _processSubscriptionFromAPI(subscription);

          break; // Exit loop on success
        } else {
          print('ProfileController: expiration_date is null or invalid');
          _subscriptionButtonText.value = 'Get Premium Membership';
          _subscriptionButtonColor.value = secondarycolor;
          _subscriptionTextColor.value = primarycolor;
          break;
        }
      } else {
        // Fallback to local storage or history
        final subscriptionLocal = UserStorage.getSubscription();
        if (subscriptionLocal != null && subscriptionLocal.isNotEmpty) {
          await _processSubscriptionFromAPI(subscriptionLocal);
        } else {
          await _loadSubscriptionStatusFromHistory();
        }
        break;
      }
    } catch (e) {
      print('ProfileController: error in refreshSubscriptionStatus: $e');
      if (retryCount == maxRetries - 1) {
        _subscriptionButtonText.value = 'Failed to load status';
        _subscriptionButtonColor.value = Colors.grey.shade300;
        _subscriptionTextColor.value = Colors.black;
      } else {
        print('ProfileController: retrying refreshSubscriptionStatus in $retryDelay');
        await Future.delayed(retryDelay);
      }
    }
    retryCount++;
  }

  _isLoading.value = false;
}
}
