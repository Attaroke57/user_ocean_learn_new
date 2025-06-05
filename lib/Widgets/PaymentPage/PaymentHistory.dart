import 'package:flutter/material.dart';
import 'package:user_ocean_learn/Model/subscribtion_model.dart';
import 'package:user_ocean_learn/Page/HistoryPage/HistoryController.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';

class PaymentHistory extends StatelessWidget {
  final SubscriptionModel subscription;
  final PaymentController controller;

  const PaymentHistory({super.key, required this.subscription, required this.controller});

  @override
  Widget build(BuildContext context) {
    final (statusColor, statusBgColor) = _getStatusColors();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: netralcolor.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: purewhite,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildPaymentDetails(),
            if (subscription.detail.invoiceUrl.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildInvoiceButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.name.value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: textcolor,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Rp ${_formatAmount(subscription.detail.amount)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: primarycolor,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final (statusColor, statusBgColor) = _getStatusColors();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusBgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            subscription.status,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: netralcolor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            icon: Icons.payment_rounded,
            label: 'Payment Method',
            value: subscription.detail.paymentMethod,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            icon: Icons.schedule_rounded,
            label: 'Paid At',
            value: _formatDate(subscription.detail.paidAt),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: primarycolor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: primarycolor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: textcolor.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: textcolor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(
          Icons.receipt_long_rounded,
          size: 18,
        ),
        label: const Text(
          'View Invoice',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        onPressed: () => controller.viewInvoice(subscription.detail.invoiceUrl),
        style: OutlinedButton.styleFrom(
          foregroundColor: primarycolor,
          side: BorderSide(color: primarycolor.withOpacity(0.3)),
          backgroundColor: primarycolor.withOpacity(0.05),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  (Color, Color) _getStatusColors() {
    switch (subscription.status) {
      case 'Paid':
        return (Colors.green.shade600, Colors.green.shade50);
      case 'Pending':
        return (Colors.orange.shade600, Colors.orange.shade50);
      case 'Canceled':
        return (Colors.red.shade600, Colors.red.shade50);
      default:
        return (Colors.grey.shade600, Colors.grey.shade50);
    }
  }

  String _formatAmount(String amount) {
    // Format angka dengan separator ribuan
    final numStr = amount.replaceAll(RegExp(r'[^\d]'), '');
    if (numStr.isEmpty) return amount;
    
    final num = int.tryParse(numStr);
    if (num == null) return amount;
    
    return num.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  String _formatDate(String date) {
    // Bisa ditambahkan logika formatting date yang lebih baik
    return date;
  }
}