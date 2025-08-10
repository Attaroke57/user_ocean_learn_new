import 'dart:convert';
import 'package:http/http.dart' as http;

class ResendOtpService {
  static const String _url =
      'https://ocean-learn-api.rplrus.com/api/v1/user/resend-otp';

  static Future<Map<String, dynamic>> resendOtp(String email) async {
    try {
      final Map<String, String> body = {
        'email': email,
      };

      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      print('Sending resend OTP request...');
      print('Email: $email');
      print('Status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      // Check if the response is a redirect
      if (response.isRedirect || response.statusCode == 302) {
        return {
          'success': false,
          'message': 'Server redirect detected. Please check the API endpoint.'
        };
      }
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': 'Failed: ${response.reasonPhrase}'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error occurred: $e',
      };
    }
  }
}
