import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterService {
  static Future<Map<String, dynamic>> register(String username, String password, String email) async {
    try {
      // Prepare the request body
      final Map<String, String> body = {
        'name': username,        // Make sure it's 'name', not 'username'
        'password': password,
        'email': email,
      };
      
      // Print the request details for debugging
      print('Register request body: $body');
      
      // Use the exact URL for registration
      final response = await http.post(
        Uri.parse('https://api.momentumoceanlearn.com/api/v1/user/register'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      // Print detailed response for debugging
      print('Register response status: ${response.statusCode}');
      print('Register response headers: ${response.headers}');
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
