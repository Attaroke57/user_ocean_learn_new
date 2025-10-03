import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user_ocean_learn/Model/subscribtion_model.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

class Historyservice {
  static const String baseUrl = 'https://api.momentumoceanlearn.com/api/v1';
  
  // Fetch all subscriptions
  static Future<List<SubscriptionModel>> getSubscriptions() async {
    try {
      final token = UserStorage.getToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }
      
      print('🔗 Fetching subscriptions from: $baseUrl/subscription/history');
      
      final response = await http.get(
        Uri.parse('$baseUrl/subscription/history'),
        headers: {
          'Authorization': 'Bearer $token', 
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        // Map API response to SubscriptionModel
        List<SubscriptionModel> subscriptions = data.map((item) {
          // Create a properly structured JSON for SubscriptionModel
          Map<String, dynamic> mappedItem = {
            'id': item['uuid'].hashCode, // Generate ID from UUID hash
            'user_id': 0, // You might need to get this from elsewhere
            'status': item['status'] ?? '',
            'uuid': item['uuid'], // This becomes externalId
            'message': item['message'] ?? '',
            'detail': item['detail'] ?? {},
          };
          
          return SubscriptionModel.fromJson(mappedItem);
        }).toList();
        
        print('✅ Successfully parsed ${subscriptions.length} subscriptions');
        return subscriptions;
      } else {
        print('❌ Failed to load subscriptions: ${response.statusCode}');
        print('❌ Response body: ${response.body}');
        throw Exception('Failed to load subscriptions: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching subscriptions: $e');
      throw Exception('Error fetching subscriptions: $e');
    }
  }
  
  // Get subscriptions grouped by month and year
  static Future<Map<String, List<SubscriptionModel>>> getSubscriptionsByMonth() async {
    try {
      final subscriptions = await getSubscriptions();
      final Map<String, List<SubscriptionModel>> result = {};
      
      for (var subscription in subscriptions) {
        final key = '${subscription.month} ${subscription.year}';
        if (!result.containsKey(key)) {
          result[key] = [];
        }
        result[key]!.add(subscription);
      }
      
      // Sort the keys in descending order (most recent month first)
      final sortedKeys = result.keys.toList()..sort((a, b) {
        // Better sorting logic for month-year combinations
        try {
          DateTime dateA = _parseMonthYear(a);
          DateTime dateB = _parseMonthYear(b);
          return dateB.compareTo(dateA); // Descending order
        } catch (e) {
          return b.compareTo(a); // Fallback to string comparison
        }
      });
      
      // Create a new map with sorted keys
      final sortedResult = <String, List<SubscriptionModel>>{};
      for (var key in sortedKeys) {
        sortedResult[key] = result[key]!;
      }
      
      print('📊 Grouped subscriptions by month: ${sortedResult.keys}');
      return sortedResult;
    } catch (e) {
      print('❌ Error grouping subscriptions: $e');
      throw Exception('Error grouping subscriptions: $e');
    }
  }
  
  // Helper method to parse "Month Year" string to DateTime
  static DateTime _parseMonthYear(String monthYear) {
    List<String> parts = monthYear.split(' ');
    if (parts.length != 2) throw Exception('Invalid month-year format');
    
    String month = parts[0];
    int year = int.parse(parts[1]);
    
    int monthNum = _getMonthNumber(month);
    return DateTime(year, monthNum, 1);
  }
  
  static int _getMonthNumber(String month) {
    switch (month.toLowerCase()) {
      case 'january': return 1;
      case 'february': return 2;
      case 'march': return 3;
      case 'april': return 4;
      case 'may': return 5;
      case 'june': return 6;
      case 'july': return 7;
      case 'august': return 8;
      case 'september': return 9;
      case 'october': return 10;
      case 'november': return 11;
      case 'december': return 12;
      default: return 1;
    }
  }
}