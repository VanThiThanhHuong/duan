import 'package:flutter/material.dart';

class CourseDetailPage extends StatefulWidget {
  final String courseTitle;
  final List<String> lessons;

  const CourseDetailPage({
    super.key,
    required this.courseTitle,
    required this.lessons,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  late List<bool> completed;

  @override
  void initState() {
    super.initState();
    completed = List.generate(widget.lessons.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    double progress = completed.where((e) => e).length / widget.lessons.length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // --- Header hiện đại ---
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            backgroundColor: const Color(0xFF6C63FF),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.courseTitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    "lib/image/logo.png",
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xAA000000), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- Progress ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF6C63FF), // tím chủ đạo
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tiến độ: ${(progress * 100).toStringAsFixed(0)}%",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF333333)),
                  ),
                ],
              ),
            ),
          ),

          // --- Danh sách bài học ---
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                bool isDone = completed[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor:
                          isDone ? Colors.green[100] : Colors.purple[100],
                      child: Icon(
                        isDone ? Icons.check : Icons.menu_book_rounded,
                        color: isDone ? Colors.green[700] : Colors.purple[700],
                      ),
                    ),
                    title: Text(
                      widget.lessons[index],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: isDone
                            ? Colors.grey[500]
                            : const Color(0xFF333333),
                      ),
                    ),
                    subtitle: Text(
                      isDone ? "Đã hoàn thành" : "Chưa học",
                      style: TextStyle(
                        fontSize: 13,
                        color: isDone ? Colors.green[600] : Colors.grey[500],
                      ),
                    ),
                    trailing: isDone
                        ? const Icon(Icons.verified_rounded,
                            color: Colors.green, size: 28)
                        : FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 8),
                            ),
                            onPressed: () {
                              setState(() {
                                completed[index] = true;
                              });
                            },
                            child: const Text("Học",
                                style: TextStyle(color: Colors.white)),
                          ),
                  ),
                );
              },
              childCount: widget.lessons.length,
            ),
          ),
        ],
      ),
    );
  }
}
