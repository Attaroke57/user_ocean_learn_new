import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String paymentMethod;

  const PaymentMethodSelector({
    Key? key,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final method = paymentMethod.toLowerCase();

    return Container(
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
              Expanded(
                child: PaymentMethodOption(
                  method: 'Cash',
                  isSelected: method == 'cash',
                ),
              ),
              Expanded(
                child: PaymentMethodOption(
                  method: 'Transfer',
                  isSelected: method == 'transfer',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentMethodOption extends StatelessWidget {
  final String method;
  final bool isSelected;

  const PaymentMethodOption({
    Key? key,
    required this.method,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: isSelected ? primarycolor : Colors.grey.shade300,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: purewhite, size: 14)
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            method,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: textcolor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 