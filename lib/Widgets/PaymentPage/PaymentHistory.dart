import 'package:flutter/material.dart';
import 'package:user_ocean_learn/Model/subscribtion_model.dart';
import 'package:user_ocean_learn/Page/HistoryPage/HistoryController.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

class PaymentHistory extends StatelessWidget {
  final SubscriptionModel subscription;
  final PaymentController controller;

  const PaymentHistory({
    Key? key,
    required this.subscription,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final username = UserStorage.getName() ?? 'User';
    final userEmail = UserStorage.getEmail() ?? 'email@example.com';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textcolor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(subscription.status),
              ],
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    'Amount',
                    'Rp ${subscription.detail.amount}',
                    Icons.attach_money,
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    'Method',
                    subscription.detail.paymentMethod,
                    Icons.payment,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    'Date',
                    subscription.detail.paidAt,
                    Icons.calendar_today,
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    'Month',
                    '${subscription.month} ${subscription.year}',
                    Icons.schedule,
                  ),
                ),
              ],
            ),

            // Status description
            if (subscription.status.toLowerCase() == 'pending')
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Payment is awaiting admin confirmation. You will be notified once approved.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // Action buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;
    
    switch (status.toLowerCase()) {
      case 'paid':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'pending':
        color = Colors.orange;
        icon = Icons.schedule;
        break;
      case 'failed':
        color = Colors.red;
        icon = Icons.error;
        break;
      case 'cancelled':
        color = Colors.grey;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final status = subscription.status.toLowerCase();
    final paymentMethod = subscription.detail.paymentMethod.toLowerCase();

    return Row(
      children: [
        // Confirm button for admin (cash payments only)
        if (paymentMethod == 'cash' && status == 'pending')
          
        if (paymentMethod == 'cash' && status == 'pending')
          const SizedBox(width: 8),
          
        // View Invoice button - always available
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => controller.viewInvoice(subscription),
            icon: const Icon(Icons.receipt, color: primarycolor, size: 16),
            label: const Text(
              'View Invoice',
              style: TextStyle(color: primarycolor, fontSize: 12),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: primarycolor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        
        // Retry payment button for failed payments
        if (status == 'failed')
          const SizedBox(width: 8),
        if (status == 'failed')
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to payment retry page
                // Get.toNamed('/payment-retry', arguments: subscription);
              },
              icon: const Icon(Icons.refresh, color: Colors.white, size: 16),
              label: const Text(
                'Retry Payment',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primarycolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textcolor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}