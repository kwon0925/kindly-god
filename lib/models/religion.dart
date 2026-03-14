class Religion {
  final String id;
  final String name;
  final String nameEn;
  final int points; // 총 응원 포인트
  final String? iconUrl;

  const Religion({
    required this.id,
    required this.name,
    required this.nameEn,
    this.points = 0,
    this.iconUrl,
  });

  /// 종교별 상징(마크) 문자
  static String symbol(String id) {
    switch (id) {
      case 'christianity': return '✝';   // 십자가
      case 'islam': return '☪';          // 초승달과 별
      case 'hinduism': return 'ॐ';       // 옴
      case 'buddhism': return '☸';       // 법륜
      case 'sikhism': return '☬';         // 칸다
      case 'judaism': return '✡';       // 다윗의 별
      case 'taoism': return '☯';         // 음양
      case 'confucianism': return '文';   // 유교
      case 'shinto': return '⛩';         // 도리이
      case 'other': return '◆';
      default: return '◆';
    }
  }
}

/// 세계 10대 종교 (기본 선택지)
List<Religion> get defaultReligions => [
  const Religion(id: 'christianity', name: '기독교', nameEn: 'Christianity'),
  const Religion(id: 'islam', name: '이슬람', nameEn: 'Islam'),
  const Religion(id: 'hinduism', name: '힌두교', nameEn: 'Hinduism'),
  const Religion(id: 'buddhism', name: '불교', nameEn: 'Buddhism'),
  const Religion(id: 'sikhism', name: '시크교', nameEn: 'Sikhism'),
  const Religion(id: 'judaism', name: '유대교', nameEn: 'Judaism'),
  const Religion(id: 'taoism', name: '도교', nameEn: 'Taoism'),
  const Religion(id: 'confucianism', name: '유교', nameEn: 'Confucianism'),
  const Religion(id: 'shinto', name: '신토', nameEn: 'Shinto'),
  const Religion(id: 'other', name: '기타', nameEn: 'Other'),
];
