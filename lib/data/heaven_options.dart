/// 천국 영토 구매 드롭다운 옵션 데이터
/// 각 카테고리별 선택지 리스트 - 수정이 필요하면 여기서만 수정하면 됨

class HeavenOptions {
  // ── 종교별 내세 명칭 매핑 ─────────────────────────────────
  static const Map<String, String> religionAfterlifeNames = {
    'christianity': '천국 (Heaven)',
    'catholicism':  '천국 (Heaven)',
    'buddhism':     '극락 (Pure Land)',
    'islam':        '잔나 (Jannah)',
    'hinduism':     '스와르가 (Svarga)',
    'judaism':      '간 에덴 (Gan Eden)',
    'sikhism':      '삭칸드 (Sachkhand)',
    'taoism':       '선경 (仙境)',
    'confucianism': '천상 (天上)',
    'shinto':       '타카마가하라 (高天原)',
    'other':        '낙원 (Paradise)',
  };

  static String afterlifeName(String religionId, String languageCode) {
    const localized = <String, Map<String, String>>{
      'christianity': {'ko': '천국', 'en': 'Heaven', 'zh': '天堂', 'ja': '天国', 'es': 'Cielo', 'fr': 'Paradis', 'de': 'Himmel', 'ru': 'Небеса', 'pt': 'Céu', 'ar': 'الجنة'},
      'catholicism': {'ko': '천국', 'en': 'Heaven', 'zh': '天堂', 'ja': '天国', 'es': 'Cielo', 'fr': 'Paradis', 'de': 'Himmel', 'ru': 'Небеса', 'pt': 'Céu', 'ar': 'الجنة'},
      'buddhism': {'ko': '극락', 'en': 'Pure Land', 'zh': '极乐净土', 'ja': '極楽浄土', 'es': 'Tierra Pura', 'fr': 'Terre Pure', 'de': 'Reines Land', 'ru': 'Чистая Земля', 'pt': 'Terra Pura', 'ar': 'الأرض الطاهرة'},
      'islam': {'ko': '잔나', 'en': 'Jannah', 'zh': '乐园', 'ja': 'ジャンナ', 'es': 'Yannah', 'fr': 'Jannah', 'de': 'Dschanna', 'ru': 'Джанна', 'pt': 'Jannah', 'ar': 'جنة'},
      'hinduism': {'ko': '스와르가', 'en': 'Svarga', 'zh': '天界', 'ja': 'スヴァルガ', 'es': 'Svarga', 'fr': 'Svarga', 'de': 'Svarga', 'ru': 'Сварга', 'pt': 'Svarga', 'ar': 'سفارغا'},
      'judaism': {'ko': '간 에덴', 'en': 'Gan Eden', 'zh': '伊甸园', 'ja': 'ガン・エデン', 'es': 'Gan Eden', 'fr': 'Gan Eden', 'de': 'Gan Eden', 'ru': 'Ган Эден', 'pt': 'Gan Eden', 'ar': 'جن عدن'},
      'sikhism': {'ko': '삭칸드', 'en': 'Sachkhand', 'zh': '真境', 'ja': 'サッチカンド', 'es': 'Sachkhand', 'fr': 'Sachkhand', 'de': 'Sachkhand', 'ru': 'Сачкханд', 'pt': 'Sachkhand', 'ar': 'ساتشخاند'},
      'taoism': {'ko': '선경', 'en': 'Immortal Realm', 'zh': '仙境', 'ja': '仙境', 'es': 'Reino inmortal', 'fr': 'Royaume immortel', 'de': 'Reich der Unsterblichen', 'ru': 'Мир бессмертных', 'pt': 'Reino imortal', 'ar': 'عالم الخالدين'},
      'confucianism': {'ko': '천상', 'en': 'Heavenly Realm', 'zh': '天上', 'ja': '天上界', 'es': 'Reino celestial', 'fr': 'Royaume céleste', 'de': 'Himmlisches Reich', 'ru': 'Небесный мир', 'pt': 'Reino celestial', 'ar': 'العالم السماوي'},
      'shinto': {'ko': '타카마가하라', 'en': 'Takamagahara', 'zh': '高天原', 'ja': '高天原', 'es': 'Takamagahara', 'fr': 'Takamagahara', 'de': 'Takamagahara', 'ru': 'Такамагахара', 'pt': 'Takamagahara', 'ar': 'تاكاماغاهارا'},
      'other': {'ko': '낙원', 'en': 'Paradise', 'zh': '乐园', 'ja': '楽園', 'es': 'Paraíso', 'fr': 'Paradis', 'de': 'Paradies', 'ru': 'Рай', 'pt': 'Paraíso', 'ar': 'الفردوس'},
    };
    final code = languageCode.toLowerCase();
    final names = localized[religionId];
    if (names == null) return code == 'ko' ? '낙원' : 'Paradise';
    return names[code] ?? names['en'] ?? 'Paradise';
  }

  // ── 선택 종교 목록 (id, 한국어 이름) ─────────────────────
  static const List<Map<String, String>> religions = [
    {'id': 'christianity', 'label': '기독교'},
    {'id': 'catholicism',  'label': '천주교'},
    {'id': 'buddhism',     'label': '불교'},
    {'id': 'islam',        'label': '이슬람'},
    {'id': 'hinduism',     'label': '힌두교'},
    {'id': 'judaism',      'label': '유대교'},
    {'id': 'sikhism',      'label': '시크교'},
    {'id': 'taoism',       'label': '도교'},
    {'id': 'confucianism', 'label': '유교'},
    {'id': 'shinto',       'label': '신토'},
    {'id': 'other',        'label': '기타/무교'},
  ];

  // ── 1. 세계관 및 종교 (Base World) ────────────────────────
  static const List<String> baseWorlds = [
    '기독교 테마 (빛나는 성곽과 천사)',
    '불교 테마 (고요한 연꽃과 정토)',
    '이슬람 테마 (시원한 오아시스와 정원)',
    '힌두교 테마 (화려한 신전과 황금빛 천상)',
    '북유럽/그리스 테마 (신화 속 영웅의 전당)',
    '자연주의/무교 (신비로운 태고의 지구)',
  ];

  // ── 2. 입지 및 지형 (Location) ─────────────────────────────
  static const List<String> locations = [
    '구름 위의 땅 (하늘에 떠 있는 섬)',
    '신비로운 바다 위 (물 위를 걷는 해변)',
    '끝없이 펼쳐진 초원 (평화로운 들판)',
    '웅장한 산맥과 폭포 (신선이 노니는 절경)',
    '우주와 은하수 사이 (별빛이 흐르는 공간)',
  ];

  // ── 3. 분위기 및 구성 요소 (Vibe & Elements) ──────────────
  static const List<String> vibes = [
    '사람이 북적이는 활기찬 곳',
    '나 혼자만의 고요한 안식처',
    '아름다운 여성/남성들이 가득한 곳',
    '죽은 반려견/반려동물과 함께하는 곳',
    '화려하고 웅장한 대저택/집이 있는 곳',
    '전통적이고 고전적인 궁궐 스타일',
  ];

  // ── 4. 시각적/감각적 효과 (Visual Effects) ────────────────
  static const List<String> visualEffects = [
    '황금과 보석으로 빛나는 효과',
    '따스한 햇살이 내리쬐는 오후',
    '몽환적인 보랏빛 노을과 오로라',
    '끊임없이 솟아나는 생명수의 강',
    '꽃비가 흩날리는 낭만적인 풍경',
  ];

  // ── 5. 특별 서비스 (Special Perks) ─────────────────────────
  static const List<String> specialPerks = [
    '산해진미 음식이 풍족하게 차려진 곳',
    '은은한 찬양/음악이 흐르는 분위기',
    '영원히 늙지 않는 젊음의 샘물',
  ];
}
