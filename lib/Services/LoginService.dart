import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Use the exact same URL as in Postman
      final response = await http.post(
        Uri.parse('https://ocean-learn-api.rplrus.com/api/v1/user/auth'),
        // Match Postman's content type for x-www-form-urlencoded
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        // Format body as form data instead of JSON
        body: {
          'email': email,
          'password': password,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': 'Login failed. Please check your credentials. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }
}