import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Dashboard/dashboard.dart';
import 'package:user_ocean_learn/Dashboard/dashboardcontroller.dart';
import 'package:user_ocean_learn/Page/HistoryPage/HistoryController.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/PaymentPage/PaymentHistory.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.put(PaymentController());
    final DashboardController dashboardController =
        Get.find<DashboardController>();

    return Scaffold(
      backgroundColor: netralcolor,
      appBar: AppBar(
        title: const Text(
          'Payment History',
          style: TextStyle(color: textcolor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: secondarycolor,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () => controller.refreshData(),
          ),
        ],
      ),
      drawer: NavDrawer(),
      body: Column(
        children: [
          // Status indicator untuk user

          Expanded(child: _buildPaymentPageContent(controller)),
        ],
      ),
    );
  }

  Widget _buildPaymentPageContent(PaymentController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
            child: CircularProgressIndicator(color: primarycolor));
      }

      if (controller.error.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Error: ${controller.error.value}',
                  style: const TextStyle(color: textcolor)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.refreshData(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.months.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long_outlined,
                  color: Colors.grey.shade400, size: 64),
              const SizedBox(height: 16),
              Text(
                'No payment history yet',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your payment transactions will appear here',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // Month selector
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment History by Month',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textcolor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.months.length,
                      itemBuilder: (context, index) {
                        final month = controller.months[index];
                        final isSelected =
                            controller.selectedMonth.value == month;

                        return GestureDetector(
                          onTap: () => controller.changeSelectedMonth(month),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? primarycolor
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                month,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : textcolor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: RefreshIndicator(
          onRefresh: () => controller.refreshData(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.getSubscriptionsForSelectedMonth().length,
            itemBuilder: (context, index) {
              final sub = controller.getSubscriptionsForSelectedMonth()[index];
              return PaymentHistory(subscription: sub, controller: controller);
            },
          ),
        ),
      );
    });
  }
}
