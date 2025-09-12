import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_ocean_learn/Dashboard/dashboardcontroller.dart';
import 'package:user_ocean_learn/Model/subscribtion_model.dart';
import 'package:user_ocean_learn/Page/HomePage/HomeController.dart';
import 'package:user_ocean_learn/Page/ProfilePage/ProfileController.dart';
import 'package:user_ocean_learn/Services/HistoryService.dart';
import 'package:user_ocean_learn/Services/LoginService.dart';
import 'package:user_ocean_learn/Services/SubscriptionService.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

class SubscriptionController extends GetxController {
  // Observables
  RxBool showPaymentButtons = false.obs;
  RxBool showTransferDialog = false.obs;
  RxBool isLoading = false.obs;
  Rx<File?> screenshotFile = Rx<File?>(null);
  RxList<SubscriptionModel> subscriptions = <SubscriptionModel>[].obs;

  final ImagePicker _picker = ImagePicker();
  final subscriptionService = SubscriptionService();

  @override
  void onInit() {
    super.onInit();
    loadSubscriptions();
  }

  Future<void> loadSubscriptions() async {
    try {
      isLoading.value = true;
      final result = await Historyservice.getSubscriptions();
      subscriptions.assignAll(result);
    } catch (e) {
      print('❌ Failed to load subscriptions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  DateTime? getMembershipExpiryDate() {
    final paidSubs = subscriptions
        .where((sub) => sub.detail.paymentMethod != 'offline payment')
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    if (paidSubs.isEmpty) return null;
    final expiry = paidSubs.first.date.add(const Duration(days: 30));
    return DateTime.now().isBefore(expiry) ? expiry : null;
  }

  void showPaymentOptions() => showPaymentButtons.value = true;
  void hidePaymentOptions() => showPaymentButtons.value = false;
  void showTransferPaymentDialog() => showTransferDialog.value = true;
  void hideTransferPaymentDialog() {
    showTransferDialog.value = false;
    screenshotFile.value = null;
  }

  Future<void> handleCashPayment(BuildContext context) async {
    try {
      isLoading.value = true;
      bool? confirmed = await _showCashPaymentDialog(context);

      if (confirmed == true) {
        final result = await subscriptionService.payWithCash();

        if (result != null &&
            (result['status'] == 'success' ||
                (result['status']?.toString().startsWith('paid at') ??
                    false))) {
          await UserStorage.saveUserAccessLevel(UserAccessLevel.premium);
          await Get.find<DashboardController>().refreshSubscriptionStatus();
          // Refresh ProfileController subscription status
          final profileController = Get.find<ProfileController>();
          await profileController.refreshSubscriptionStatus();

          // Refresh user data from backend to get latest subscription info
          await refreshUserAfterPayment();

          hidePaymentOptions();

          Get.snackbar('Payment Successful', 'Your cash payment is successful',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green.shade100,
              colorText: Colors.green.shade800,
              icon: Icon(Icons.check_circle, color: Colors.green.shade800));
        } else if (result != null && result['status'] == 'pending') {
          Get.snackbar('Payment Pending',
              result['message'] ?? 'Please pay your pending invoice.',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.orange.shade100,
              colorText: Colors.orange.shade800,
              icon: Icon(Icons.info, color: Colors.orange.shade800));
        } else {
          Get.snackbar(
              'Payment Failed', result?['message'] ?? 'Payment failed.',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red.shade100,
              colorText: Colors.red.shade800,
              icon: Icon(Icons.error, color: Colors.red.shade800));
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Error during cash payment: ${e.toString()}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          icon: Icon(Icons.error, color: Colors.red.shade800));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleTransferPayment(BuildContext context) async {
    try {
      isLoading.value = true;
      showTransferPaymentDialog();
    } catch (e) {
      Get.snackbar('Error', 'Error during transfer: ${e.toString()}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          icon: Icon(Icons.error, color: Colors.red.shade800));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickScreenshot() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        final file = File(image.path);
        final fileSizeMB = await file.length() / (1024 * 1024);

        if (fileSizeMB > 5) {
          Get.snackbar('File Too Large', 'Max 5MB allowed',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.orange.shade100,
              colorText: Colors.orange.shade800,
              icon: Icon(Icons.warning, color: Colors.orange.shade800));
          return;
        }

        screenshotFile.value = file;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: ${e.toString()}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          icon: Icon(Icons.error, color: Colors.red.shade800));
    }
  }

  Future<void> submitTransferProof() async {
    final dashboardController = Get.find<DashboardController>();
    await dashboardController.loadUserData();
    if (screenshotFile.value == null) {
      Get.snackbar('No Image', 'Please upload screenshot first',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          icon: Icon(Icons.error, color: Colors.red.shade800));
      return;
    }

    try {
      isLoading.value = true;
      final result = await subscriptionService
          .createTransferWithProof(screenshotFile.value!);

      if (result != null && result['status'] == 'success') {
        await UserStorage.saveUserAccessLevel(UserAccessLevel.premium);
        await Get.find<DashboardController>().refreshSubscriptionStatus();
        // Refresh ProfileController subscription status
        final profileController = Get.find<ProfileController>();
        await profileController.refreshSubscriptionStatus();

        // Refresh user data from backend to get latest subscription info
        await refreshUserAfterPayment();

        hideTransferPaymentDialog();
        hidePaymentOptions();

        Get.snackbar('Subscription Active',
            result['message'] ?? 'Activated successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.shade100,
            colorText: Colors.green.shade800,
            icon: Icon(Icons.check_circle, color: Colors.green.shade800));
      } else if (result != null && result['status'] == 'pending') {
        hideTransferPaymentDialog();
        hidePaymentOptions();

        Get.snackbar(
            'Proof Submitted', result['message'] ?? 'Waiting for verification',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange.shade100,
            colorText: Colors.orange.shade800,
            icon: Icon(Icons.info, color: Colors.orange.shade800));
      } else if (result != null && result['status'] == 'error') {
        String message = result['message'] ?? 'Submission failed.';
        if (result['errors'] is Map) {
          (result['errors'] as Map).forEach((key, value) {
            message += '\n• ${value is List ? value.join(', ') : value}';
          });
        }

        Get.snackbar('Failed', message,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade800,
            icon: Icon(Icons.error, color: Colors.red.shade800));
      } else {
        Get.snackbar(
            'You are premium!', 'Please create an invoice for next month..',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.shade100,
            colorText: Colors.green.shade800,
            icon: Icon(Icons.check_circle, color: Colors.green.shade800));
      }
    } catch (e) {
      Get.snackbar('Error', 'Error submitting proof: ${e.toString()}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          icon: Icon(Icons.error, color: Colors.red.shade800));
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> refreshUserAfterPayment() async {
  try {
    final response = await LoginService.getAccountInfoWithToken();
    final user = response.accountInfo;
    final subscription = user?.subscription;

    if (user != null && subscription != null) {
      final expiryDate = DateTime.parse(subscription['expiration_date']);
      final accessLevel = subscription['status'] ?? 'free';

      // Simpan ke UserStorage
      await UserStorage.saveUserData(
        token: user.tokens.first.token,
        email: user.email,
        name: user.name,
        role: user.role,
        avatarUrl: user.avatar
      );
      await UserStorage.saveMembershipStatus(accessLevel);
      await UserStorage.setMembershipExpiry(expiryDate);

      // Panggil ProfileController atau DashboardController untuk refresh
      final dashboard = Get.find<DashboardController>();
      await dashboard.loadUserData();

      // Refresh HomeController membership status and lessons
        final homeController = Get.find<HomeController>();
        await homeController.refreshMembershipStatus();
      

      // Refresh ProfileController subscription status
        final profileController = Get.find<ProfileController>();
        await profileController.refreshEntireProfile();
      
    }
  } catch (e) {
    print('❌ Gagal refresh user setelah payment: $e');
  }
}


  Future<bool?> _showCashPaymentDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Konfirmasi Pembayaran'),
        content: Text('Apakah kamu yakin ingin membayar dengan tunai?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(context, true), child: Text('Ya')),
        ],
      ),
    );
  }

  void resetPaymentState() {
    showPaymentButtons.value = false;
    showTransferDialog.value = false;
    isLoading.value = false;
    screenshotFile.value = null;
  }

  @override
  void onClose() {
    resetPaymentState();
    super.onClose();
  }
}
