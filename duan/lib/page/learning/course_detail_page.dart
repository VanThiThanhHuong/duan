import 'package:flutter/material.dart';
import 'widgets/lesson_item.dart';

class CourseDetailPage extends StatelessWidget {
  final String language;
  final String level;
  const CourseDetailPage({
    super.key,
    required this.language,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> lessons = List.generate(
      8,
      (i) => {
        "title": "Lesson ${i + 1}",
        "completed": i < 3, // 3 bài đầu đã completed
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("$level - $language"),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          final title = lesson["title"] as String;
          final completed = lesson["completed"] as bool;

          return LessonItem(
            title: title,
            completed: completed,
            onTap: () {
              // TODO: Navigate to lesson content page
            },
          );
        },
      ),
    );
  }
}
