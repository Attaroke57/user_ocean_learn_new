import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_ocean_learn/Model/course_model.dart';
import 'package:user_ocean_learn/Services/CourseService.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/CoursePage/LessonCard.dart';

class CourseDetailPage extends StatefulWidget {
  final CourseModel course;
  final CourseService lessonService;

  const CourseDetailPage({
    Key? key,
    required this.course,
    required this.lessonService,
  }) : super(key: key);

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  bool _isNoteVisible = false;
  bool _isLoading = false;
  bool _isStudent = false;
  late TextEditingController _noteController;
  late CourseModel _currentCourse;

  @override
  void initState() {
    super.initState();
    _currentCourse = widget.course;
    _noteController = TextEditingController(text: widget.course.note);
    _checkAdminStatus();
    _isStudent = true;
    _loadCourseDetail();
  }

  Future<void> _checkAdminStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role') ?? '';
    debugPrint('[DEBUG] ROLE FROM PREFS: $role');

    // Ini triknya: paksa rebuild setelah 100ms
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isStudent = role.toLowerCase() == 'student';
          debugPrint('[DEBUG] _isAdmin di setState: $_isStudent');
        });
      }
    });
  }

  Future<void> _loadCourseDetail() async {
  setState(() {
    _isLoading = true;
  });

  final courseDetail =
      await widget.lessonService.getCourseDetail(_currentCourse.id);

  if (courseDetail != null) {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role') ?? 'visitor';

    if (courseDetail.isLocked && role.toLowerCase() == 'visitor') {
      // ❌ Pengguna visitor tidak boleh akses
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kamu belum premium!'),
          backgroundColor: Colors.redAccent,
        ),
      );

      Navigator.pop(context); // kembali ke halaman sebelumnya
      return;
    }

    setState(() {
      _currentCourse = courseDetail;
      _noteController.text = courseDetail.note;
    });
  }

  setState(() {
    _isLoading = false;
  });
}


  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('[DEBUG] BUILD UI - _isStudent: $_isStudent');
    return Scaffold(
      backgroundColor: netralcolor,
      appBar: AppBar(
        backgroundColor: netralcolor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _currentCourse.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  LessonCard(course: _currentCourse),
                  const SizedBox(height: 20),
                  if (_isStudent)
                  const SizedBox(height: 16),
                  // NotesSection(
                  //     course: _currentCourse, isNoteVisible: _isNoteVisible),
                ],
              ),
            ),
    );
  }
}
