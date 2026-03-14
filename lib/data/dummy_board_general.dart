import '../models/board_post.dart';

/// 게시판용 더미 데이터 (10개). 활동 소식과 별도 관리.
List<BoardPost> get dummyBoardGeneralPosts => [
  BoardPost(
    id: 'g1',
    title: '2024년 4분기 응원 현황 공지',
    summary: '전 세계 종교별·국가별 응원 포인트 집계 결과를 공유합니다.',
    body: '2024년 4분기 동안 많은 분의 응원이 있었습니다. 종교별·국가별 랭킹이 업데이트되었으며, 내년에도 다양한 활동이 이어질 예정입니다.',
    imageUrl: '',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  BoardPost(
    id: 'g2',
    title: '서비스 이용 약관 개정 안내',
    summary: '2025년 1월 1일자 약관 개정 사항을 안내드립니다.',
    body: '서비스 이용 약관이 일부 개정됩니다. 변경 내용은 앱 내 약관 화면에서 확인하실 수 있으며, 계속 이용 시 동의로 간주됩니다.',
    imageUrl: '',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  BoardPost(
    id: 'g3',
    title: '종교별 랭킹 집계 기준 안내',
    summary: '오늘/이번주/이번달/1년 랭킹 집계 방식입니다.',
    body: '랭킹은 선택한 기간 동안 적립된 포인트 합산으로 산정됩니다. 오늘은 0시 기준, 주·월·년은 해당 구간 UTC 기준으로 집계됩니다.',
    imageUrl: '',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  BoardPost(
    id: 'g4',
    title: '포인트 적립 및 사용 정책',
    summary: '결제·광고 시청 시 포인트 적립 조건을 안내합니다.',
    body: '결제 1달러당 1포인트가 적립되며, 광고 시청 시 정해진 조건에 따라 포인트가 적립됩니다. 포인트는 현금 환급 및 기부금 영수증 대상이 아닙니다.',
    imageUrl: '',
    createdAt: DateTime.now().subtract(const Duration(days: 4)),
  ),
  BoardPost(
    id: 'g5',
    title: '개인정보 처리방침 업데이트',
    summary: '개인정보 수집·이용 항목이 일부 변경되었습니다.',
    body: '서비스 개선을 위해 개인정보 처리방침이 업데이트되었습니다. 로그인 정보, 선택한 종교·국가 등이 랭킹 집계에만 사용됩니다.',
    imageUrl: '',
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
  BoardPost(
    id: 'g6',
    title: '신규 종교·국가 추가 요청 안내',
    summary: '추가를 원하시는 종교·국가가 있으면 문의해 주세요.',
    body: '기본 10대 종교 외 추가를 원하시는 경우 고객문의를 통해 요청하실 수 있습니다. 검토 후 반영 여부를 안내드립니다.',
    imageUrl: '',
    createdAt: DateTime.now().subtract(const Duration(days: 6)),
  ),
  BoardPost(
    id: 'g7',
    title: '계정별 랭킹 노출 기준',
    summary: '계정 이름 설정 시 랭킹에 반영되는 방식을 안내합니다.',
    body: '계정에서 설정한 이름이 계정별 랭킹에 표시됩니다. 미설정 시 유저 A/B/C 등 기본 표기가 사용됩니다.',
    imageUrl: '',
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
  ),
  BoardPost(
    id: 'g8',
    title: 'PayPal 결제 연동 예정',
    summary: '향후 결제는 PayPal을 통해 진행될 예정입니다.',
    body: '테스트 모드 이후 실제 결제는 PayPal과 연동하여 진행될 예정입니다. 결제 시 선택한 종교·계정·국가에 포인트가 적립됩니다.',
    imageUrl: '',
    createdAt: DateTime.now().subtract(const Duration(days: 8)),
  ),
  BoardPost(
    id: 'g9',
    title: '광고 시청 포인트 정책',
    summary: '전면 광고 시청 시 1P, 10회 시청 시 보너스 10P 안내.',
    body: '전면 광고를 클릭 후 시청하면 계정당 1포인트가 적립됩니다. 10회 시청 시 추가 10포인트가 보너스로 적립됩니다.',
    imageUrl: '',
    createdAt: DateTime.now().subtract(const Duration(days: 9)),
  ),
  BoardPost(
    id: 'g10',
    title: 'Kindly 서비스 오픈 안내',
    summary: '글로벌 종교·국가 응원 랭킹 서비스가 시작되었습니다.',
    body: 'Kindly는 전 세계 종교별·계정별·국가별 응원 포인트를 모아 랭킹으로 보여주는 서비스입니다. 많은 참여 부탁드립니다.',
    imageUrl: '',
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
  ),
];

/// 최근 순 정렬 후 상위 [count]개 반환
List<BoardPost> getLatestBoardGeneralPosts(int count) {
  final list = List<BoardPost>.from(dummyBoardGeneralPosts)
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return list.take(count).toList();
}
