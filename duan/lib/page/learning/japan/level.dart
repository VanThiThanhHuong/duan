import 'package:flutter/material.dart';
class LevelSelectionPage extends StatelessWidget {
  final int unlockedLevel;
  const LevelSelectionPage({super.key, required this.unlockedLevel});

  final List<String> levels = const [
    "Beginner (Dưới N5)",
    "Elementary (JLPT N5)",
    "Pre-Intermediate (JLPT N4)",
    "Intermediate (JLPT N3)"
  ];

  final List<Color> levelColors = const [
    Color(0xFFFFCDD2),
    Color(0xFFFFAB91),
    Color(0xFF81D4FA),
    Color(0xFFA5D6A7),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📚 Các Cấp Độ Học"),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: levels.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemBuilder: (context, index) {
            bool isUnlocked = index + 1 <= unlockedLevel;
            return GestureDetector(
              onTap: isUnlocked
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text("Mở khóa: ${levels[index]} – Học thôi!")),
                      );
                    }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color: levelColors[index].withOpacity(0.8),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      levels[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isUnlocked ? Colors.white : Colors.white70,
                      ),
                    ),
                    if (!isUnlocked)
                      const Positioned(
                        bottom: 10,
                        child: Icon(Icons.lock, color: Colors.white, size: 28),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}