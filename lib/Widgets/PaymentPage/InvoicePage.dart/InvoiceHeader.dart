import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_ocean_learn/Model/subscribtion_model.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';

class InvoiceHeader extends StatelessWidget {
  final SubscriptionModel subscription;

  const InvoiceHeader({
    Key? key,
    required this.subscription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Premium For ',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textcolor,
          ),
        ),
        Text(
          '${subscription.month}!',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primarycolor,
          ),
        ),
      ],
    );
  }
}