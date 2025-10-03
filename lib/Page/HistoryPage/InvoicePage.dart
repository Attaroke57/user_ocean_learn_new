import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Model/subscribtion_model.dart';
import 'package:user_ocean_learn/Page/HistoryPage/HistoryController.dart';
import 'package:user_ocean_learn/Page/SubscriptionPage/SubscriptionController.dart';
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
    final subscriptionController = Get.put(SubscriptionController());


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

                  // Payment Method Section
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
                                padding: const EdgeInsets.symmetric(vertical: 12),
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
                                padding: const EdgeInsets.symmetric(vertical: 12),
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

                  // Transfer Upload Section - Only show for pending transfer payments
                  if (subscription.detail.paymentMethod.toLowerCase() == 'transfer' && 
                      subscription.status.toLowerCase() == 'pending')
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.orange.shade600, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Transfer Instructions',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Bank Details
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Transfer to BCA Virtual Account:',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textcolor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.blue.shade200),
                                  ),
                                  child: Text(
                                    '0980578518',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade800,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Amount: Rp ${subscription.detail.amount}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textcolor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Upload Section
                          Text(
                            'Upload Transfer Proof:',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange.shade800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Upload Button
                          Container(
                            width: double.infinity,
                            child: Obx(() => ElevatedButton.icon(
                              onPressed: subscriptionController.isLoading.value
                                  ? null
                                  : () => subscriptionController.pickScreenshot(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange.shade100,
                                foregroundColor: Colors.orange.shade800,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Colors.orange.shade300),
                                ),
                              ),
                              icon: Icon(Icons.upload_file, size: 18),
                              label: Text(
                                subscriptionController.screenshotFile.value != null
                                    ? 'Change Screenshot'
                                    : 'Upload Screenshot',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )),
                          ),
                          
                          // Show selected image preview
                          Obx(() {
                            if (subscriptionController.screenshotFile.value != null) {
                              return Column(
                                children: [
                                  const SizedBox(height: 16),
                                  Container(
                                    width: double.infinity,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        subscriptionController.screenshotFile.value!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle, 
                                           color: Colors.green.shade600, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Screenshot selected',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.green.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                          
                          const SizedBox(height: 16),
                          
                          // Submit Button
                          Container(
                            width: double.infinity,
                            child: Obx(() => ElevatedButton(
                              onPressed: subscriptionController.isLoading.value ||
                                         subscriptionController.screenshotFile.value == null
                                  ? null
                                  : () => subscriptionController.submitTransferProof(subscription),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primarycolor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                disabledBackgroundColor: Colors.grey.shade300,
                              ),
                              child: subscriptionController.isLoading.value
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Uploading...',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      'Submit Transfer Proof',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            )),
                          ),
                        ],
                      ),
                    ),

                  // Thank You Button - Modified condition
                  const SizedBox(height: 24),
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
                            width: 1,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        subscription.status.toLowerCase() == 'pending' && 
                        subscription.detail.paymentMethod.toLowerCase() == 'transfer'
                            ? 'Back to History' 
                            : 'Thank You!',
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