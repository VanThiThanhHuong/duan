import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../models/vocabulary.dart';

class FlashcardStudyPage extends StatefulWidget {
  final List<Vocabulary> vocabList;

  const FlashcardStudyPage({super.key, required this.vocabList});

  @override
  State<FlashcardStudyPage> createState() => _FlashcardStudyPageState();
}

class _FlashcardStudyPageState extends State<FlashcardStudyPage> {
  int currentIndex = 0;
  bool showMeaning = false;
  final FlutterTts tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    tts.setLanguage("ja-JP"); // hoặc en-US tuỳ bộ từ
    tts.setSpeechRate(0.4);
    tts.setPitch(1.1);
  }

  void speak(String text) {
    tts.speak(text);
  }

  void nextCard() {
    setState(() {
      if (currentIndex < widget.vocabList.length - 1) {
        currentIndex++;
        showMeaning = false;
      }
    });
  }

  void prevCard() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        showMeaning = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vocab = widget.vocabList[currentIndex];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Flashcard",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange.shade400,
        elevation: 0,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Flashcard
          GestureDetector(
            onTap: () => setState(() => showMeaning = !showMeaning),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              height: 270,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade200.withOpacity(0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Từ hiển thị
                  Text(
                    showMeaning
                        ? "${vocab.romaji}\n${vocab.meaning}"
                        : vocab.word,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Nút loa phát âm
                  IconButton(
                    icon: Icon(Icons.volume_up_rounded,
                        size: 40, color: Colors.orange.shade400),
                    onPressed: () => speak(vocab.word),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Counter
          Text(
            "${currentIndex + 1} / ${widget.vocabList.length}",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Previous
              ElevatedButton(
                onPressed: prevCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),

              // Next
              ElevatedButton(
                onPressed: nextCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                ),
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}
