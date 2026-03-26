class Religion {
  final String id;
  final String name;
  final String nameEn;
  final int points;
  final String? iconUrl;

  const Religion({
    required this.id,
    required this.name,
    required this.nameEn,
    this.points = 0,
    this.iconUrl,
  });

  String displayName(String languageCode) {
    final code = languageCode.toLowerCase();
    const names = <String, Map<String, String>>{
      'christianity': {
        'ko': '기독교', 'en': 'Christianity', 'zh': '基督教', 'ja': 'キリスト教', 'es': 'Cristianismo',
        'fr': 'Christianisme', 'de': 'Christentum', 'ru': 'Христианство', 'pt': 'Cristianismo', 'ar': 'المسيحية',
      },
      'catholicism': {
        'ko': '천주교', 'en': 'Catholicism', 'zh': '天主教', 'ja': 'カトリック', 'es': 'Catolicismo',
        'fr': 'Catholicisme', 'de': 'Katholizismus', 'ru': 'Католицизм', 'pt': 'Catolicismo', 'ar': 'الكاثوليكية',
      },
      'islam': {
        'ko': '이슬람', 'en': 'Islam', 'zh': '伊斯兰教', 'ja': 'イスラム教', 'es': 'Islam',
        'fr': 'Islam', 'de': 'Islam', 'ru': 'Ислам', 'pt': 'Islamismo', 'ar': 'الإسلام',
      },
      'hinduism': {
        'ko': '힌두교', 'en': 'Hinduism', 'zh': '印度教', 'ja': 'ヒンドゥー教', 'es': 'Hinduismo',
        'fr': 'Hindouisme', 'de': 'Hinduismus', 'ru': 'Индуизм', 'pt': 'Hinduísmo', 'ar': 'الهندوسية',
      },
      'buddhism': {
        'ko': '불교', 'en': 'Buddhism', 'zh': '佛教', 'ja': '仏教', 'es': 'Budismo',
        'fr': 'Bouddhisme', 'de': 'Buddhismus', 'ru': 'Буддизм', 'pt': 'Budismo', 'ar': 'البوذية',
      },
      'sikhism': {
        'ko': '시크교', 'en': 'Sikhism', 'zh': '锡克教', 'ja': 'シク教', 'es': 'Sijismo',
        'fr': 'Sikhisme', 'de': 'Sikhismus', 'ru': 'Сикхизм', 'pt': 'Siquismo', 'ar': 'السيخية',
      },
      'judaism': {
        'ko': '유대교', 'en': 'Judaism', 'zh': '犹太教', 'ja': 'ユダヤ教', 'es': 'Judaísmo',
        'fr': 'Judaïsme', 'de': 'Judentum', 'ru': 'Иудаизм', 'pt': 'Judaísmo', 'ar': 'اليهودية',
      },
      'taoism': {
        'ko': '도교', 'en': 'Taoism', 'zh': '道教', 'ja': '道教', 'es': 'Taoísmo',
        'fr': 'Taoïsme', 'de': 'Daoismus', 'ru': 'Даосизм', 'pt': 'Taoismo', 'ar': 'الطاوية',
      },
      'confucianism': {
        'ko': '유교', 'en': 'Confucianism', 'zh': '儒教', 'ja': '儒教', 'es': 'Confucianismo',
        'fr': 'Confucianisme', 'de': 'Konfuzianismus', 'ru': 'Конфуцианство', 'pt': 'Confucionismo', 'ar': 'الكونفوشيوسية',
      },
      'shinto': {
        'ko': '신토', 'en': 'Shinto', 'zh': '神道', 'ja': '神道', 'es': 'Sintoísmo',
        'fr': 'Shintoïsme', 'de': 'Shinto', 'ru': 'Синтоизм', 'pt': 'Xintoísmo', 'ar': 'الشنتوية',
      },
      'other': {
        'ko': '기타', 'en': 'Other', 'zh': '其他', 'ja': 'その他', 'es': 'Otros',
        'fr': 'Autre', 'de': 'Sonstige', 'ru': 'Другое', 'pt': 'Outros', 'ar': 'أخرى',
      },
    };
    final byLang = names[id];
    if (byLang == null) return code == 'ko' ? name : nameEn;
    return byLang[code] ?? byLang['en'] ?? nameEn;
  }

  /// 종교별 상징(마크) 문자
  static String symbol(String id) {
    switch (id) {
      case 'christianity': return '✝';
      case 'catholicism':  return '✝';
      case 'islam':        return '☪';
      case 'hinduism':     return 'ॐ';
      case 'buddhism':     return '☸';
      case 'sikhism':      return '☬';
      case 'judaism':      return '✡';
      case 'taoism':       return '☯';
      case 'confucianism': return '文';
      case 'shinto':       return '⛩';
      case 'other':        return '◆';
      default:             return '◆';
    }
  }

  /// 종교별 배경 이미지 asset 경로
  static String? imagePath(String id) {
    switch (id) {
      case 'christianity': return 'assets/images/religion_christianity.png';
      case 'catholicism':  return 'assets/images/religion_catholicism.png';
      case 'islam':        return 'assets/images/religion_islam.png';
      case 'hinduism':     return 'assets/images/religion_hinduism.png';
      case 'buddhism':     return 'assets/images/religion_buddhism.png';
      case 'sikhism':      return 'assets/images/religion_sikhism.png';
      case 'judaism':      return 'assets/images/religion_judaism.png';
      case 'taoism':       return 'assets/images/religion_taoism.png';
      case 'confucianism': return 'assets/images/religion_confucianism.png';
      case 'shinto':       return 'assets/images/religion_shinto.png';
      case 'other':        return 'assets/images/religion_other.png';
      default:             return null;
    }
  }

  /// 기부 완료 시 노출할 종교별 이미지 asset 경로
  static String? donationImagePath(String id) {
    switch (id) {
      case 'christianity': return 'assets/images/donation_blessings/religion_christianity.png';
      case 'catholicism':  return 'assets/images/donation_blessings/religion_catholicism.png';
      case 'islam':        return 'assets/images/donation_blessings/religion_islam.png';
      case 'hinduism':     return 'assets/images/donation_blessings/religion_hinduism.png';
      case 'buddhism':     return 'assets/images/donation_blessings/religion_buddhism.png';
      case 'sikhism':      return 'assets/images/donation_blessings/religion_sikhism.png';
      case 'judaism':      return 'assets/images/donation_blessings/religion_judaism.png';
      case 'taoism':       return 'assets/images/donation_blessings/religion_taoism.png';
      case 'confucianism': return 'assets/images/donation_blessings/religion_confucianism.png';
      case 'shinto':       return 'assets/images/donation_blessings/religion_shinto.png';
      case 'other':        return 'assets/images/donation_blessings/religion_other.png';
      default:             return null;
    }
  }
}

/// 세계 종교 목록 (천주교 포함)
List<Religion> get defaultReligions => [
  const Religion(id: 'christianity', name: '기독교',  nameEn: 'Christianity'),
  const Religion(id: 'catholicism',  name: '천주교',  nameEn: 'Catholicism'),
  const Religion(id: 'islam',        name: '이슬람',  nameEn: 'Islam'),
  const Religion(id: 'hinduism',     name: '힌두교',  nameEn: 'Hinduism'),
  const Religion(id: 'buddhism',     name: '불교',    nameEn: 'Buddhism'),
  const Religion(id: 'sikhism',      name: '시크교',  nameEn: 'Sikhism'),
  const Religion(id: 'judaism',      name: '유대교',  nameEn: 'Judaism'),
  const Religion(id: 'taoism',       name: '도교',    nameEn: 'Taoism'),
  const Religion(id: 'confucianism', name: '유교',    nameEn: 'Confucianism'),
  const Religion(id: 'shinto',       name: '신토',    nameEn: 'Shinto'),
  const Religion(id: 'other',        name: '기타',    nameEn: 'Other'),
];
