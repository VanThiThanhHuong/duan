import 'vocabulary.dart';

class FlashcardSet {
  final String title;
  final String description;
  final List<Vocabulary> vocabList;

  FlashcardSet({
    required this.title,
    required this.description,
    required this.vocabList,
  });
}
