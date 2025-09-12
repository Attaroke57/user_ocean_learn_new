import 'dart:convert';
import 'package:http/http.dart' as http;

class LessonService {
  static const String _baseUrl = 'https://api.momentumoceanlearn.com/api/v1/user/course';

  // Ambil semua course
  static Future<Map<String, dynamic>?> fetchCourses() async {
    final response = await http.get(Uri.parse('$_baseUrl/index'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('❌ Failed to fetch courses: ${response.statusCode}');
      print(response.body);
      return null;
    }
  }

  // Ambil detail course berdasarkan ID
  static Future<Map<String, dynamic>?> fetchLessonDetail(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/show/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('❌ Failed to fetch lesson detail: ${response.statusCode}');
      print(response.body);
      return null;
    }
  }
}
