import 'package:flutter/material.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage("lib/image/logo.png"), // thay avatar user
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Hi, Alex!",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("LinguaSquirrel",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Icon(Icons.notifications_none, size: 28),
                      SizedBox(width: 12),
                      Icon(Icons.settings, size: 28),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),

              // --- Continue Learning card ---
              Container(
                decoration: BoxDecoration(
                  color: Colors.deepOrange.shade400,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Text info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Continue Learning",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          const SizedBox(height: 10),
                          const Text(
                            "Business English: Module 3\n12 minutes remaining",
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.deepOrange,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {},
                            child: const Text("Continue"),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Illustration
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset("lib/image/logo.png"), // thêm ảnh minh hoạ
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- Stats card ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 3))
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("🔥 24-day streak",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                          Text("Weekly complete 70%"),
                          SizedBox(height: 6),
                          Text("⭐ 1,240 XP",
                              style: TextStyle(color: Colors.orange)),
                        ],
                      ),
                    ),
                    const Icon(Icons.bar_chart, size: 40, color: Colors.orange),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- Quick Practice ---
              const Text("Quick Practice",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _quickPracticeBox(Icons.book, Colors.orange),
                  _quickPracticeBox(Icons.question_answer, Colors.purple),
                  _quickPracticeBox(Icons.mic, Colors.green),
                ],
              ),
              const SizedBox(height: 20),

              // --- Today's Goals ---
              const Text("Today's Goals",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _goalChip("Complete daily lesson", true),
                  _goalChip("Review 10 flashcards", true, progress: "7/10"),
                  _goalChip("Practice speaking", false),
                ],
              ),
              const SizedBox(height: 20),

              // --- Recommended Paths ---
              const Text("Recommended Paths",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Expanded(
                    child: _pathCard("Business English", "20/60", "lib/image/logo.png"),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _pathCard("Travel Essentials", "7/10", "lib/image/logo.png"),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _pathCard("Academic Writing", "10/20", "lib/image/logo.png"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Widget nhỏ tái sử dụng ---

Widget _quickPracticeBox(IconData icon, Color color) {
  return Container(
    height: 60,
    width: 60,
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(icon, color: color, size: 30),
  );
}

class _goalChip extends StatelessWidget {
  final String text;
  final bool completed;
  final String? progress;

  const _goalChip(this.text, this.completed, {this.progress, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: completed ? Colors.green.withOpacity(0.1) : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              completed ? Icons.check_circle : Icons.circle_outlined,
              color: completed ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 6),
            Text(
              progress != null ? "$text\n$progress complete" : text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}

class _pathCard extends StatelessWidget {
  final String title;
  final String progress;
  final String image;

  const _pathCard(this.title, this.progress, this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 60, child: Image.asset(image, fit: BoxFit.contain)),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text("$progress complete",
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
