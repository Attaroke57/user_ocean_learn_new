import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

class ProfileService {
  static const String baseUrl = 'https://api.momentumoceanlearn.com/api';

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

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(responseBody);

      if (jsonResponse['status'] == true) {
        final accountInfo = jsonResponse['data']['account_info'];
        final avatarUrl = accountInfo['avatar'];

        // simpan ke UserStorage
        await UserStorage.saveUserData(
          token: token,
          email: accountInfo['email'],
          name: accountInfo['name'],
          role: accountInfo['role'],
          avatarUrl: avatarUrl,
        );

        return {
          'success': true,
          'message': jsonResponse['message'],
          'avatarUrl': avatarUrl,
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
  /// Get profile - FIX: Use correct endpoint
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = UserStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Authentication token not found'};
      }
      final avatar = UserStorage.getAvatarUrl();
      // ✅ FIX: Use correct API endpoint
      final response = await http.get(
        Uri.parse('$baseUrl/v1/$avatar'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('ProfileService: Get profile response: ${response.statusCode}');
      print('ProfileService: Get profile body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        // ✅ FIX: Handle response structure correctly
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          final accountInfo = jsonResponse['data']['account_info'];
          
          // ✅ Process avatar URL consistently
          if (accountInfo['avatar'] != null && accountInfo['avatar'].isNotEmpty) {
            final avatarPath = accountInfo['avatar'].toString();
            // ✅ FIX: Build correct avatar URL
            accountInfo['avatar'] = 'https://ocean-learn-api.rplrus.com/api/v1/$avatarPath';
            print('✅ Processed avatar URL: ${accountInfo['avatar']}');
          }

          return jsonResponse;
        } else {
          return jsonResponse;
        }
      } else {
        return _handleErrorResponse(response.body, response.statusCode);
      }
    } catch (e) {
      print('ProfileService: Error getting profile: $e');
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static String getAvatarUrl(String? avatarPath)  {
    if (avatarPath == null || avatarPath.isEmpty) {
      return '';
    }
    return '$baseUrl/v1/$avatarPath';
  }

  static Future<Uint8List?> getAvatarBytes() async {
    try {
      final token = UserStorage.getToken();
      final avatarUrl = UserStorage.getAvatarUrl();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/v1/$avatarUrl'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      return null;
    } catch (e) {
      print('Error fetching avatar: $e');
      return null;
    }
  }

  static Map<String, String> getProfileHeader() {
    final token = UserStorage.getToken();
    return {
        'Authorization' : 'Bearer $token',
        'Content-Type': 'application/json',
    };
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