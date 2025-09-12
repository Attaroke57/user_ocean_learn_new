import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_ocean_learn/Model/subscribtion_model.dart';
import 'package:user_ocean_learn/Page/HistoryPage/HistoryController.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

class InvoicePage extends StatelessWidget {
  final SubscriptionModel subscription;
  final PaymentController controller;

  const InvoicePage({
    Key? key,
    required this.subscription,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final username = UserStorage.getName() ?? 'User';
    final userEmail = UserStorage.getEmail() ?? 'email@example.com';

    return Scaffold(
      backgroundColor: netralcolor,
      appBar: AppBar(
        title: const Text(
          'Invoice Details',
          style: TextStyle(color: textcolor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: netralcolor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: purewhite,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Premium For ',
                        style: GoogleFonts.montserrat(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textcolor,
                        ),
                      ),
                      Text(
                        '${subscription.month}!',
                        style: GoogleFonts.montserrat(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primarycolor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Illustration
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: Center(
                      child: SvgPicture.asset(
                        'Assets/images/subscribe.svg',
                        height: 150,
                        width: 150,
                        // If SVG doesn't exist, show a placeholder
                        placeholderBuilder: (context) => Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: primarycolor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Detail Subscription Data
                  Container(
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
                        _buildDetailRow('Username', username),
                        _buildDetailRow('Email', userEmail),
                        _buildDetailRow('Amount', subscription.detail.amount),
                        _buildDetailRow('Status', subscription.status),
                        _buildDetailRow(
                          'Paid At',
                          subscription.status.toLowerCase() == 'pending'
                              ? '-'
                              : subscription.status.toLowerCase() == 'canceled'
                                  ? '-'
                                  : subscription.detail.paidAt,
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Method',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textcolor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            // Cash option
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: subscription.detail.paymentMethod
                                                    .toLowerCase() ==
                                                'cash'
                                            ? primarycolor
                                            : Colors.grey.shade300,
                                      ),
                                      child: subscription.detail.paymentMethod
                                                  .toLowerCase() ==
                                              'cash'
                                          ? const Icon(Icons.check,
                                              color: purewhite, size: 14)
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Cash',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: textcolor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Transfer option
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: subscription.detail.paymentMethod
                                                    .toLowerCase() ==
                                                'transfer'
                                            ? primarycolor
                                            : Colors.grey.shade300,
                                      ),
                                      child: subscription.detail.paymentMethod
                                                  .toLowerCase() ==
                                              'transfer'
                                          ? const Icon(Icons.check,
                                              color: purewhite, size: 14)
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Transfer',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: textcolor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondarycolor,
                        foregroundColor: primarycolor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: primarycolor,
                            width: 1, // Ketebalan garis
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Thank You!',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: label == 'Status' ? _getStatusColor(value) : textcolor,
              fontWeight: FontWeight.w500,
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
