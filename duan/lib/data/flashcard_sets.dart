import '../models/flashcard_set.dart';
import '../models/vocabulary.dart';

final List<FlashcardSet> flashcardSets = [
  FlashcardSet(
    title: "🐶 Động vật",
    description: "Các loài vật cơ bản",
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

  FlashcardSet(
    title: "🍎 Thực phẩm",
    description: "Các loại thực phẩm phổ biến",
    vocabList: [
      Vocabulary(word: "りんご", romaji: "ringo", meaning: "quả táo"),
      Vocabulary(word: "ご飯", romaji: "gohan", meaning: "cơm"),
      Vocabulary(word: "魚", romaji: "sakana", meaning: "cá"),
      Vocabulary(word: "肉", romaji: "niku", meaning: "thịt"),
      Vocabulary(word: "卵", romaji: "tamago", meaning: "trứng"),
      Vocabulary(word: "牛乳", romaji: "gyuunyuu", meaning: "sữa"),
      Vocabulary(word: "パン", romaji: "pan", meaning: "bánh mì"),
      Vocabulary(word: "野菜", romaji: "yasai", meaning: "rau"),
      Vocabulary(word: "果物", romaji: "kudamono", meaning: "trái cây"),
      Vocabulary(word: "味噌汁", romaji: "misoshiru", meaning: "súp miso"),
    ],
  ),

  FlashcardSet(
    title: "🚗 Giao thông",
    description: "Phương tiện giao thông",
    vocabList: [
      Vocabulary(word: "車", romaji: "kuruma", meaning: "xe hơi"),
      Vocabulary(word: "電車", romaji: "densha", meaning: "tàu điện"),
      Vocabulary(word: "自転車", romaji: "jitensha", meaning: "xe đạp"),
      Vocabulary(word: "バス", romaji: "basu", meaning: "xe buýt"),
      Vocabulary(word: "飛行機", romaji: "hikouki", meaning: "máy bay"),
      Vocabulary(word: "船", romaji: "fune", meaning: "thuyền"),
      Vocabulary(word: "タクシー", romaji: "takushii", meaning: "taxi"),
      Vocabulary(word: "バイク", romaji: "baiku", meaning: "xe máy"),
      Vocabulary(word: "地下鉄", romaji: "chikatetsu", meaning: "tàu điện ngầm"),
      Vocabulary(word: "信号", romaji: "shingou", meaning: "đèn giao thông"),
    ],
  ),

  FlashcardSet(
    title: "🏠 Gia đình",
    description: "Thành viên trong gia đình",
    vocabList: [
      Vocabulary(word: "母", romaji: "haha", meaning: "mẹ"),
      Vocabulary(word: "父", romaji: "chichi", meaning: "bố"),
      Vocabulary(word: "兄", romaji: "ani", meaning: "anh trai"),
      Vocabulary(word: "姉", romaji: "ane", meaning: "chị gái"),
      Vocabulary(word: "弟", romaji: "otouto", meaning: "em trai"),
      Vocabulary(word: "妹", romaji: "imouto", meaning: "em gái"),
      Vocabulary(word: "家族", romaji: "kazoku", meaning: "gia đình"),
      Vocabulary(word: "祖母", romaji: "sobo", meaning: "bà"),
      Vocabulary(word: "祖父", romaji: "sofu", meaning: "ông"),
      Vocabulary(word: "親戚", romaji: "shinseki", meaning: "họ hàng"),
    ],
  ),

  FlashcardSet(
    title: "🌳 Thiên nhiên",
    description: "Các yếu tố thiên nhiên",
    vocabList: [
      Vocabulary(word: "山", romaji: "yama", meaning: "núi"),
      Vocabulary(word: "川", romaji: "kawa", meaning: "sông"),
      Vocabulary(word: "海", romaji: "umi", meaning: "biển"),
      Vocabulary(word: "空", romaji: "sora", meaning: "bầu trời"),
      Vocabulary(word: "雨", romaji: "ame", meaning: "mưa"),
      Vocabulary(word: "雪", romaji: "yuki", meaning: "tuyết"),
      Vocabulary(word: "風", romaji: "kaze", meaning: "gió"),
      Vocabulary(word: "森", romaji: "mori", meaning: "rừng"),
      Vocabulary(word: "花", romaji: "hana", meaning: "hoa"),
      Vocabulary(word: "太陽", romaji: "taiyou", meaning: "mặt trời"),
    ],
  ),

  FlashcardSet(
    title: "🏢 Nơi chốn",
    description: "Các địa điểm phổ biến",
    vocabList: [
      Vocabulary(word: "店", romaji: "mise", meaning: "cửa hàng"),
      Vocabulary(word: "病院", romaji: "byouin", meaning: "bệnh viện"),
      Vocabulary(word: "駅", romaji: "eki", meaning: "ga tàu"),
      Vocabulary(word: "公園", romaji: "kouen", meaning: "công viên"),
      Vocabulary(word: "銀行", romaji: "ginkou", meaning: "ngân hàng"),
      Vocabulary(word: "郵便局", romaji: "yuubinkyoku", meaning: "bưu điện"),
      Vocabulary(word: "学校", romaji: "gakkou", meaning: "trường học"),
      Vocabulary(word: "図書館", romaji: "toshokan", meaning: "thư viện"),
      Vocabulary(word: "レストラン", romaji: "resutoran", meaning: "nhà hàng"),
      Vocabulary(word: "ホテル", romaji: "hoteru", meaning: "khách sạn"),
    ],
  ),

  FlashcardSet(
    title: "🎉 Lễ hội",
    description: "Từ vựng về lễ hội",
    vocabList: [
      Vocabulary(word: "祭り", romaji: "matsuri", meaning: "lễ hội"),
      Vocabulary(word: "花火", romaji: "hanabi", meaning: "pháo hoa"),
      Vocabulary(word: "浴衣", romaji: "yukata", meaning: "áo yukata"),
      Vocabulary(word: "神社", romaji: "jinja", meaning: "đền thờ"),
      Vocabulary(word: "提灯", romaji: "chouchin", meaning: "đèn lồng"),
      Vocabulary(word: "山車", romaji: "dashi", meaning: "kiệu rước"),
      Vocabulary(word: "太鼓", romaji: "taiko", meaning: "trống taiko"),
      Vocabulary(word: "面", romaji: "men", meaning: "mặt nạ"),
      Vocabulary(word: "出店", romaji: "demise", meaning: "gian hàng lễ hội"),
      Vocabulary(word: "踊り", romaji: "odori", meaning: "điệu múa"),
    ],
  ),

  FlashcardSet(
    title: "💼 Công việc",
    description: "Từ vựng về công việc",
    vocabList: [
      Vocabulary(word: "会社", romaji: "kaisha", meaning: "công ty"),
      Vocabulary(word: "仕事", romaji: "shigoto", meaning: "công việc"),
      Vocabulary(word: "会議", romaji: "kaigi", meaning: "họp"),
      Vocabulary(word: "部長", romaji: "buchou", meaning: "trưởng phòng"),
      Vocabulary(word: "同僚", romaji: "douryou", meaning: "đồng nghiệp"),
      Vocabulary(word: "給料", romaji: "kyuuryou", meaning: "lương"),
      Vocabulary(word: "残業", romaji: "zangyou", meaning: "tăng ca"),
      Vocabulary(word: "休憩", romaji: "kyuukei", meaning: "giải lao"),
      Vocabulary(word: "資料", romaji: "shiryou", meaning: "tài liệu"),
      Vocabulary(word: "電話", romaji: "denwa", meaning: "điện thoại"),
    ],
  ),
];
