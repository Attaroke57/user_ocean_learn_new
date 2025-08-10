import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user_ocean_learn/Model/login_service_model.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

class LoginService {
  static const String _baseUrl = 'https://ocean-learn-api.rplrus.com';

  static Future<LoginResponseModel> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/user/auth'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      return LoginResponseModel.fromJson(jsonDecode(response.body));
    } on TimeoutException {
      return LoginResponseModel(
        status: false,
        message: 'Connection timeout. Please check your internet connection.',
      );
    } catch (e) {
      print('Login error: $e');
      return LoginResponseModel(
        status: false,
        message: 'Incorrect password or email',
      );
    }
  }

  static Future<LoginResponseModel> forgotPassword(String email) async {
    try {
      final Map<String, String> body = {
        'email': email,
      };
      
      // Get token and check if it's valid
      final token = await UserStorage.getToken();
      print('Token retrieved from storage: $token');
      
      // If token is null or empty, we should not include Authorization header
      if (token == null || token.isEmpty) {
        print('No valid token found, sending request without Authorization header');
        final response = await http.post(
          Uri.parse('$_baseUrl/api/v1/user/forgot-password'),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json',
          },
          body: body,
        );
        
        print('Forgot password response status code: ${response.statusCode}');
        print('Forgot password response body: ${response.body}');
        
        return LoginResponseModel.fromJson(jsonDecode(response.body));
      } else {
        // If we have a valid token, include it in the request
        print('Valid token found, sending request with Authorization header');
        final response = await http.post(
          Uri.parse('$_baseUrl/api/v1/user/forgot-password'),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body,
        );
        
        print('Forgot password response status code: ${response.statusCode}');
        print('Forgot password response body: ${response.body}');
        
        return LoginResponseModel.fromJson(jsonDecode(response.body));
      }
    } on TimeoutException {
      return LoginResponseModel(
        status: false,
        message: 'Connection timeout. Please check your internet connection.',
      );
    } catch (e) {
      print('Forgot password error: $e');
      return LoginResponseModel(
        status: false,
        message: 'Failed to send forgot password request.',
      );
    }
  }

  static Future<LoginResponseModel> verifyForgotPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final Map<String, String> body = {
        'email': email,
        'otp': otp,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      };
      final token = await UserStorage.getToken();
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/user/verify-forgot-password'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

// Coba cetak headers manual dari permintaan, ini alternatif
      print('Authorization: Bearer $token');
      if (response.statusCode != 200) {
        return LoginResponseModel(
          status: false,
          message: 'Failed to verify forgot password request.',
        );
      }
      return LoginResponseModel.fromJson(jsonDecode(response.body));
    } on TimeoutException {
      return LoginResponseModel(
        status: false,
        message: 'Connection timeout. Please check your internet connection.',
      );
    } catch (e) {
      print('Verify forgot password error: $e');
      return LoginResponseModel(
        status: false,
        message: 'Failed to verify forgot password request.',
      );
    }
  }

  static Future<LoginResponseModel> getAccountInfoWithToken() async {
    final token = await UserStorage.getToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/api/v1/user/show'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('LoginService: raw response data: ${response.body}');

    return LoginResponseModel.fromJson(jsonDecode(response.body));
  }

  Future<Map<String, dynamic>> getUserDataFromAuth() async {
    final token = await UserStorage.getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/api/v1/user/auth'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    final data = jsonDecode(response.body);
    return data['data']; // pastikan ini sesuai struktur API kamu
  }

  static Future<Map<String, dynamic>> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/user/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      final jsonResponse = jsonDecode(response.body);

      return {
        'success': jsonResponse['status'] == true,
        'message': jsonResponse['message'] ?? 'Logout response received',
      };
    } on TimeoutException {
      return {'success': false, 'message': 'Timeout during logout'};
    } catch (_) {
      return {'success': false, 'message': 'Unexpected error during logout'};
    }
  }
}
