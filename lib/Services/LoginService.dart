import 'dart:math';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class LoginService {
  // Create a static method that returns a dummy successful response
  // This will help us test if the freezing is in the HTTP request itself
  static Future<Map<String, dynamic>> loginDummy(
      String email, String password) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Return a hardcoded successful response
    return {
      'status': true,
      'message': 'Login Successful (Test)',
      'token': 'test_token_12345',
    };
  }

  // The main login method with SafetyNet
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    // Create a completer to handle timeouts manually
    Completer<Map<String, dynamic>> completer = Completer();

    // Set a timeout to avoid infinite waiting
    Timer(Duration(seconds: 15), () {
      if (!completer.isCompleted) {
        completer.complete({
          'status': false,
          'message': 'Request timed out after 15 seconds',
        });
      }
    });

    // Start the actual network request in a separate microtask
    // This ensures the UI thread isn't blocked
    Future.microtask(() async {
      try {
        // Make the HTTP request
        final response = await http.post(
          Uri.parse('https://ocean-learn-api.rplrus.com/api/v1/user/auth'),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {'email': email, 'password': password},
        );

        // Process the response only if completer hasn't completed yet
        if (!completer.isCompleted) {
          try {
            final Map<String, dynamic> responseData = jsonDecode(response.body);

            if (response.statusCode == 200 && responseData['status'] == true) {
              final token =
                  responseData['data']['account_info']['token'][0]['token'];

              completer.complete({
                'status': true,
                'message': responseData['message'],
                'token': token,
              });
            } else {
              completer.complete({
                'status': false,
                'message': responseData['message'] ?? 'Login failed',
              });
            }
          } catch (parseError) {
            completer.complete({
              'status': false,
              'message': 'Error parsing response: $parseError',
            });
          }
        }
      } catch (e) {
        if (!completer.isCompleted) {
          completer.complete({
            'status': false,
            'message': 'Network error: $e',
          });
        }
      }
    });

    // Return the future from the completer
    return completer.future;
  }

  // Token validation method with same SafetyNet pattern
  static Future<Map<String, dynamic>> validateToken(String token) async {
    // Create a completer to handle timeouts manually
    Completer<Map<String, dynamic>> completer = Completer();

    // Set a timeout to avoid infinite waiting
    Timer(Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        completer.complete({
          'status': false,
          'message': 'Validation request timed out after 10 seconds',
        });
      }
    });

    // Start the actual network request in a separate microtask
    Future.microtask(() async {
      try {
        // Make the HTTP request to validate token
        final response = await http.post(
          Uri.parse('https://ocean-learn-api.rplrus.com/api/v1/user/validate-token'),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer $token',
          },
        );

        print("Token validation raw response:");
        print("Status code: ${response.statusCode}");
        print("Headers: ${response.headers}");
        print(
            "Body: ${response.body.substring(0, min(500, response.body.length))}");

        // Process the response only if completer hasn't completed yet
        if (!completer.isCompleted) {
          try {
            final Map<String, dynamic> responseData = jsonDecode(response.body);

            if (response.statusCode == 200 && responseData['status'] == true) {
              completer.complete({
                'status': true,
                'message': responseData['message'] ?? 'Token valid',
              });
            } else {
              completer.complete({
                'status': false,
                'message': responseData['message'] ?? 'Invalid token',
              });
            }
          } catch (parseError) {
            completer.complete({
              'status': false,
              'message': 'Error parsing response: $parseError',
            });
          }
        }
      } catch (e) {
        // For testing purposes - if API doesn't exist yet, validate dummy token
        if (token == 'test_token_12345' && !completer.isCompleted) {
          completer.complete({
            'status': true,
            'message': 'Token is valid (Test)',
          });
          return;
        }

        if (!completer.isCompleted) {
          completer.complete({
            'status': false,
            'message': 'Network error during validation: $e',
          });
        }
      }
    });

    // Return the future from the completer
    return completer.future;
  }
}
