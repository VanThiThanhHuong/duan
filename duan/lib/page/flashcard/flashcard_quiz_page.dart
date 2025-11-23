import 'package:flutter/material.dart';
import '../../models/vocabulary.dart';
import 'dart:math';

class FlashcardQuizPage extends StatefulWidget {
  final List<Vocabulary> vocabList;

  const FlashcardQuizPage({super.key, required this.vocabList});

  @override
  State<FlashcardQuizPage> createState() => _FlashcardQuizPageState();
}

class _FlashcardQuizPageState extends State<FlashcardQuizPage> {
  int currentIndex = 0;
  int score = 0;
  String feedback = "";
  String? selectedAnswer;
  bool showResult = false;

  late List<String> options;

  @override
  void initState() {
    super.initState();
    options = getOptions(widget.vocabList[currentIndex]);
  }

  List<String> getOptions(Vocabulary correct) {
    final random = Random();
    final list = <String>[correct.meaning];

    while (list.length < 4) {
      final randomWord =
          widget.vocabList[random.nextInt(widget.vocabList.length)].meaning;

      if (!list.contains(randomWord)) {
        list.add(randomWord);
      }
    }

    list.shuffle();
    return list;
  }

  String generateComment(bool isCorrect) {
    final random = Random();
    final correctComments = [
      "Tốt lắm! Bạn đang tiến bộ rất nhanh!",
      "Xuất sắc! Tiếp tục duy trì nhé!",
      "Trả lời đúng rồi, tuyệt vời!",
      "Giỏi quá! Bạn nhớ từ vựng rất tốt!"
    ];

    final wrongComments = [
      "Không sao, tiếp tục cố gắng nhé!",
      "Sai rồi… nhưng bạn sẽ nhớ lâu hơn!",
      "Đừng bỏ cuộc! Cố thêm chút nữa!",
      "Sai một chút nhưng không vấn đề gì!"
    ];

    return isCorrect
        ? correctComments[random.nextInt(correctComments.length)]
        : wrongComments[random.nextInt(wrongComments.length)];
  }

  void checkAnswer(String answer) {
    final correct = widget.vocabList[currentIndex];
    final isCorrect = answer == correct.meaning;

    setState(() {
      selectedAnswer = answer;
      showResult = true;
      feedback = isCorrect ? "Đúng" : "Sai";
      if (isCorrect) score++;
    });

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (currentIndex < widget.vocabList.length - 1) {
        setState(() {
          currentIndex++;
          selectedAnswer = null;
          showResult = false;
          feedback = "";
          options = getOptions(widget.vocabList[currentIndex]);
        });
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Hoàn thành"),
            content:
                Text("Bạn được $score/${widget.vocabList.length} câu đúng."),
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

  Color getOptionColor(String option, String correct) {
    if (selectedAnswer == null) return Colors.white;

    if (option == selectedAnswer) {
      if (!showResult) return Colors.orange.shade100;

      return option == correct
          ? Colors.green.shade300
          : Colors.red.shade300;
    }

    if (showResult && option == correct) return Colors.green.shade300;

    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final vocab = widget.vocabList[currentIndex];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Flashcard Quiz"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress bar
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

            // Card từ vựng
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade200.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    vocab.word,
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    vocab.romaji,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Options
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final opt = options[index];
                  final color = getOptionColor(opt, vocab.meaning);

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.shade100.withOpacity(0.5),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        opt,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      onTap: selectedAnswer == null
                          ? () => checkAnswer(opt)
                          : null,
                    ),
                  );
                },
              ),
            ),

            // Feedback mới: hiện hình + bình luận tự động
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: showResult
                  ? Column(
                      key: ValueKey(feedback),
                      children: [
                        Image.asset(
                          feedback == "Đúng"
                              ? "lib/image/dung.png"
                              : "lib/image/sai.png",
                          width: 250,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          generateComment(feedback == "Đúng"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: feedback == "Đúng"
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
