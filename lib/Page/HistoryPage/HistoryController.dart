import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_ocean_learn/Model/Member_model.dart';
import 'package:user_ocean_learn/Model/subscribtion_model.dart';
import 'package:user_ocean_learn/Page/HistoryPage/InvoicePage.dart';
import 'package:user_ocean_learn/Page/SubscriptionPage/SubscriptionController.dart';
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

  // Status counters
  final pendingCount = 0.obs;
  final paidCount = 0.obs;
  final failedCount = 0.obs;

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

      _updateStatusCounters();
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

      final groupedSubscriptions =
          await Historyservice.getSubscriptionsByMonth();
      subscriptionsByMonth.value = groupedSubscriptions;

      months.value = groupedSubscriptions.keys.toList();

      if (months.isNotEmpty) {
        selectedMonth.value = months.first;
      }
    } catch (e) {
      throw Exception('Error fetching subscriptions: $e');
    }
  }

  void _updateStatusCounters() {
    int pending = 0, paid = 0, failed = 0;

    for (var subscription in subscriptions) {
      switch (subscription.status.toLowerCase()) {
        case 'pending':
          pending++;
          break;
        case 'paid':
          paid++;
          break;
        case 'failed':
          failed++;
          break;
      }
    }

    pendingCount.value = pending;
    paidCount.value = paid;
    failedCount.value = failed;
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

  List<SubscriptionModel> getSubscriptionsByStatus(String status) {
    return subscriptions
        .where((sub) => sub.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  void viewInvoice(SubscriptionModel subscription) async {
    String invoiceUrl = subscription.detail.invoiceUrl;

    // Show invoice page if payment method is cash or invoiceUrl is empty or "offline payment"
    if (subscription.detail.paymentMethod.toLowerCase() == 'cash' ||
        invoiceUrl.isEmpty ||
        invoiceUrl.toLowerCase() == "offline payment") {
      Get.to(() => InvoicePage(
            subscription: subscription,
            controller: Get.put(PaymentController()), // PaymentController
            
          ));

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
          title: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green, size: 28),
              const SizedBox(width: 12),
              const Text('Confirm Payment'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Are you sure you want to confirm this ${subscription.detail.paymentMethod} payment?',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    _buildConfirmationDetail('Username', username),
                    _buildConfirmationDetail(
                        'Email', getUserEmailFromId(subscription.userId)),
                    _buildConfirmationDetail(
                        'Amount', 'Rp ${subscription.detail.amount}'),
                    _buildConfirmationDetail(
                        'Payment Method', subscription.detail.paymentMethod),
                    _buildConfirmationDetail(
                        'Month', '${subscription.month} ${subscription.year}'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.yellow.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This action cannot be undone. The user will immediately gain premium access.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.check, size: 18),
              label: const Text('Confirm Payment'),
            ),
          ],
        ),
      );

      if (shouldConfirm != true) return;

      isConfirming.value = true;

      // Simulate API call for payment confirmation
      await Future.delayed(const Duration(seconds: 2));

      // Update subscription status locally
      final index = subscriptions.indexWhere((s) => s.id == subscription.id);
      if (index != -1) {
        // Create updated subscription with paid status
        final updatedSubscription = SubscriptionModel(
          id: subscription.id,
          userId: subscription.userId,
          month: subscription.month,
          year: subscription.year,
          status: 'paid', // Update status to paid
          detail: SubscriptionDetail(
            amount: subscription.detail.amount,
            paymentMethod: subscription.detail.paymentMethod,
            paidAt:
                DateTime.now().toString().substring(0, 19), // Update paid time
            invoiceUrl: subscription.detail.invoiceUrl,
          ), externalId: '',
        );

        subscriptions[index] = updatedSubscription;

        // Update grouped subscriptions
        final monthKey = '${subscription.month} ${subscription.year}';
        if (subscriptionsByMonth.containsKey(monthKey)) {
          final monthSubscriptions = subscriptionsByMonth[monthKey]!;
          final monthIndex =
              monthSubscriptions.indexWhere((s) => s.id == subscription.id);
          if (monthIndex != -1) {
            monthSubscriptions[monthIndex] = updatedSubscription;
          }
        }
      }

      _updateStatusCounters();

      Get.snackbar(
        'Success',
        'Payment confirmed successfully! User now has premium access.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to confirm payment: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isConfirming.value = false;
    }
  }

  Widget _buildConfirmationDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> refreshData() async {
    await fetchData();
  }

  // Additional helper methods for better UX
  bool hasPendingPayments() {
    return subscriptions.any((sub) => sub.status.toLowerCase() == 'pending');
  }

  int getTotalPayments() {
    return subscriptions.length;
  }

  double getTotalAmount() {
    return subscriptions.fold(0.0, (sum, sub) {
      final amount = double.tryParse(
              sub.detail.amount.replaceAll(RegExp(r'[^0-9.]'), '')) ??
          0.0;
      return sum + amount;
    });
  }

  String getFormattedTotalAmount() {
    final total = getTotalAmount();
    return 'Rp ${total.toStringAsFixed(0)}';
  }
}
