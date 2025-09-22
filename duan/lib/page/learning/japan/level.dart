import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LevelSelectionPage extends StatefulWidget {
  final int? unlockedLevel;
  const LevelSelectionPage({super.key, this.unlockedLevel});

  @override
  State<LevelSelectionPage> createState() => _LevelSelectionPageState();
}

class _LevelSelectionPageState extends State<LevelSelectionPage> {
  int unlockedLevel = 1;
  int xp = 0; // 🔹 bạn có thể lưu XP trong Firestore để sync

  final List<Map<String, dynamic>> courses = const [
    {
      "title": "Beginner",
      "subtitle": "Chưa quen bảng chữ, cần học từ đầu (≈ dưới N5)\n8 bài",
      "icon": Icons.school,
    },
    {
      "title": "Elementary",
      "subtitle": "Biết chữ cái, từ cơ bản (JLPT N5)\n20 bài",
      "icon": Icons.chat,
    },
    {
      "title": "Pre-Intermediate",
      "subtitle": "Có vốn từ, ngữ pháp căn bản (JLPT N4)\n25 bài",
      "icon": Icons.text_fields,
    },
    {
      "title": "Intermediate",
      "subtitle": "Nắm chắc nền tảng (JLPT N3)\n30 bài",
      "icon": Icons.business_center,
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.unlockedLevel != null) {
      unlockedLevel = widget.unlockedLevel!;
    } else {
      _loadUnlockedLevel();
    }
  }

  /// 🔹 Lấy dữ liệu unlockedLevel + XP từ Firestore
  Future<void> _loadUnlockedLevel() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        setState(() {
          unlockedLevel = (data["unlockedLevel"] ?? 1) as int;
          xp = (data["xp"] ?? 0) as int;
        });
      }
    } catch (e) {
      debugPrint("Lỗi load unlockedLevel: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 Tính progress dựa trên unlockedLevel (vd: 4 course => 25% mỗi course)
    double progress = unlockedLevel / courses.length;
    if (progress > 1) progress = 1;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Japanese Courses",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // --- Header với level, progress ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "語語てとる",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
                const Text("Select a course to begin",
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Level $unlockedLevel",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    Text("$xp XP",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    color: Colors.orange,
                    backgroundColor: Colors.grey[300],
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),

          // --- Grid Courses ---
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: courses.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 200,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemBuilder: (context, index) {
                var course = courses[index];
                bool isUnlocked = (index + 1) <= unlockedLevel;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 6,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(course["icon"],
                          size: 50,
                          color: isUnlocked
                              ? Colors.orange
                              : Colors.grey.shade400),
                      const SizedBox(height: 10),
                      Text(
                        course["title"],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isUnlocked
                              ? Colors.black87
                              : Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          course["subtitle"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: isUnlocked
                                ? Colors.orange
                                : Colors.grey.shade400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (isUnlocked)
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text("Bắt đầu ${course['title']}")));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text("Start"),
                        )
                      else
                        const Icon(Icons.lock,
                            color: Colors.grey, size: 28),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
