import 'package:flutter/material.dart';
import 'course_detail_page.dart';
import 'widgets/level_card.dart';

class LanguageCoursesPage extends StatelessWidget {
  final String language;
  const LanguageCoursesPage({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> levels = [
      {"title": "Beginner", "unlocked": true},
      {"title": "Intermediate", "unlocked": false},
      {"title": "Advanced", "unlocked": false},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("$language Courses"),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: levels.length,
        itemBuilder: (context, index) {
          final level = levels[index];
          final title = level["title"] as String;
          final unlocked = level["unlocked"] as bool;

          return LevelCard(
            title: title,
            unlocked: unlocked,
            onTap: () {
              if (unlocked) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CourseDetailPage(
                      language: language,
                      level: title,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("This level is locked 🔒"),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
