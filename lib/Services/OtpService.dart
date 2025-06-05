import 'dart:convert';
import 'package:http/http.dart' as http;

class OtpService {
  static const String _url = 'https://ocean-learn-api.rplrus.com/api/v1/user/verify'; // Ganti dengan URL asli

  static Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final Map<String, String> body = {
        'email': email,
        'otp': otp,
      };
      
      final response = await http.post(
        Uri.parse(_url),
        headers: {
        'Content-Type': 'application/x-www-form-urlencoded', 
}        ,
        body: body,
      );

print('Sending OTP verification...');
print('Email: $email');
print('OTP: $otp');
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
