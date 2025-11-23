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

    // Cập nhật EF
    ef = ef + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    if (ef < 1.3) ef = 1.3;

    final nextReview =
        DateTime.now().add(Duration(days: interval)).millisecondsSinceEpoch;
    final userId = FirebaseAuth.instance.currentUser!.uid;

    if (widget.isPersonal) {
      // -------- Personal Flashcard --------
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
      // -------- Community Flashcard --------
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
          const SizedBox(height: 30),

          // ------------------ COUNTER ------------------
          Text(
            "${currentIndex + 1} / ${widget.vocabList.length}",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),

          // ------------------ SRS BUTTONS ------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _srsButton("Khó", Colors.red, () => updateSRS(v, 2)),
              _srsButton("Tạm ổn", Colors.orange, () => updateSRS(v, 4)),
              _srsButton("Dễ", Colors.green, () => updateSRS(v, 5)),
            ],
          ),
          const SizedBox(height: 20),

          // ------------------ NAV BUTTONS ------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navButton(Icons.arrow_back, prevCard),
              _navButton(Icons.arrow_forward, nextCard),
            ],
          )
        ],
      ),
    );
  }

  // ---------- UI Helper Buttons ----------
  Widget _srsButton(String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
