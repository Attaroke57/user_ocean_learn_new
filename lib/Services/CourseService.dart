import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:user_ocean_learn/Model/Member_model.dart';
import 'package:user_ocean_learn/Model/course_model.dart';
import 'package:user_ocean_learn/Page/LoginPage/LoginController.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

class CourseService {
  static const String baseUrl = 'https://api.momentumoceanlearn.com/api/v1';
  List<CourseModel> _courses = [];

  int _currentPage = 1;
  int _totalPages = 1;

  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  String? getToken() => UserStorage.getToken();

  String getUserRole() => UserStorage.getRole() ?? '';
  String getSubscription() => UserStorage.getMembershipStatus();

  Future<void> loadLessons(int page) async {
    final token = getToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/course/index?page=$page'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == true && jsonData['data'] != null) {
          final userRole = getUserRole();
          final subscription = getSubscription();
          _courses = (jsonData['data'] as List)
              .map((courseJson) => CourseModel.fromApiJson(courseJson, userRole, subscription))
              .toList();

          _currentPage = jsonData['meta']['current_page'] ?? page;
          _totalPages = jsonData['meta']['last_page'] ?? 1;
        }
        print('Courses loaded successfully: ${_courses.length}');
      } else if (response.statusCode == 401) {
        print('Unauthorized access. Token may be expired.');
        LoginController().logout();
      } else {
        print('Failed to load courses: ${response.body}');
      }
    } catch (e) {
      print('Error loading courses: $e');
    }
  }

  List<CourseModel> getLessons() => _courses;

  

  

  Future<CourseModel?> getCourseDetail(String courseId) async {
    final token = getToken();
    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/course/$courseId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == true && jsonData['data'] != null) {
          return CourseModel.fromApiJson(jsonData['data'], getUserRole(), getSubscription());
        }
      }
    } catch (e) {
      print('Error getting course detail: $e');
    }
    return null;
  }

  bool isInSameWeek(DateTime date1, DateTime date2) {
    final startOfWeek1 = date1.subtract(Duration(days: date1.weekday - 1));
    final startOfWeek2 = date2.subtract(Duration(days: date2.weekday - 1));
    return startOfWeek1.year == startOfWeek2.year &&
        startOfWeek1.month == startOfWeek2.month &&
        startOfWeek1.day == startOfWeek2.day;
  }

  bool isLessonExistInWeek(DateTime dateToCheck, {String? excludeCourseId}) {
    return _courses.any((course) {
      if (excludeCourseId != null && course.id == excludeCourseId) {
        return false;
      }
      return isInSameWeek(course.date, dateToCheck);
    });
  }

  // Get course by QR code URL
  CourseModel? getCourseByQRCode(String qrData) {
    try {
      final uri = Uri.parse(qrData);
      final courseId = uri.queryParameters['course_id'] ?? uri.queryParameters['class_id'];
      
      if (courseId == null) return null;
      
      return _courses.firstWhere(
        (course) => course.id == courseId,
        orElse: () => CourseModel(
          id: '',
          title: '',
          description: '',
          filePath: '',
          date: DateTime.now(),
          isLocked: true,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  // Validate if QR code belongs to expected course
  bool validateQRCourseMatch(String qrData, String expectedCourseId) {
    final course = getCourseByQRCode(qrData);
    return course != null && course.id == expectedCourseId && course.id.isNotEmpty;
  }
}
