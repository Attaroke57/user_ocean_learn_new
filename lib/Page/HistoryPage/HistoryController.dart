import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_ocean_learn/Model/subscribtion_model.dart';
import 'package:user_ocean_learn/Services/HistoryService.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

class PaymentController extends GetxController {
  final isLoading = true.obs;
  final error = ''.obs;

  // All subscriptions
  final subscriptions = <SubscriptionModel>[].obs;

  // Subscriptions grouped by month
  final subscriptionsByMonth = <String, List<SubscriptionModel>>{}.obs;
  var name = ''.obs;

  // For filtering
  final selectedMonth = ''.obs;
  final months = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUserName();
    fetchSubscriptions();
  }
   Future<void> loadUserName() async {
    name.value = UserStorage.getName() ?? '';
  }

  Future<void> fetchSubscriptions() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Get all subscriptions
      final allSubscriptions = await Historyservice.getSubscriptions();
      subscriptions.value = allSubscriptions;

      // Get subscriptions by month
      final groupedSubscriptions =
          await Historyservice.getSubscriptionsByMonth();
      subscriptionsByMonth.value = groupedSubscriptions;

      // Extract available months
      months.value = groupedSubscriptions.keys.toList();

      // Set selected month to the most recent one if available
      if (months.isNotEmpty) {
        selectedMonth.value = months.first;
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void changeSelectedMonth(String month) {
    selectedMonth.value = month;
  }

  List<SubscriptionModel> getSubscriptionsForSelectedMonth() {
    if (selectedMonth.isEmpty ||
        !subscriptionsByMonth.containsKey(selectedMonth.value)) {
      return [];
    }
    return subscriptionsByMonth[selectedMonth.value] ?? [];
  }

  void viewInvoice(String invoiceUrl) async {
    if (invoiceUrl.isEmpty) {
      Get.snackbar(
        'Error',
        'Invoice URL is not available',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final Uri url = Uri.parse(invoiceUrl);
    final success = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!success) {
      Get.snackbar(
        'Error',
        'Could not open invoice URL',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
