import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:user_ocean_learn/Model/history_model.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

class SubscriptionService {
  final String _baseUrl = 'https://api.momentumoceanlearn.com';

  /// ✅ Ambil token dari penyimpanan lokal dengan debug
  Future<String> _getUserToken() async {
    try {
      final storedToken = UserStorage.getToken();
      print('🔑 Token from storage: ${storedToken?.substring(0, 10)}...' ??
          'null');

      if (storedToken != null && storedToken.isNotEmpty) {
        return storedToken;
      }
      throw Exception('Token tidak ditemukan. Silakan login terlebih dahulu.');
    } catch (e) {
      print('❌ Error getting token: $e');
      return '';
    }
  }

 

  /// ✅ Membuat subscription baru dengan debug yang lebih detail
  Future<Map<String, dynamic>?> createSubscription() async {
  final url = Uri.parse('$_baseUrl/api/v1/subscription/transfer');
  print('🌐 Calling URL: $url');

  try {
    final token = await _getUserToken();
    if (token.isEmpty) {
      print('❌ Token is empty, cannot proceed');
      return null;
    }

    print('📤 Sending request with headers...');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 30));

    print('📥 Response received');
    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        print('✅ Parsed JSON successfully: $data');
        return data; // return full response JSON
      } catch (jsonError) {
        print('❌ JSON parsing error: $jsonError');
        return null;
      }
    } else if (response.statusCode == 401) {
      print('❌ Unauthorized - Token might be expired');
      return {'status': 'error', 'message': 'Unauthorized'};
    } else if (response.statusCode == 422) {
      print('❌ Validation error - Check request format');
      return {'status': 'error', 'message': 'Validation error'};
    } else {
      print('❌ HTTP Error ${response.statusCode}');
      return {'status': 'error', 'message': 'Server error'};
    }
  } catch (e) {
    if (e.toString().contains('TimeoutException')) {
      print('⏱️ Request timeout - Check internet connection');
      return {'status': 'error', 'message': 'Request timeout'};
    } else if (e.toString().contains('SocketException')) {
      print('🌐 Network error - Check internet connection');
      return {'status': 'error', 'message': 'Network error'};
    } else {
      print('❌ Exception during subscription: $e');
      return {'status': 'error', 'message': e.toString()};
    }
  }
}

  /// ✅ IMPROVED: Submit transfer proof dengan gambar dan validasi yang lebih baik
 Future<Map<String, dynamic>?> createTransferWithProof(
    File imageFile, String externalId) async {
  print('📤 Starting transfer with proof submission...');

  try {
    if (!await imageFile.exists()) {
      return {'status': 'error', 'message': 'Image file not found'};
    }

    final fileSizeInBytes = await imageFile.length();
    final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    if (fileSizeInMB > 5) {
      return {
        'status': 'error',
        'message': 'File size too large. Maximum 5MB allowed.'
      };
    }

    final token = await _getUserToken();
    if (token.isEmpty) {
      return {'status': 'error', 'message': 'Authentication token not found'};
    }

    final url = Uri.parse("$_baseUrl/api/v1/subscription/$externalId/proof");
    print('🌐 Calling URL: $url');

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    
    request.files.add(await http.MultipartFile.fromPath(
      'proof',
      imageFile.path,
    ));

    final streamedResponse =
        await request.send().timeout(Duration(seconds: 60));
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  } catch (e) {
    return {'status': 'error', 'message': e.toString()};
  }
}

  

  /// ✅ Cash payment dengan debug yang lebih detail
  Future<Map<String, dynamic>?> payWithCash() async {
    final url = Uri.parse('$_baseUrl/api/v1/subscription/cash');
    print('🌐 Calling cash payment URL: $url');

    try {
      final token = await _getUserToken();
      if (token.isEmpty) {
        print('❌ Token is empty for cash payment');
        return null;
      }

      print('📤 Sending cash payment request...');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 30));

      print('📥 Cash payment response received');
      print('Cash payment status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          print('✅ Cash payment JSON parsed successfully');
          return data;
        } catch (jsonError) {
          print('❌ Cash payment JSON parsing error: $jsonError');
          return null;
        }
      } else if (response.statusCode == 401) {
        print('❌ Cash payment unauthorized');
        return {'status': 'error', 'message': 'Unauthorized access'};
      } else if (response.statusCode == 422) {
        print('❌ Cash payment validation error');
        return {'status': 'error', 'message': 'Validation failed'};
      } else {
        print('❌ Cash payment HTTP Error ${response.statusCode}');
        return {
          'status': 'error',
          'message': 'HTTP Error ${response.statusCode}'
        };
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        print('⏱️ Cash payment timeout');
        return {'status': 'error', 'message': 'Request timeout'};
      } else if (e.toString().contains('SocketException')) {
        print('🌐 Cash payment network error');
        return {'status': 'error', 'message': 'Network error'};
      } else {
        print('❌ Exception during cash payment: $e');
        return {'status': 'error', 'message': e.toString()};
      }
    }
  }

  /// ✅ Test koneksi ke API
  Future<bool> testConnection() async {
    try {
      print('🧪 Testing connection to API...');
      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/test'),
        headers: {'Accept': 'application/json'},
      ).timeout(Duration(seconds: 10));

      print('🧪 Test connection status: ${response.statusCode}');
      return response.statusCode == 200 || response.statusCode == 404;
    } catch (e) {
      print('❌ Connection test failed: $e');
      return false;
    }
  }

  /// ✅ Mengambil history pembayaran dengan debug
  Future<List<SubscriptionHistory>> getHistory() async {
    final url = Uri.parse('$_baseUrl/api/v1/subscription/history');
    print('🌐 Calling history URL: $url');

    try {
      final token = await _getUserToken();
      if (token.isEmpty) {
        print('❌ Token is empty for history');
        return [];
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(Duration(seconds: 30));

      print('📥 History response received');
      print('History Status: ${response.statusCode}');
      print('History Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          final List data = responseData['data'];
          print('✅ History parsed successfully, ${data.length} items');
          return data.map((e) => SubscriptionHistory.fromJson(e)).toList();
        } catch (jsonError) {
          print('❌ History JSON parsing error: $jsonError');
          return [];
        }
      } else {
        print(
            '❌ History failed with status ${response.statusCode}: ${response.body}');
        return [];
      }
    } catch (e) {
      print('❌ Exception while fetching history: $e');
      return [];
    }
  }
}
