import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

class ProfileService {
  static const String baseUrl = 'https://ocean-learn-api.rplrus.com/api';
  static const String avatarBase = '$baseUrl/v1/avatar';

  /// Update profile (name + optional avatar)
  static Future<Map<String, dynamic>> updateProfile({
    required String name,
    File? avatarFile,
  }) async {
    try {
      final token = UserStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Authentication token not found'};
      }

      final uri = Uri.parse('$baseUrl/v1/user/update');
      final request = http.MultipartRequest('POST', uri);

      // headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // name
      request.fields['name'] = name;

      // avatar (optional)
      if (avatarFile != null) {
        final stream = http.ByteStream(avatarFile.openRead());
        final length = await avatarFile.length();
        final multipartFile = http.MultipartFile(
          'avatar',
          stream,
          length,
          filename: 'avatar.jpg',
        );
        request.files.add(multipartFile);
      }

      print('ProfileService: Sending request to update profile');
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('ProfileService: Response status: ${response.statusCode}');
      print('ProfileService: Response body: $responseBody');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseBody);

        if (jsonResponse['status'] == true) {
          final accountInfo = jsonResponse['data']['account_info'];
          String? avatarUrl;

          if (accountInfo['avatar'] != null) {
            final avatarPath = accountInfo['avatar'].toString();
            if (avatarPath.isNotEmpty) {
              final cleanPath = avatarPath.replaceFirst(RegExp(r'^/+'), '');
              // ✅ selalu pakai /v1/
              avatarUrl = '$baseUrl/v1/$cleanPath';
              final timestamp = DateTime.now().millisecondsSinceEpoch;
              avatarUrl = '$avatarUrl?t=$timestamp';
            }
          }

          return {
            'success': true,
            'message': jsonResponse['message'],
            'avatarUrl': avatarUrl,
            'data': accountInfo,
          };
        } else {
          return {
            'success': false,
            'message': jsonResponse['message'] ?? 'Update failed'
          };
        }
      } else {
        return _handleErrorResponse(responseBody, response.statusCode);
      }
    } catch (e) {
      print('ProfileService: Error updating profile: $e');
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  /// Get profile
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = UserStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Authentication token not found'};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('ProfileService: Get profile response: ${response.statusCode}');
      print('ProfileService: Get profile body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        final data = jsonResponse['data'];
        if (data['avatar'] != null) {
          final avatarPath = data['avatar'].toString();
          if (avatarPath.isNotEmpty) {
            final cleanPath = avatarPath.replaceFirst(RegExp(r'^/+'), '');
            final timestamp = DateTime.now().millisecondsSinceEpoch;
            // ✅ konsisten pakai /v1/
            data['avatar'] = '$baseUrl/v1/$cleanPath?t=$timestamp';
          }
        }

        return {
          'success': true,
          'data': data,
        };
      } else {
        return _handleErrorResponse(response.body, response.statusCode);
      }
    } catch (e) {
      print('ProfileService: Error getting profile: $e');
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  /// Helper to parse error response safely
  static Map<String, dynamic> _handleErrorResponse(String body, int statusCode) {
    try {
      final errorResponse = json.decode(body);
      return {
        'success': false,
        'message': errorResponse['message'] ?? 'Server error ($statusCode)'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Server error: $statusCode'
      };
    }
  }
}
