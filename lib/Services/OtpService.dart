import 'dart:convert';
import 'package:http/http.dart' as http;

class OtpService {
  static const String _url =
      'https://api.momentumoceanlearn.com/api/v1/user/verify'; // Ganti dengan URL asli

  static Future<Map<String, dynamic>> verifyOtp(
      String email, String otp) async {
    try {
      final Map<String, String> body = {
        'email': email,
        'otp': otp,
      };

      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      print('Sending OTP verification...');
      print('Email: $email');
      print('OTP: $otp');
      print('Status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Redirect?: ${response.isRedirect}');
      
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

  static Future<Map<String, dynamic>> verifyForgotPassword(String email,
      String otp, String newPassword, String newPasswordConfirmation) async {
    try {
      final Map<String, String> body = {
        'email': email,
        'otp': otp,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      };

      final response = await http.post(
        Uri.parse(
            'https://ocean-learn-api.rplrus.com/api/v1/user/verify-forgot-password'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      print('Sending forgot password verification...');
      print('Email: $email');
      print('OTP: $otp');
      print('New Password: $newPassword');
      print('Status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Redirect?: ${response.isRedirect}');

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
