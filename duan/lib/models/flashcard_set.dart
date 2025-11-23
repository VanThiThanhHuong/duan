import 'vocabulary.dart';

class FlashcardSet {
  final String title;
  final String description;
  final List<Vocabulary> vocabList;
  final int participants; // số người tham gia
  final double progress;

  FlashcardSet({
    required this.title,
    required this.description,
    required this.vocabList,
    required this.participants,
    this.progress = 0.0,
  });
}
