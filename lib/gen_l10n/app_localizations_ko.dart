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
}
