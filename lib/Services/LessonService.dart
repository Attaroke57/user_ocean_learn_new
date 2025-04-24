import 'dart:convert';
import 'package:http/http.dart' as http;

class LessonService {
  static const String _baseUrl = 'https://ocean-learn-api.rplrus.com/api/v1/course/1';

  static Future<Map<String, dynamic>?> fetchLessonDetail(int courseId) async {
    final response = await http.get(Uri.parse('$_baseUrl/courses/$courseId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      print('Failed to fetch lesson detail: ${response.statusCode}');
      return null;
    }
  }
}
