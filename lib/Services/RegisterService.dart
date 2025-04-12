import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterService {
  static Future<Map<String, dynamic>> register(String username, String password, String email) async {
    try {
      // Use the exact URL for registration
      final response = await http.post(
        Uri.parse('https://ocean-learn-api.rplrus.com/api/v1/user/register'),
        // Set content type for form data
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        // Format body as form data
        body: {
          'username': username,
          'password': password,
          'email': email,
        },
      );

      print('Register response status: ${response.statusCode}');
      print('Register response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        // Try to parse error message from response
        String errorMessage;
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? 'Registration failed';
        } catch (e) {
          errorMessage = 'Registration failed. Status: ${response.statusCode}';
        }
        
        return {
          'success': false,
          'message': errorMessage,
        };
      }
    } catch (e) {
      print('Registration error: $e');
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }
}