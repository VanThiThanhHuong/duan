import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'japan/japanese_test_page.dart';
import 'japan/level.dart';

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  Future<int?> _getSavedLevel() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists && doc.data()!.containsKey('japanese_level')) {
      return doc['japanese_level'] as int;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final languages = [
      {
        "name": "Japanese",
        "description": "こんにちは!\n一緒に日本語を学びましょう。",
        "gradient": [
          const Color.fromARGB(255, 249, 160, 163),
          const Color(0xFFfad0c4)
        ],
        "lessons": "14 lessons • Trending",
        "image": "lib/image/logo.png",
      },
      {
        "name": "Korean",
        "description": "안녕하세요!\n재미있게 한국어를 배워요。",
        "gradient": [
          const Color.fromARGB(255, 185, 163, 238),
          const Color(0xFFfbc2eb)
        ],
        "lessons": "23 lessons • New course",
        "image": "lib/image/logo.png",
      },
      {
        "name": "Chinese",
        "description": "你好!\n一起学习中文吧。",
        "gradient": [
          const Color.fromARGB(255, 172, 243, 198),
          const Color.fromARGB(255, 161, 215, 241)
        ],
        "lessons": "20 lessons • Popular",
        "image": "lib/image/logo.png",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Chọn ngôn ngữ của bạn",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "Bắt đầu hành trình học tập ngay hôm nay",
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: lang["gradient"] as List<Color>,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  lang["image"] as String,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lang["name"] as String,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      lang["description"] as String,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      lang["lessons"] as String,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: () async {
                                  if (lang["name"] == "Japanese") {
                                    final savedLevel = await _getSavedLevel();
                                    if (savedLevel != null) {
                                      // Đã làm test → vào thẳng course
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              LevelSelectionPage(unlockedLevel: savedLevel),
                                        ),
                                      );
                                    } else {
                                      // Chưa làm test → làm test trước
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const JapaneseTestPage(),
                                        ),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Chưa có bài test cho ${lang["name"]}"),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  elevation: 3,
                                ),
                                child: const Text(
                                  "Start",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
