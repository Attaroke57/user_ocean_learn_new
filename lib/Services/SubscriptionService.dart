import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user_ocean_learn/Model/subscription_model.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

class SubscriptionService {
  final String _baseUrl = 'https://ocean-learn-api.rplrus.com';

  /// ✅ Ambil token dari penyimpanan lokal
  Future<String> _getUserToken() async {
    try {
      final storedToken = UserStorage.getToken();
      if (storedToken != null && storedToken.isNotEmpty) {
        return storedToken;
      }
      throw Exception('Token tidak ditemukan. Silakan login terlebih dahulu.');
    } catch (e) {
      print('Error getting token: $e');
      return '';
    }
  }

  /// ✅ Membuat subscription baru
  Future<String?> createSubscription() async {
    final url = Uri.parse('$_baseUrl/api/v1/subscription/digital');

    try {
      final token = await _getUserToken();
      if (token.isEmpty) return null;

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['invoice_url'];
      }
    } catch (e) {
      print('Exception during subscription: $e');
    }
    return null;
  }

  /// ✅ Mengambil history pembayaran
  Future<List<SubscriptionHistory>> getHistory() async {
    final url = Uri.parse('$_baseUrl/api/v1/subscription/history');

    try {
      final token = await _getUserToken();
      if (token.isEmpty) return [];

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('History Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        return data.map((e) => SubscriptionHistory.fromJson(e)).toList();
      } else {
        print('History failed: ${response.body}');
      }
    } catch (e) {
      print('Exception while fetching history: $e');
    }

    return [];
  }
}
