// lib/controllers/subscription_controller.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import 'package:user_ocean_learn/Model/login_service_model.dart';

class SubscriptionController {
  Future<void> handleSubscribe(BuildContext context) async {
    try {
     final response = await http.post(
  Uri.parse('https://ocean-learn-api.rplrus.com/api/v1/subscription'),
  headers: {
    'Authorization': 'Bearer $Token',
    'Content-Type': 'application/json',
  },
);

if (response.statusCode == 200) {
  final data = json.decode(response.body);

  final invoiceUrl = data['invoice_url']; // ← ambil langsung dari key 'invoice_url'

  if (await canLaunchUrl(Uri.parse(invoiceUrl))) {
    await launchUrl(Uri.parse(invoiceUrl), mode: LaunchMode.externalApplication);
  } else {
    throw 'Tidak bisa membuka link invoice: $invoiceUrl';
  }
} else {
  throw 'Gagal membuat subscription. Status: ${response.statusCode}';
}

    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat melakukan subscribe')),
      );
    }
  }
}
