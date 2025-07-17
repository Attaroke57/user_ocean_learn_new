import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:user_ocean_learn/Model/subscribtion_model.dart';
import 'package:user_ocean_learn/Page/LoginPage/LoginController.dart';
import 'package:user_ocean_learn/Page/SubscriptionPage/SubscriptionPage.dart';
import 'package:user_ocean_learn/Services/HistoryService.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

class ProfileController extends GetxController {
  final _subscriptionButtonText = 'My Subscription'.obs;
  final _subscriptionButtonColor = secondarycolor.obs;
  final _subscriptionTextColor = primarycolor.obs;
  final _membershipExpiry = Rxn<DateTime>();
  final _isLoading = true.obs;
  final _userName = 'User'.obs;
  final _userEmail = 'email@example.com'.obs;

  String get subscriptionButtonText => _subscriptionButtonText.value;
  Color get subscriptionButtonColor => _subscriptionButtonColor.value;
  Color get subscriptionTextColor => _subscriptionTextColor.value;
  DateTime? get membershipExpiry => _membershipExpiry.value;
  bool get isLoading => _isLoading.value;
  String get userName => _userName.value;
  String get userEmail => _userEmail.value;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    refreshSubscriptionStatus();
    checkSubscription();
  }

  void _loadUserData() {
    _userName.value = UserStorage.getName() ?? 'User';
    _userEmail.value = UserStorage.getEmail() ?? 'email@example.com';
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
        final activeSubscriptions = subscriptions
            .where((sub) => sub.detail.paymentMethod != 'offline payment')
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

  void handleChangePassword() {
    Get.snackbar('Info', 'Change password feature coming soon!');
  }

  void handleEditPersonalDetails() {
    Get.snackbar('Info', 'Edit personal details feature coming soon!');
  }

  void logout() {
    final loginController = Get.find<LoginController>();
    loginController.logout();
  }

  Future<void> refreshSubscriptionStatus() async {
    _isLoading.value = true;

    try {
      final subscription = UserStorage.getSubscription();

      if (subscription != null && subscription.isNotEmpty) {
        await _processSubscriptionFromAPI(subscription);
      } else {
        await _loadSubscriptionStatusFromHistory();
      }
    } catch (e) {
      _subscriptionButtonText.value = 'Failed to load status';
      _subscriptionButtonColor.value = Colors.grey.shade300;
      _subscriptionTextColor.value = Colors.black;
    }

    _isLoading.value = false;
  }
}
