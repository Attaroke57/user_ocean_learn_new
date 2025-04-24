import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_ocean_learn/Model/course_model.dart';
import 'package:user_ocean_learn/Page/LessonPage/LessonTitle.dart';
import 'package:user_ocean_learn/Services/CourseService.dart';

class LessonList extends StatelessWidget {
  final List<CourseModel> lessons;
  final CourseService courseService;
  final Future<void> Function(int) onRefresh;

  const LessonList({
    super.key,
    required this.lessons,
    required this.courseService,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        final formattedDate = DateFormat('MMMM d yyyy').format(lesson.date);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            title: Text(
              lesson.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              formattedDate,
              style: const TextStyle(color: Colors.black54),
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailPage(
                    course: lesson,
                    lessonService: courseService,
                  ),
                ),
              );
              onRefresh(courseService.currentPage);
            },
            // trailing: IconButton(
            //   icon: const Icon(Icons.more_vert),
            //   onPressed: () => _showOptionsMenu(context, () async {
            //     await courseService.deleteLesson(lesson.id);
            //     onRefresh(courseService.currentPage);
            //   }),
            // ),
          ),
        );
      },
    );
  }

  

}