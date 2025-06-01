// SubscriptionController.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_ocean_learn/Services/SubscriptionService.dart';
import 'package:user_ocean_learn/Widgets/webview.dart';

class SubscriptionController extends GetxController {
  // Observable untuk mengontrol tampilan tombol payment
  RxBool showPaymentButtons = false.obs;
  RxBool isLoading = false.obs;

  final subscriptionService = SubscriptionService();

  void showPaymentOptions() {
    showPaymentButtons.value = true;
  }

  // Method untuk menyembunyikan payment options
  void hidePaymentOptions() {
    showPaymentButtons.value = false;
  }

  Future<void> handleCashPayment(BuildContext context) async {
  try {
    isLoading.value = true;

    bool? confirmed = await _showCashPaymentDialog(context);

    if (confirmed == true) {
      print('Starting cash payment process...');

      final subscriptionService = SubscriptionService();
      final result = await subscriptionService.payWithCash();

      print('Cash payment result: $result');

      if (result != null && result['status'] == 'success') {
        // Jika API benar-benar berhasil bayar
        Get.snackbar(
          'Payment Successful!',
          'Your cash payment has been processed successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
          duration: Duration(seconds: 4),
          icon: Icon(Icons.check_circle, color: Colors.green.shade800),
          shouldIconPulse: true,
        );
        hidePaymentOptions();
      } else if (result != null && result['status'] == 'pending') {
        // Invoice belum dibayar (pending)
        Get.snackbar(
          'Payment Pending',
          result['message'] ?? 'You have pending invoices. Please pay first.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade800,
          duration: Duration(seconds: 4),
          icon: Icon(Icons.info, color: Colors.orange.shade800),
        );
      } else {
        // Gagal tanpa pesan
        Get.snackbar(
          'Payment Failed',
          'Payment failed. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          duration: Duration(seconds: 4),
          icon: Icon(Icons.error, color: Colors.red.shade800),
        );
      }
    }
  } catch (e) {
    print('Error in cash payment: $e');
    Get.snackbar(
      'Error',
      'An error occurred while processing payment: ${e.toString()}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade800,
      duration: Duration(seconds: 4),
      icon: Icon(Icons.error, color: Colors.red.shade800),
    );
  } finally {
    isLoading.value = false;
  }
}


  // Method untuk handle transfer payment
  Future<void> handleTransferPayment(BuildContext context) async {
    try {
      isLoading.value = true;

      // Call original subscription logic untuk transfer
      await handleSubscribeButtonPressed(context);

      // Reset payment options setelah berhasil
      hidePaymentOptions();
    } catch (e) {
      print('Error in transfer payment: $e');
      Get.snackbar(
        'Error',
        'Failed to process transfer payment',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Original method untuk handle subscription (untuk transfer payment)
  Future<void> handleSubscribeButtonPressed(BuildContext context) async {
    String invoiceUrl = await SubscriptionService().createSubscription() ?? '';

    print('Opening URL: $invoiceUrl');
    Uri url = Uri.parse(invoiceUrl);

    try {
      final success = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      print('Launch success? $success');
      if (!success) {
        print('Fallback ke WebView');
        Get.to(() => WebViewPage(url: invoiceUrl));
      }
    } catch (e) {
      print('Error launching URL: $e');
      // Fallback ke WebView jika error
      Get.to(() => WebViewPage(url: invoiceUrl));
    }
  }

  // Dialog konfirmasi untuk cash payment
  Future<bool?> _showCashPaymentDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Pembayaran'),
        content: Text('Apakah kamu yakin ingin membayar dengan tunai?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Ya'),
          ),
        ],
      ),
    );
  }

  // Method untuk reset state
  void resetPaymentState() {
    showPaymentButtons.value = false;
    isLoading.value = false;
  }

  @override
  void onClose() {
    resetPaymentState();
    super.onClose();
  }
}
