class Country {
  final String id;
  final String name;
  final String nameEn;
  final int points;

  const Country({
    required this.id,
    required this.name,
    required this.nameEn,
    this.points = 0,
  });

  String displayName(String languageCode) {
    final code = languageCode.toLowerCase();
    const names = <String, Map<String, String>>{
      'KR': {
        'ko': '대한민국', 'en': 'South Korea', 'zh': '韩国', 'ja': '韓国', 'es': 'Corea del Sur',
        'fr': 'Corée du Sud', 'de': 'Südkorea', 'ru': 'Южная Корея', 'pt': 'Coreia do Sul', 'ar': 'كوريا الجنوبية',
      },
      'US': {
        'ko': '미국', 'en': 'United States', 'zh': '美国', 'ja': 'アメリカ', 'es': 'Estados Unidos',
        'fr': 'États-Unis', 'de': 'Vereinigte Staaten', 'ru': 'США', 'pt': 'Estados Unidos', 'ar': 'الولايات المتحدة',
      },
      'JP': {
        'ko': '일본', 'en': 'Japan', 'zh': '日本', 'ja': '日本', 'es': 'Japón',
        'fr': 'Japon', 'de': 'Japan', 'ru': 'Япония', 'pt': 'Japão', 'ar': 'اليابان',
      },
      'CN': {
        'ko': '중국', 'en': 'China', 'zh': '中国', 'ja': '中国', 'es': 'China',
        'fr': 'Chine', 'de': 'China', 'ru': 'Китай', 'pt': 'China', 'ar': 'الصين',
      },
      'IN': {
        'ko': '인도', 'en': 'India', 'zh': '印度', 'ja': 'インド', 'es': 'India',
        'fr': 'Inde', 'de': 'Indien', 'ru': 'Индия', 'pt': 'Índia', 'ar': 'الهند',
      },
      'GB': {
        'ko': '영국', 'en': 'United Kingdom', 'zh': '英国', 'ja': 'イギリス', 'es': 'Reino Unido',
        'fr': 'Royaume-Uni', 'de': 'Vereinigtes Königreich', 'ru': 'Великобритания', 'pt': 'Reino Unido', 'ar': 'المملكة المتحدة',
      },
      'DE': {
        'ko': '독일', 'en': 'Germany', 'zh': '德国', 'ja': 'ドイツ', 'es': 'Alemania',
        'fr': 'Allemagne', 'de': 'Deutschland', 'ru': 'Германия', 'pt': 'Alemanha', 'ar': 'ألمانيا',
      },
      'FR': {
        'ko': '프랑스', 'en': 'France', 'zh': '法国', 'ja': 'フランス', 'es': 'Francia',
        'fr': 'France', 'de': 'Frankreich', 'ru': 'Франция', 'pt': 'França', 'ar': 'فرنسا',
      },
      'BR': {
        'ko': '브라질', 'en': 'Brazil', 'zh': '巴西', 'ja': 'ブラジル', 'es': 'Brasil',
        'fr': 'Brésil', 'de': 'Brasilien', 'ru': 'Бразилия', 'pt': 'Brasil', 'ar': 'البرازيل',
      },
      'ID': {
        'ko': '인도네시아', 'en': 'Indonesia', 'zh': '印度尼西亚', 'ja': 'インドネシア', 'es': 'Indonesia',
        'fr': 'Indonésie', 'de': 'Indonesien', 'ru': 'Индонезия', 'pt': 'Indonésia', 'ar': 'إندونيسيا',
      },
      'ETC': {
        'ko': '기타', 'en': 'Other', 'zh': '其他', 'ja': 'その他', 'es': 'Otros',
        'fr': 'Autre', 'de': 'Sonstige', 'ru': 'Другое', 'pt': 'Outros', 'ar': 'أخرى',
      },
    };
    final byLang = names[id.toUpperCase()];
    if (byLang == null) return code == 'ko' ? name : nameEn;
    return byLang[code] ?? byLang['en'] ?? nameEn;
  }

  /// 국가 코드(id)에 해당하는 국기 asset 경로.
  /// assets/images/flags/ 아래 파일명은 `..._<code>.webp` 형태이며, 여기서는 앱에서 쓰는 국가 코드만 매핑한다.
  static String? flagAssetPath(String countryId) {
    switch (countryId.toUpperCase()) {
      case 'KR': return 'assets/images/flags/imgi_120_kr.webp';
      case 'JP': return 'assets/images/flags/imgi_113_jp.webp';
      case 'US': return 'assets/images/flags/imgi_239_us.webp';
      case 'CN': return 'assets/images/flags/imgi_302_cn.webp';
      case 'IN': return 'assets/images/flags/imgi_104_in.webp';
      case 'GB': return 'assets/images/flags/imgi_238_gb.webp';
      case 'DE': return 'assets/images/flags/imgi_341_de.webp';
      case 'FR': return 'assets/images/flags/imgi_334_fr.webp';
      case 'BR': return 'assets/images/flags/imgi_287_br.webp';
      case 'ID': return 'assets/images/flags/imgi_105_id.webp';
      default: return null;
    }
  }
}

List<Country> get defaultCountries => [
  const Country(id: 'KR', name: '대한민국', nameEn: 'South Korea'),
  const Country(id: 'US', name: '미국', nameEn: 'United States'),
  const Country(id: 'JP', name: '일본', nameEn: 'Japan'),
  const Country(id: 'CN', name: '중국', nameEn: 'China'),
  const Country(id: 'IN', name: '인도', nameEn: 'India'),
  const Country(id: 'GB', name: '영국', nameEn: 'United Kingdom'),
  const Country(id: 'DE', name: '독일', nameEn: 'Germany'),
  const Country(id: 'FR', name: '프랑스', nameEn: 'France'),
  const Country(id: 'BR', name: '브라질', nameEn: 'Brazil'),
  const Country(id: 'ID', name: '인도네시아', nameEn: 'Indonesia'),
  const Country(id: 'ETC', name: '기타', nameEn: 'Other'),
];
