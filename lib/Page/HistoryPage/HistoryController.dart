import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_ocean_learn/Model/Member_model.dart';
import 'package:user_ocean_learn/Model/subscribtion_model.dart';
import 'package:user_ocean_learn/Page/HistoryPage/InvoicePage.dart';
import 'package:user_ocean_learn/Services/HistoryService.dart';
import 'package:user_ocean_learn/Services/SubscriptionService.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

class PaymentController extends GetxController {
  final isLoading = true.obs;
  final error = ''.obs;
  final isConfirming = false.obs;
  var name = ''.obs;
  final subscriptions = <SubscriptionModel>[].obs;
  final subscriptionsByMonth = <String, List<SubscriptionModel>>{}.obs;
  final members = <MemberModel>[].obs; 
  

  final selectedMonth = ''.obs;
  final months = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUserName();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      error.value = '';

      await Future.wait([
        fetchSubscriptions(),
        
      ]);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> loadUserName() async {
    name.value = UserStorage.getName() ?? '';
  }
  

  Future<void> fetchSubscriptions() async {
    try {
      final allSubscriptions = await Historyservice.getSubscriptions();
      subscriptions.value = allSubscriptions;

      final groupedSubscriptions = await Historyservice.getSubscriptionsByMonth();
      subscriptionsByMonth.value = groupedSubscriptions;

      months.value = groupedSubscriptions.keys.toList();

      if (months.isNotEmpty) {
        selectedMonth.value = months.first;
      }
    } catch (e) {
      throw Exception('Error fetching subscriptions: $e');
    }
  }

  

  String getUsernameFromId(int userId) {
    try {
      final member = members.firstWhere(
        (member) => member.id.personalId == userId,
      );
      return member.accountInfo.name;
    } catch (e) {
      return 'Unknown User'; 
    }
  }

  String getUserEmailFromId(int userId) {
    try {
      final member = members.firstWhere(
        (member) => member.id.personalId == userId,
      );
      return member.accountInfo.email;
    } catch (e) {
      return 'Unknown Email';
    }
  }

  String getUserRoleFromId(int userId) {
    try {
      final member = members.firstWhere(
        (member) => member.id.personalId == userId,
      );
      return member.accountInfo.role;
    } catch (e) {
      return 'Unknown Role';
    }
  }

  MemberModel? getMemberFromId(int userId) {
    try {
      return members.firstWhere(
        (member) => member.id.personalId == userId,
      );
    } catch (e) {
      return null;
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

  void viewInvoice(SubscriptionModel subscription) async {
    String invoiceUrl = subscription.detail.invoiceUrl;

    // Show invoice page if payment method is cash or invoiceUrl is empty or "offline payment"
    if (subscription.detail.paymentMethod.toLowerCase() == 'cash' ||
        invoiceUrl.isEmpty ||
        invoiceUrl.toLowerCase() == "offline payment") {
      Get.to(
        () => InvoicePage(
          subscription: subscription,
          controller: this,
        ),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      );
      return;
    }

    // For other payment methods, open the invoice URL externally
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

  Future<void> confirmCashPayment(SubscriptionModel subscription) async {
  try {
    final username = getUsernameFromId(subscription.userId);

    bool? shouldConfirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirm Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to confirm this ${subscription.detail.paymentMethod} payment?'),
            const SizedBox(height: 8),
            Text('Username: $username', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Amount: Rp ${subscription.detail.amount}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Payment Method: ${subscription.detail.paymentMethod}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (shouldConfirm != true) return;

    isConfirming.value = true;

    

    
  } catch (e) {
    
  }
}
  Future<void> refreshData() async {
    await fetchData();
  }
}