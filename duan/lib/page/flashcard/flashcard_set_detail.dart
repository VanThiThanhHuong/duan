import 'package:flutter/material.dart';
import '../../models/flashcard_set.dart';
import '../../models/vocabulary.dart';
import 'flashcard_study_page.dart';
import 'flashcard_quiz_page.dart';
import 'flashcard_typing_page.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FlutterTts _flutterTts = FlutterTts();

class FlashcardSetDetailPage extends StatefulWidget {
  final FlashcardSet set;
  final bool isPersonal;

  const FlashcardSetDetailPage({
    super.key,
    required this.set,
    this.isPersonal = false,
  });

  @override
  State<FlashcardSetDetailPage> createState() =>
      _FlashcardSetDetailPageState();
}

class _FlashcardSetDetailPageState extends State<FlashcardSetDetailPage> {
  late List<Vocabulary> vocabList;

  @override
  void initState() {
    super.initState();
    vocabList = List.from(widget.set.vocabList);
  }

  Future<void> _speak(String text) async {
    try {
      await _flutterTts.setLanguage("ja-JP");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.stop();
      await _flutterTts.speak(text);
    } catch (_) {}
  }

  void addVocabulary(Vocabulary vocab) {
    setState(() {
      vocabList.add(vocab);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? "anonymous";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.orange.shade400,
        title: Text(
          widget.set.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      floatingActionButton: widget.isPersonal
          ? FloatingActionButton(
              backgroundColor: Colors.orange,
              onPressed: () =>
                  showAddVocabularySheet(context, userId: userId),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.set.description.isNotEmpty)
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
                    ),
                  ],
                ),
                child: Text(
                  widget.set.description,
                  style:
                      const TextStyle(color: Colors.black87, fontSize: 15),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              "Study Modes",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _modeCard(
                  icon: Icons.view_carousel,
                  label: "Flashcard",
                  colors: [Colors.blue, Colors.indigo],
                  page: FlashcardStudyPage(
                      vocabList: vocabList,
                      setId: widget.set.id,
                      isPersonal: widget.isPersonal),
                  context: context,
                ),
                _modeCard(
                  icon: Icons.quiz,
                  label: "Quiz",
                  colors: [Colors.orange, Colors.deepOrange],
                  page: FlashcardQuizPage(vocabList: vocabList),
                  context: context,
                ),
                _modeCard(
                  icon: Icons.keyboard,
                  label: "Typing",
                  colors: [Colors.green, Colors.teal],
                  page: FlashcardTypingPage(vocabList: vocabList),
                  context: context,
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              "Vocabulary (${vocabList.length})",
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...vocabList.asMap().entries.map((entry) {
              final i = entry.key;
              final vocab = entry.value;
              return _vocabCard(vocab, i);
            }),
          ],
        ),
      ),
    );
  }

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

  Widget _vocabCard(Vocabulary vocab, int index) {
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
                Text(
                  vocab.meaning,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.volume_up_rounded,
              color: Colors.indigo,
              size: 28,
            ),
            onPressed: () => _speak(vocab.word),
          ),
        ],
      ),
    );
  }

  void showAddVocabularySheet(BuildContext context,
      {required String userId}) {
    String word = '';
    String romaji = '';
    String meaning = '';
    bool loading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Thêm từ mới",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Từ",
                      labelStyle:
                          const TextStyle(fontWeight: FontWeight.w600),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.orange.shade200,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (v) => word = v,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Phát âm",
                      labelStyle:
                          const TextStyle(fontWeight: FontWeight.w600),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.orange.shade200,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (v) => romaji = v,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Nghĩa",
                      labelStyle:
                          const TextStyle(fontWeight: FontWeight.w600),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.orange.shade200,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (v) => meaning = v,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: loading
                          ? null
                          : () async {
                              if (word.trim().isEmpty ||
                                  meaning.trim().isEmpty) return;

                              setState(() => loading = true);

                              final newVocab = Vocabulary(
                                  word: word.trim(),
                                  romaji: romaji.trim(),
                                  meaning: meaning.trim());

                              try {
                                final vocabRef = FirebaseFirestore.instance
                                    .collection('flashcards')
                                    .doc(userId)
                                    .collection('userFlashcards')
                                    .doc(widget.set.id);

                                await vocabRef.set({
                                  "vocabList": FieldValue.arrayUnion([
                                    {
                                      "word": newVocab.word,
                                      "romaji": newVocab.romaji,
                                      "meaning": newVocab.meaning,
                                    }
                                  ])
                                }, SetOptions(merge: true));

                                addVocabulary(newVocab);

                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      "Thêm từ thành công!",
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                    backgroundColor:
                                        Colors.orange.shade100,
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(16),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Lỗi: $e"),
                                    backgroundColor: Colors.red.shade200,
                                  ),
                                );
                              } finally {
                                setState(() => loading = false);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: loading
                          ? const CircularProgressIndicator(
                              color: Colors.white)
                          : const Text(
                              "LƯU",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
