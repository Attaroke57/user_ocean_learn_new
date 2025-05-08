import 'package:flutter/material.dart';
import 'package:user_ocean_learn/Dashboard/dashboard.dart';
import 'package:user_ocean_learn/Model/subscription_model.dart';
import 'package:user_ocean_learn/Services/SubscriptionService.dart';
import 'package:url_launcher/url_launcher.dart';


class Historypage extends StatelessWidget {
  const Historypage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Pembayaran"),
        backgroundColor: Colors.transparent,
        leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
      ),
      drawer: NavDrawer(),
      body: FutureBuilder<List<SubscriptionHistory>>(
        future: SubscriptionService().getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada riwayat pembayaran."));
          }

          final histories = snapshot.data!;
          return ListView.builder(
            itemCount: histories.length,
            itemBuilder: (context, index) {
              final history = histories[index];
              return ListTile(
                title: Text("Status: ${history.status}"),
                subtitle: Text("Tanggal: ${history.createdAt}"),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  // Jika ingin buka invoice_url
                  final uri = Uri.parse(history.invoiceUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
