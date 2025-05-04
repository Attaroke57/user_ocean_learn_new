import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Alternative implementation without using flutter_secure_storage
class SubscriptionService {
  final String _baseUrl = 'https://ocean-learn-api.rplrus.com';
  
  /// Makes the API call to create a subscription and returns the Xendit invoice URL
  Future<String?> createSubscription() async {
    final url = Uri.parse('$_baseUrl/api/v1/subscription');
    
    try {
      // Get user token from your auth system
      String token = await _getUserToken();
      
      print('Using token for API call: $token');
      
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      
      // If testing with Postman worked, add additional headers if needed
      // headers['X-Custom-Header'] = 'value';
      
      final response = await http.post(
        url,
        headers: headers,
      );
      
      print('API URL called: ${url.toString()}');
      print('Response status code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final invoiceUrl = data['invoice_url'];
        return invoiceUrl;
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        
        // If authentication is the issue, you might want to trigger a login flow
        if (response.statusCode == 401) {
          print('Authentication failed - user may need to login again');
          // Implement your authentication refresh logic here
        }
        
        return null;
      }
    } catch (e) {
      print('Exception during API call: ${e.toString()}');
      throw e;
    }
  }
  
  /// Get the user's authentication token - implement based on your auth system
  Future<String> _getUserToken() async {
    try {
      // For testing: Try to get the token from your app's auth system
      // This is a simplified example - replace with your actual token retrieval
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedToken = prefs.getString('user_token');
      
      if (storedToken != null && storedToken.isNotEmpty) {
        return storedToken;
      }
      
      // If no token found, use your test token or prompt user to login
      // For testing purposes only! In production, handle this properly
      return 'Qq4VZSRuCObeVZ0DbKmeCe2N7O1sLPImO65TgR59eeceded2';
    } catch (e) {
      print('Error getting token: $e');
      // Return a testing token as fallback
      return 'Qq4VZSRuCObeVZ0DbKmeCe2N7O1sLPImO65TgR59eeceded2';
    }
  }
}