import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionController extends GetxController {
  Future<void> handleSubscribeButtonPressed(BuildContext context) async {
    const invoiceUrl = 'https://checkout-staging.xendit.co/web/681701e31cfd0b6884670b88';

    if (await canLaunchUrl(Uri.parse(invoiceUrl))) {
      await launchUrl(
        Uri.parse(invoiceUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      Get.dialog(AlertDialog(
        title: const Text('Error'),
        content: const Text('Could not open the subscription URL.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ));
    }
  }
}
