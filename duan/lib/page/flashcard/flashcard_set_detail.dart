import 'package:flutter/material.dart';
import '../../models/flashcard_set.dart';
import 'flashcard_study_page.dart';
import 'flashcard_quiz_page.dart';
import 'flashcard_typing_page.dart';
import 'package:flutter_tts/flutter_tts.dart';

final FlutterTts _flutterTts = FlutterTts();

class FlashcardSetDetailPage extends StatelessWidget {
  final FlashcardSet set;

  const FlashcardSetDetailPage({super.key, required this.set});

  Future<void> _speak(String text) async {
    try {
      await _flutterTts.setLanguage("ja-JP");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.stop();
      await _flutterTts.speak(text);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // Gradient AppBar
      appBar: AppBar(
        backgroundColor: Colors.orange.shade400,
        title: Text(
          set.title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // --- Description card ---
            if (set.description.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Text(
                  set.description,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // --- Study Modes Title ---
            const Text(
              "Study Modes",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // --- Study Modes ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _modeCard(
                  icon: Icons.view_carousel,
                  label: "Flashcard",
                  colors: [Colors.blue, Colors.indigo],
                  page: FlashcardStudyPage(vocabList: set.vocabList),
                  context: context,
                ),
                _modeCard(
                  icon: Icons.quiz,
                  label: "Quiz",
                  colors: [Colors.orange, Colors.deepOrange],
                  page: FlashcardQuizPage(vocabList: set.vocabList),
                  context: context,
                ),
                _modeCard(
                  icon: Icons.keyboard,
                  label: "Typing",
                  colors: [Colors.green, Colors.teal],
                  page: FlashcardTypingPage(vocabList: set.vocabList),
                  context: context,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // --- Vocabulary Title ---
            Text(
              "Vocabulary (${set.vocabList.length})",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // --- Vocabulary list ---
            ...set.vocabList.asMap().entries.map((entry) {
              final i = entry.key;
              final vocab = entry.value;
              return _vocabCard(vocab, i);
            }),
          ],
        ),
      ),
    );
  }

  // ---------------------- Study Mode Card ----------------------

  Widget _modeCard({
    required IconData icon,
    required String label,
    required List<Color> colors,
    required Widget page,
    required BuildContext context,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: colors.first.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Icon(icon, color: colors.last, size: 30),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: colors.last,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------- Vocabulary Card ----------------------

  Widget _vocabCard(dynamic vocab, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vocab.word,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(vocab.romaji, style: const TextStyle(color: Colors.grey)),
                Text(vocab.meaning,
                    style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),

          // Sound icon
          IconButton(
            icon:
                const Icon(Icons.volume_up_rounded, color: Colors.indigo, size: 28),
            onPressed: () => _speak(vocab.word),
          ),
        ],
      ),
    );
  }
}
