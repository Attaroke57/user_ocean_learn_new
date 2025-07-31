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
        message: 'Incorrect email or password.',
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
