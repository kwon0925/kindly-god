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
