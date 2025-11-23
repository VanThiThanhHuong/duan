import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../models/vocabulary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FlashcardStudyPage extends StatefulWidget {
  final List<Vocabulary> vocabList;
  final String setId; // ID bộ flashcard
  final bool isPersonal; // true: Cá nhân, false: Cộng đồng

  const FlashcardStudyPage({
    super.key,
    required this.vocabList,
    required this.setId,
    required this.isPersonal,
  });

  @override
  State<FlashcardStudyPage> createState() => _FlashcardStudyPageState();
}

class _FlashcardStudyPageState extends State<FlashcardStudyPage> {
  int currentIndex = 0;
  bool showMeaning = false;
  bool isNext = true; // để xác định hướng slide
  final FlutterTts tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    tts.setLanguage("ja-JP");
    tts.setSpeechRate(0.4);
    tts.setPitch(1.1);
  }

  void speak(String text) => tts.speak(text);

  // ------------------ SRS Update Function ------------------
  Future<void> updateSRS(Vocabulary v, int quality) async {
    double ef = v.ef;
    int rep = v.repetition;
    int interval = v.interval;

    if (quality < 3) {
      rep = 0;
      interval = 1;
    } else {
      rep += 1;
      if (rep == 1) {
        interval = 1;
      } else if (rep == 2) {
        interval = 6;
      } else {
        interval = (interval * ef).round();
      }
    }

    ef = ef + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    if (ef < 1.3) ef = 1.3;

    final nextReview =
        DateTime.now().add(Duration(days: interval)).millisecondsSinceEpoch;
    final userId = FirebaseAuth.instance.currentUser!.uid;

    if (widget.isPersonal) {
      final doc = FirebaseFirestore.instance
          .collection('flashcards')
          .doc(userId)
          .collection('userFlashcards')
          .doc(widget.setId);

      final snapshot = await doc.get();
      List oldList = [];
      if (snapshot.exists) {
        oldList = List.from(snapshot.data()?['vocabList'] ?? []);
      }

      oldList.removeWhere((item) => item['word'] == v.word);
      oldList.add({
        "word": v.word,
        "romaji": v.romaji,
        "meaning": v.meaning,
        "ef": ef,
        "interval": interval,
        "repetition": rep,
        "nextReview": nextReview,
      });

      await doc.set({"vocabList": oldList}, SetOptions(merge: true));
    } else {
      final progressDoc = FirebaseFirestore.instance
          .collection('flashcard_sets')
          .doc(widget.setId)
          .collection('userProgress')
          .doc(userId);

      await progressDoc.set({
        "word": v.word,
        "romaji": v.romaji,
        "meaning": v.meaning,
        "ef": ef,
        "interval": interval,
        "repetition": rep,
        "nextReview": nextReview,
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    nextCard();
  }

  void nextCard() {
    setState(() {
      if (currentIndex < widget.vocabList.length - 1) {
        isNext = true;
        currentIndex++;
        showMeaning = false;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("🎉 Bạn đã hoàn thành tất cả thẻ!")),
        );
      }
    });
  }

  void prevCard() {
    setState(() {
      if (currentIndex > 0) {
        isNext = false;
        currentIndex--;
        showMeaning = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.vocabList[currentIndex];

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
          // ------------------ FLASHCARD ------------------
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                final offsetAnimation = Tween<Offset>(
                  begin: Offset(isNext ? 1.0 : -1.0, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                ));
                return SlideTransition(position: offsetAnimation, child: child);
              },
              child: GestureDetector(
                key: ValueKey(currentIndex),
                onTap: () => setState(() => showMeaning = !showMeaning),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  padding: const EdgeInsets.all(24),
                  height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
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
                      Text(
                        showMeaning ? "${v.romaji}\n${v.meaning}" : v.word,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      IconButton(
                        icon: Icon(Icons.volume_up_rounded,
                            size: 40, color: Colors.orange.shade400),
                        onPressed: () => speak(v.word),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ------------------ SRS BUTTONS ------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _srsButton("Khó", Colors.red, () => updateSRS(v, 2)),
                const SizedBox(width: 12),
                _srsButton("Tạm ổn", Colors.orange, () => updateSRS(v, 4)),
                const SizedBox(width: 12),
                _srsButton("Dễ", Colors.green, () => updateSRS(v, 5)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // ================= INDICATOR DOTS =================
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.vocabList.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == currentIndex ? 14 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == currentIndex
                      ? Colors.orange.shade400
                      : Colors.orange.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // ------------------ NAV BUTTONS ------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navButton(Icons.arrow_back, prevCard),
              _navButton(Icons.arrow_forward, nextCard),
            ],
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  // ---------- UI Helper Buttons ----------
  Widget _srsButton(String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.orange.shade300,
          boxShadow: [
            BoxShadow(
              color: Colors.orange.shade200,
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}
