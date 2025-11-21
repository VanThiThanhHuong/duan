import 'package:flutter/material.dart';
import '../../models/vocabulary.dart';

class FlashcardTypingPage extends StatefulWidget {
  final List<Vocabulary> vocabList;

  const FlashcardTypingPage({
    super.key,
    required this.vocabList,
  });

  @override
  State<FlashcardTypingPage> createState() => _FlashcardTypingPageState();
}

class _FlashcardTypingPageState extends State<FlashcardTypingPage> {
  int currentIndex = 0;
  int score = 0;
  String feedback = "";
  final TextEditingController _controller = TextEditingController();

  void checkAnswer() {
    final userAnswer = _controller.text.trim().toLowerCase();
    final correct = widget.vocabList[currentIndex].word;

    setState(() {
      if (userAnswer == correct) {
        score++;
        feedback = "✅ Chính xác!";
      } else {
        feedback = "❌ Sai! Đáp án: $correct";
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (currentIndex < widget.vocabList.length - 1) {
        setState(() {
          currentIndex++;
          feedback = "";
          _controller.clear();
        });
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Hoàn thành"),
            content: Text("Bạn được $score/${widget.vocabList.length} câu đúng."),
            actions: [
              TextButton(
                onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                child: const Text("OK"),
              )
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vocab = widget.vocabList[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("⌨️ Gõ từ"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (currentIndex + 1) / widget.vocabList.length,
            ),
            const SizedBox(height: 20),

            Text(
              "Nghĩa: ${vocab.meaning} (${vocab.romaji})",
              style: const TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Nhập từ bằng tiếng Nhật...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => checkAnswer(),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: checkAnswer,
              child: const Text("Xác nhận"),
            ),

            const SizedBox(height: 20),

            Text(
              feedback,
              style: TextStyle(
                fontSize: 18,
                color: feedback.startsWith("✅") ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
