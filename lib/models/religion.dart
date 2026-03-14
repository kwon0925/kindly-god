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
