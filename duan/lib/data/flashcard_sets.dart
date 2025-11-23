import '../models/flashcard_set.dart';
import '../models/vocabulary.dart';

final List<FlashcardSet> communityFlashcardSets = [
  FlashcardSet(
    title: "🐶 Động vật",
    description: "Các loài vật cơ bản",
    participants: 240,
    vocabList: [
      Vocabulary(word: "犬", romaji: "inu", meaning: "con chó"),
      Vocabulary(word: "猫", romaji: "neko", meaning: "con mèo"),
      Vocabulary(word: "鳥", romaji: "tori", meaning: "con chim"),
      Vocabulary(word: "牛", romaji: "ushi", meaning: "con bò"),
      Vocabulary(word: "馬", romaji: "uma", meaning: "con ngựa"),
      Vocabulary(word: "豚", romaji: "buta", meaning: "con heo"),
      Vocabulary(word: "羊", romaji: "hitsuji", meaning: "con cừu"),
      Vocabulary(word: "魚", romaji: "sakana", meaning: "con cá"),
      Vocabulary(word: "猿", romaji: "saru", meaning: "con khỉ"),
      Vocabulary(word: "蛇", romaji: "hebi", meaning: "con rắn"),
    ],
  ),

  FlashcardSet(
    title: "🏫 Trường học",
    description: "Từ vựng trường lớp",
    participants: 110,
    vocabList: [
      Vocabulary(word: "学校", romaji: "gakkou", meaning: "trường học"),
      Vocabulary(word: "先生", romaji: "sensei", meaning: "giáo viên"),
      Vocabulary(word: "本", romaji: "hon", meaning: "sách"),
      Vocabulary(word: "学生", romaji: "gakusei", meaning: "học sinh"),
      Vocabulary(word: "教室", romaji: "kyoushitsu", meaning: "phòng học"),
      Vocabulary(word: "黒板", romaji: "kokuban", meaning: "bảng đen"),
      Vocabulary(word: "机", romaji: "tsukue", meaning: "bàn học"),
      Vocabulary(word: "椅子", romaji: "isu", meaning: "ghế"),
      Vocabulary(word: "図書館", romaji: "toshokan", meaning: "thư viện"),
      Vocabulary(word: "試験", romaji: "shiken", meaning: "kỳ thi"),
    ],
  ),
];

// Bộ flashcard cá nhân (có thể trống ban đầu)
List<FlashcardSet> personalFlashcardSets = [];
