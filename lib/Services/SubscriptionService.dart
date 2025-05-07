import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

class SubscriptionService {
  final String _baseUrl = 'https://ocean-learn-api.rplrus.com';

  /// Create subscription, return invoice URL if success
  Future<String?> createSubscription() async {
    final url = Uri.parse('$_baseUrl/api/v1/subscription');

    try {
      final token = await _getUserToken(); // pakai yang benar
      if (token == null || token.isEmpty) {
        print('Token kosong. Harus login dulu.');
        return null;
      }

      print('Using token for API call: $token');

      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      final response = await http.post(url, headers: headers);

      print('API URL called: ${url.toString()}');
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['invoice_url'];
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception during API call: $e');
      return null;
    }
  }

  /// Ambil token dari GetStorage
 Future<String> _getUserToken() async {
  try {
    final storedToken = UserStorage.getToken();
    print('Stored token from UserStorage: $storedToken');

    if (storedToken != null && storedToken.isNotEmpty) {
      return storedToken;
    }

    throw Exception('Token tidak ditemukan. Silakan login terlebih dahulu.');
  } catch (e) {
    print('Error getting token: $e');
    return '';
  }
}

}
