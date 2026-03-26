// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Kindly-God';

  @override
  String get save => '저장';

  @override
  String get saving => '저장 중...';

  @override
  String get cancel => '취소';

  @override
  String get close => '닫기';

  @override
  String get confirm => '확인';

  @override
  String get select => '선택하기';

  @override
  String get retry => '다시 시도';

  @override
  String get loading => '로딩 중...';

  @override
  String get error => '오류가 발생했습니다.';

  @override
  String get delete => '삭제';

  @override
  String get loginTitle => '로그인';

  @override
  String get loginWithGoogle => 'Google로 로그인';

  @override
  String get loginLoading => '로그인 중...';

  @override
  String get logout => '로그아웃';

  @override
  String get loginRequired => '로그인이 필요합니다';

  @override
  String get loginRequiredMessage => 'Google 계정으로 로그인해 주세요.';

  @override
  String get adminAccess => '어드민 접속';

  @override
  String get adminAccessLoading => '어드민 접속 중...';

  @override
  String get adminAccessSuccess => '어드민 계정으로 접속했습니다.';

  @override
  String get account => '계정';

  @override
  String get myId => '아이디 (랭킹에 표시)';

  @override
  String get myIdHint => '원하는 아이디 입력';

  @override
  String get duplicateCheck => '중복 검사';

  @override
  String get idAvailable => '사용 가능한 아이디입니다.';

  @override
  String get idDuplicate => '이미 사용 중인 아이디입니다.';

  @override
  String get idEmpty => '아이디를 입력해 주세요.';

  @override
  String get myReligion => '나의 종교';

  @override
  String get myCountry => '나의 국가';

  @override
  String get lockedWarning => '한 번 설정된 아이디·종교·국가는 변경할 수 없습니다.';

  @override
  String get beforeSaveHint => '종교·국가 선택 후 확인하면 이후 변경할 수 없습니다.';

  @override
  String get saveComplete => '설정이 완료되었습니다. 아이디·종교·국가는 변경할 수 없습니다.';

  @override
  String get confirmDialogTitle => '정말 저장하시겠습니까?';

  @override
  String get confirmDialogMessage => '한 번 저장하면 종교와 국가를 다시 변경할 수 없습니다.';

  @override
  String adWatchCount(int count) {
    return '광고 시청 $count회';
  }

  @override
  String donationPoints(int points) {
    return '기부 포인트 $points P';
  }

  @override
  String get languageSettings => '언어 설정';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get languageChanged => '언어가 변경되었습니다.';

  @override
  String get translate => '번역';

  @override
  String get showOriginal => '원문';

  @override
  String get translating => '번역 중...';

  @override
  String get translationUnavailable => '번역을 사용하려면 앱을 설치하세요.';

  @override
  String get modelDownloading => '언어팩 다운로드 중... (약 30MB)';

  @override
  String get writePost => '글쓰기';

  @override
  String get deletePost => '게시글 삭제';

  @override
  String get deleteComment => '댓글 삭제';

  @override
  String get deleteConfirm => '삭제하시겠습니까?';

  @override
  String get enterComment => '댓글을 입력하세요';

  @override
  String get loginForComment => '로그인 후 댓글을 남길 수 있습니다';

  @override
  String get anonymous => '익명';

  @override
  String get noPost => '게시글을 찾을 수 없습니다.';

  @override
  String get postLabel => '게시글';

  @override
  String get commentLabel => '댓글';

  @override
  String get firstComment => '첫 번째 댓글을 남겨보세요.';

  @override
  String get today => '오늘';

  @override
  String get thisWeek => '이번주';

  @override
  String get thisMonth => '이번달';

  @override
  String get allTime => '전체';

  @override
  String get religionRanking => '종교별 순위';

  @override
  String get countryRanking => '국가별 순위';

  @override
  String get accountRanking => '계정별 순위';

  @override
  String get donation => '응원하기';

  @override
  String get watchAd => '광고 시청하고 1P 받기';

  @override
  String get adPointsEarned => '1 P 적립됨';

  @override
  String get back => '뒤로';

  @override
  String get religionSupportPointsTitle => '종교별 응원 포인트';

  @override
  String get religionType => '종교';

  @override
  String get accountType => '계정';

  @override
  String get countryType => '국가';

  @override
  String get supportPointHint => '응원하기에서 포인트를 쌓아 보세요';

  @override
  String seeAllReligions(int count) {
    return '전체보기 ($count개 종교)';
  }

  @override
  String totalCountries(int count) {
    return '총 $count개 국가';
  }

  @override
  String get heavenCertificateTitle => '🌟 천국 영토 소유 증서';

  @override
  String get heavenSubtitle => '당신만의 영원한 안식처를 소유하세요';

  @override
  String get buyLand => '토지 구매';

  @override
  String get translateGuideTooltip => '페이지 번역 안내';

  @override
  String get pageTranslateTitle => '페이지 번역';

  @override
  String get pageTranslateBody => '이 페이지는 한국어로 되어 있습니다.\n\n번역하려면:\n• Chrome/Edge: 주소창 오른쪽의 번역 아이콘을 누르거나,\n• 페이지에서 우클릭 후 \"Translate to...\" 를 선택하세요.\n\nThis page is in Korean. To translate: use the translate icon in the address bar, or right-click → Translate to your language.';

  @override
  String get homeTab => '홈';

  @override
  String get supportTab => '응원하기';

  @override
  String get activityNewsTab => '활동 소식';

  @override
  String rankLabel(int rank) {
    return '$rank위';
  }

  @override
  String get activityNewsTitle => '활동 소식';

  @override
  String get seeAll => '전체보기';

  @override
  String get noActivityYet => '아직 활동 소식이 없습니다.';

  @override
  String get boardTitle => '게시판';

  @override
  String get noPostsYet => '아직 게시글이 없습니다.';

  @override
  String get noPostsWriteFirst => '아직 게시글이 없습니다.\n첫 번째 글을 작성해 보세요!';

  @override
  String get supportThisReligion => '이 종교 응원하기';

  @override
  String get noReligionActivity => '이 종교의 활동 소식이 없습니다.';

  @override
  String get noReligionBoardPosts => '이 종교 게시판에 글이 없습니다.';

  @override
  String get cannotLoadList => '목록을 불러올 수 없습니다.';

  @override
  String commentCount(int count) {
    return '댓글 $count';
  }

  @override
  String get heavenPurchaseTitle => '천국 영토 구매';

  @override
  String get basicInfo => '기본 정보';

  @override
  String get nameLabel => '이름';

  @override
  String get nameHint => '소유자 이름을 입력하세요';

  @override
  String get enterName => '이름을 입력해 주세요.';

  @override
  String get selectReligion => '종교 선택';

  @override
  String get styleSettings => '스타일 설정';

  @override
  String get baseWorld => '세계관 및 종교 (Base World)';

  @override
  String get locationLabel => '입지 및 지형 (Location)';

  @override
  String get vibeLabel => '분위기 및 구성 요소 (Vibe)';

  @override
  String get visualLabel => '시각적/감각적 효과 (Visual)';

  @override
  String get specialPerksLabel => '특별 서비스 (Special Perks)';

  @override
  String get shippingInfo => '발송 정보';

  @override
  String get countryHint => '예: 대한민국';

  @override
  String get enterCountry => '국가를 입력해 주세요.';

  @override
  String get addressLabel => '주소';

  @override
  String get addressHint => '증명서를 받을 상세 주소';

  @override
  String get enterAddress => '주소를 입력해 주세요.';

  @override
  String get contactLabel => '연락처';

  @override
  String get contactHint => '전화번호 또는 이메일';

  @override
  String get enterContact => '연락처를 입력해 주세요.';

  @override
  String get selectAllRequired => '모든 항목을 선택해 주세요.';

  @override
  String get registerFailed => '등록 실패';

  @override
  String get heavenDonationNoticeShort => '이생에서 구매하신 토지 이용료는\n불우한 이웃을 위해 사용됩니다.';

  @override
  String get processing => '처리 중...';

  @override
  String get buyHeavenLand => '천국 영토 구매하기';

  @override
  String get pleaseSelect => '선택해 주세요.';

  @override
  String congratsOwner(String name) {
    return '$name님의\n토지가 구매되었습니다!';
  }

  @override
  String heavenCertificateArrival(String afterlife) {
    return '약 3~4주 뒤 해당 주소로\n$afterlife 토지증명서가 도착할 것입니다.';
  }

  @override
  String get purchaseDetails => '구매 내역';

  @override
  String get ownerLabel => '소유자';

  @override
  String get shippingCountry => '발송 국가';

  @override
  String get heavenDonationNoticeLong => '이생에서 구매하신 토지 이용료는\n불우한 이웃을 위해 사용됩니다.\n당신의 선행은 천상에 영원히 기록될 것입니다.';

  @override
  String get goHome => '홈으로';
}
