import 'package:flutter/material.dart';
import '../../models/vocabulary.dart';

class FlashcardTypingPage extends StatefulWidget {
  final List<Vocabulary> vocabList;

  const FlashcardTypingPage({super.key, required this.vocabList});

  @override
  State<FlashcardTypingPage> createState() => _FlashcardTypingPageState();
}

class _FlashcardTypingPageState extends State<FlashcardTypingPage> {
  int currentIndex = 0;
  int score = 0;

  bool showResult = false;
  bool isCorrect = false;
  String feedback = "";

  final TextEditingController _controller = TextEditingController();

  void checkAnswer() {
    if (showResult) return;

    final userAnswer = _controller.text.trim().toLowerCase();
    final correct = widget.vocabList[currentIndex].word.toLowerCase();

    setState(() {
      showResult = true;
      isCorrect = userAnswer == correct;

      if (isCorrect) {
        score++;
        feedback = "Đúng rồi!";
      } else {
        feedback = "Sai rồi!\nĐáp án đúng: ${widget.vocabList[currentIndex].word}";
      }
    });

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (currentIndex < widget.vocabList.length - 1) {
        setState(() {
          currentIndex++;
          showResult = false;
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
              ),
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Typing Flashcard"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// PROGRESS BAR
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (currentIndex + 1) / widget.vocabList.length,
                minHeight: 8,
                color: Colors.orange,
                backgroundColor: Colors.orange.shade100,
              ),
            ),
            const SizedBox(height: 20),

            /// FLASHCARD
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade200.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    vocab.meaning,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    vocab.romaji,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// INPUT + BUTTON
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// INPUT
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: showResult ? Colors.grey.shade200 : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.shade100.withOpacity(0.6),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: _controller,
                    enabled: !showResult,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      hintText: "Nhập từ tiếng Nhật...",
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => checkAnswer(),
                  ),
                ),

                const SizedBox(height: 12),

                /// BUTTON
                SizedBox(
                  height: 50,
                  child: Opacity(
                    opacity: showResult ? 0.5 : 1,
                    child: ElevatedButton(
                      onPressed: showResult ? null : checkAnswer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Xác nhận",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ICON + FEEDBACK — Ở DƯỚI CÙNG
            Expanded(
              child: Column(
                children: [
                  /// ICON
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: showResult
                          ? FittedBox(
                              key: ValueKey(isCorrect),
                              fit: BoxFit.contain,
                              child: Image.asset(
                                isCorrect
                                    ? "lib/image/dung.png"
                                    : "lib/image/sai.png",
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),

                  /// FEEDBACK TEXT
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: feedback.isNotEmpty
                        ? Text(
                            feedback,
                            key: ValueKey(feedback),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isCorrect ? Colors.green : Colors.red,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
