import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_ocean_learn/Services/SubscriptionService.dart';
import 'package:user_ocean_learn/Widgets/webview.dart';

class SubscriptionController extends GetxController {
  Future<void> handleSubscribeButtonPressed(BuildContext context) async {
    String invoiceUrl = await SubscriptionService().createSubscription() ?? '';

    print('Opening URL: $invoiceUrl');
    Uri url = Uri.parse(invoiceUrl);

    if (await canLaunchUrl(url)) {
      final success = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!success) {
        // Fallback to in-app WebView
        Get.to(() => WebViewPage(url: invoiceUrl));
      }
    } else {
      // Jika tidak bisa launch sama sekali, tampilkan dialog
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
