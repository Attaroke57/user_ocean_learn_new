import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Dashboard/dashboard.dart';
import 'package:user_ocean_learn/Page/HistoryPage/HistoryController.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/PaymentPage/PaymentDashboard.dart';
import 'package:user_ocean_learn/Widgets/PaymentPage/PaymentHistory.dart';
import 'package:user_ocean_learn/Widgets/PaymentPage/PaymentSearchFIlter.dart';


class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.put(PaymentController());

    return Scaffold(
      backgroundColor: netralcolor,
      appBar: AppBar(
        title: const Text(
          'Payment Management',
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
            onPressed: () => controller.fetchSubscriptions(),
          ),
        ],
      ),
       drawer: NavDrawer(),
      body: Column(
        children: [
          Expanded(child: _buildPaymentPageContent(controller)),
        ],
      ),
    );
  }

  Widget _buildPaymentPageContent(PaymentController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: primarycolor));
      }

      if (controller.error.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Error: ${controller.error.value}', style: const TextStyle(color: textcolor)),
            ],
          ),
        );
      }

      if (controller.months.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.folder_outlined, color: primarycolor, size: 48),
              SizedBox(height: 16),
              Text('No payment records found', style: TextStyle(color: textcolor, fontSize: 16)),
            ],
          ),
        );
      }

      return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(child: PaymentDashboard(controller: controller)),
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              child: SearchAndFilter(controller: controller),
              minHeight: 140,
              maxHeight: 140,
            ),
          ),
        ],
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.getSubscriptionsForSelectedMonth().length,
          itemBuilder: (context, index) {
            final sub = controller.getSubscriptionsForSelectedMonth()[index];
            return PaymentHistory(subscription: sub, controller: controller);
          },
        ),
      );
    });
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  _StickyHeaderDelegate({required this.child, required this.minHeight, required this.maxHeight});

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate old) {
    return maxHeight != old.maxHeight || minHeight != old.minHeight || child != old.child;
  }
}