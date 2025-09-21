import 'package:flutter/material.dart';

class LevelSelectionPage extends StatelessWidget {
  final int unlockedLevel;
  const LevelSelectionPage({super.key, required this.unlockedLevel});

  final List<Map<String, dynamic>> courses = const [
    {
      "title": "Beginner Japanese",
      "subtitle": "Recommended",
      "icon": Icons.school,
      "status": "start",
    },
    {
      "title": "Everyday Phrases",
      "subtitle": "Popular",
      "icon": Icons.chat,
      "status": "start",
    },
    {
      "title": "Hiragana & Katakana\nKanji Foundations",
      "subtitle": "",
      "icon": Icons.text_fields,
      "status": "lock",
    },
    {
      "title": "Business Japanese",
      "subtitle": "",
      "icon": Icons.business_center,
      "status": "lock",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Japanese Courses",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        
      ),
      body: Column(
        children: [
          // --- Header với level, progress ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text("語語てとる",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
                const Text("Select a course to begin",
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Beginner Level 1",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    Text("0 XP",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.2,
                  color: Colors.orange,
                  backgroundColor: Colors.grey[300],
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(10),
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
                mainAxisExtent: 180,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemBuilder: (context, index) {
                var course = courses[index];
                bool isUnlocked = index < unlockedLevel;

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
                      const SizedBox(height: 10),
                      if (isUnlocked)
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Bắt đầu ${course['title']}")));
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
                      if (course["subtitle"] != "" && isUnlocked)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(course["subtitle"],
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.orange)),
                        )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
