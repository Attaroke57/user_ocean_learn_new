import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_ocean_learn/Model/subscribtion_model.dart';
import 'package:user_ocean_learn/Page/HistoryPage/HistoryController.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';

class SubscriptionDetails extends StatelessWidget {
  final SubscriptionModel subscription;
  final PaymentController controller;

  const SubscriptionDetails({
    Key? key,
    required this.subscription,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final username = controller.getUsernameFromId(subscription.userId);
    final userEmail = controller.getUserEmailFromId(subscription.userId);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detail Subscription Data',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textcolor,
            ),
          ),
          const SizedBox(height: 20),
          DetailRow(label: 'Username', value: username),
          DetailRow(label: 'Email', value: userEmail),
          DetailRow(label: 'Amount', value: subscription.detail.amount),
          DetailRow(label: 'Status', value: subscription.status),
          DetailRow(label: 'Paid At', value: subscription.detail.paidAt),
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: label == 'Status' ? _getStatusColor(value) : textcolor,
                fontWeight: FontWeight.w500,
              ),
              softWrap: true,
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return textcolor;
    }
  }
}