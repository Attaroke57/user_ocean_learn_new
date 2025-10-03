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

  // New simplified transfer payment method - only creates pending invoice
  Future<void> handleTransferPaymentSimplified(BuildContext context) async {
    try {
      isLoading.value = true;

      final result = await subscriptionService.createSubscription();

      if (result != null) {
        await loadSubscriptions();
        hidePaymentOptions();
        Get.snackbar(
          'Invoice Created',
          'Pending invoice created! Please check payment history to upload transfer proof.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue.shade100,
          colorText: Colors.blue.shade800,
          icon: Icon(Icons.info, color: Colors.blue.shade800),
          duration: Duration(seconds: 5),
        );
      } else {
        Get.snackbar('Failed', 'Failed to create invoice.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error creating invoice: ${e.toString()}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          icon: Icon(Icons.error, color: Colors.red.shade800));
    } finally {
      isLoading.value = false;
    }
  }

  // Moved image picker and submission methods for use in InvoicePage
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

  Future<void> submitTransferProof(SubscriptionModel subscription) async {
  if (screenshotFile.value == null) {
    Get.snackbar("Error", "No proof selected!");
    return;
  }

  try {
    isLoading.value = true;

    print('🔍 Submitting transfer proof for subscription:');
    print('   External ID: ${subscription.externalId}');
    print('   Status: ${subscription.status}');
    print('   Month: ${subscription.month}');
    
    // Use externalId which now contains the UUID from API
    final result = await subscriptionService.createTransferWithProof(
      screenshotFile.value!,
      subscription.externalId, // This now correctly contains the UUID
    );

    print('📥 Transfer proof submission result: $result');

    if (result != null && result['status'] == 'paid') {
      screenshotFile.value = null;  

      Get.snackbar(
        'Proof Uploaded',
        'Transfer proof uploaded successfully! Awaiting admin confirmation.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
        icon: Icon(Icons.check_circle, color: Colors.green.shade800),
        duration: Duration(seconds: 4),
      );

      // Refresh subscriptions data
      await loadSubscriptions();
      
      // Refresh user data after payment
      await refreshUserAfterPayment();

      // Go back to previous screen
      Get.back();
    } else {
      String message = result?['message'] ?? 'Upload failed.';
      
      // Handle validation errors if they exist
      if (result != null && result['errors'] is Map) {
        message += '\n';
        (result['errors'] as Map).forEach((key, value) {
          if (value is List) {
            message += '\n• ${value.join(', ')}';
          } else {
            message += '\n• $value';
          }
        });
      }

      Get.snackbar(
        'Upload Failed',
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        icon: Icon(Icons.error, color: Colors.red.shade800),
        duration: Duration(seconds: 5),
      );
    }
  } catch (e) {
    print('❌ Exception during transfer proof submission: $e');
    
    Get.snackbar(
      'Error',
      'Error uploading proof: ${e.toString()}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade800,
      icon: Icon(Icons.error, color: Colors.red.shade800),
      duration: Duration(seconds: 5),
    );
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
            avatarUrl: user.avatar);
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
    isLoading.value = false;
    screenshotFile.value = null;
  }

  @override
  void onClose() {
    resetPaymentState();
    super.onClose();
  }
}
