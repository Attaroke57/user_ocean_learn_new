import 'package:flutter/material.dart';
import 'package:user_ocean_learn/Model/course_model.dart';

class NotesSection extends StatelessWidget {
  final CourseModel course;
  final bool isNoteVisible;

  const NotesSection({
    Key? key,
    required this.course,
    required this.isNoteVisible,
  }) : super(key: key);

  @override
  @override
Widget build(BuildContext context) {
  print('[DEBUG] course.note: "${course.note}"');
  if (course.note.isEmpty) return const SizedBox.shrink(); // hilangkan `|| isNoteVisible`

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Note",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(course.note),
      ],
    ),
  );
}

}