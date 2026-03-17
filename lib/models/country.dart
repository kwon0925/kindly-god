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
