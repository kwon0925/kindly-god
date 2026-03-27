import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh')
  ];

  /// 앱 타이틀
  ///
  /// In ko, this message translates to:
  /// **'Kindly-God'**
  String get appTitle;

  /// No description provided for @save.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get save;

  /// No description provided for @saving.
  ///
  /// In ko, this message translates to:
  /// **'저장 중...'**
  String get saving;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get confirm;

  /// No description provided for @select.
  ///
  /// In ko, this message translates to:
  /// **'선택하기'**
  String get select;

  /// No description provided for @retry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In ko, this message translates to:
  /// **'로딩 중...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다.'**
  String get error;

  /// No description provided for @delete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get delete;

  /// No description provided for @loginTitle.
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get loginTitle;

  /// No description provided for @loginWithGoogle.
  ///
  /// In ko, this message translates to:
  /// **'Google로 로그인'**
  String get loginWithGoogle;

  /// No description provided for @loginLoading.
  ///
  /// In ko, this message translates to:
  /// **'로그인 중...'**
  String get loginLoading;

  /// No description provided for @logout.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get logout;

  /// No description provided for @loginRequired.
  ///
  /// In ko, this message translates to:
  /// **'로그인이 필요합니다'**
  String get loginRequired;

  /// No description provided for @loginRequiredMessage.
  ///
  /// In ko, this message translates to:
  /// **'Google 계정으로 로그인해 주세요.'**
  String get loginRequiredMessage;

  /// No description provided for @adminAccess.
  ///
  /// In ko, this message translates to:
  /// **'어드민 접속'**
  String get adminAccess;

  /// No description provided for @adminAccessLoading.
  ///
  /// In ko, this message translates to:
  /// **'어드민 접속 중...'**
  String get adminAccessLoading;

  /// No description provided for @adminAccessSuccess.
  ///
  /// In ko, this message translates to:
  /// **'어드민 계정으로 접속했습니다.'**
  String get adminAccessSuccess;

  /// No description provided for @account.
  ///
  /// In ko, this message translates to:
  /// **'계정'**
  String get account;

  /// No description provided for @myId.
  ///
  /// In ko, this message translates to:
  /// **'아이디 (랭킹에 표시)'**
  String get myId;

  /// No description provided for @myIdHint.
  ///
  /// In ko, this message translates to:
  /// **'원하는 아이디 입력'**
  String get myIdHint;

  /// No description provided for @duplicateCheck.
  ///
  /// In ko, this message translates to:
  /// **'중복 검사'**
  String get duplicateCheck;

  /// No description provided for @idAvailable.
  ///
  /// In ko, this message translates to:
  /// **'사용 가능한 아이디입니다.'**
  String get idAvailable;

  /// No description provided for @idDuplicate.
  ///
  /// In ko, this message translates to:
  /// **'이미 사용 중인 아이디입니다.'**
  String get idDuplicate;

  /// No description provided for @idEmpty.
  ///
  /// In ko, this message translates to:
  /// **'아이디를 입력해 주세요.'**
  String get idEmpty;

  /// No description provided for @myReligion.
  ///
  /// In ko, this message translates to:
  /// **'나의 종교'**
  String get myReligion;

  /// No description provided for @myCountry.
  ///
  /// In ko, this message translates to:
  /// **'나의 국가'**
  String get myCountry;

  /// No description provided for @lockedWarning.
  ///
  /// In ko, this message translates to:
  /// **'한 번 설정된 아이디·종교·국가는 변경할 수 없습니다.'**
  String get lockedWarning;

  /// No description provided for @beforeSaveHint.
  ///
  /// In ko, this message translates to:
  /// **'종교·국가 선택 후 확인하면 이후 변경할 수 없습니다.'**
  String get beforeSaveHint;

  /// No description provided for @saveComplete.
  ///
  /// In ko, this message translates to:
  /// **'설정이 완료되었습니다. 아이디·종교·국가는 변경할 수 없습니다.'**
  String get saveComplete;

  /// No description provided for @confirmDialogTitle.
  ///
  /// In ko, this message translates to:
  /// **'정말 저장하시겠습니까?'**
  String get confirmDialogTitle;

  /// No description provided for @confirmDialogMessage.
  ///
  /// In ko, this message translates to:
  /// **'한 번 저장하면 종교와 국가를 다시 변경할 수 없습니다.'**
  String get confirmDialogMessage;

  /// No description provided for @adWatchCount.
  ///
  /// In ko, this message translates to:
  /// **'광고 시청 {count}회'**
  String adWatchCount(int count);

  /// No description provided for @donationPoints.
  ///
  /// In ko, this message translates to:
  /// **'기부 포인트 {points} P'**
  String donationPoints(int points);

  /// No description provided for @languageSettings.
  ///
  /// In ko, this message translates to:
  /// **'언어 설정'**
  String get languageSettings;

  /// No description provided for @selectLanguage.
  ///
  /// In ko, this message translates to:
  /// **'언어 선택'**
  String get selectLanguage;

  /// No description provided for @languageChanged.
  ///
  /// In ko, this message translates to:
  /// **'언어가 변경되었습니다.'**
  String get languageChanged;

  /// No description provided for @translate.
  ///
  /// In ko, this message translates to:
  /// **'번역'**
  String get translate;

  /// No description provided for @showOriginal.
  ///
  /// In ko, this message translates to:
  /// **'원문'**
  String get showOriginal;

  /// No description provided for @translating.
  ///
  /// In ko, this message translates to:
  /// **'번역 중...'**
  String get translating;

  /// No description provided for @translationUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'번역을 사용하려면 앱을 설치하세요.'**
  String get translationUnavailable;

  /// No description provided for @modelDownloading.
  ///
  /// In ko, this message translates to:
  /// **'언어팩 다운로드 중... (약 30MB)'**
  String get modelDownloading;

  /// No description provided for @writePost.
  ///
  /// In ko, this message translates to:
  /// **'글쓰기'**
  String get writePost;

  /// No description provided for @deletePost.
  ///
  /// In ko, this message translates to:
  /// **'게시글 삭제'**
  String get deletePost;

  /// No description provided for @deleteComment.
  ///
  /// In ko, this message translates to:
  /// **'댓글 삭제'**
  String get deleteComment;

  /// No description provided for @deleteConfirm.
  ///
  /// In ko, this message translates to:
  /// **'삭제하시겠습니까?'**
  String get deleteConfirm;

  /// No description provided for @enterComment.
  ///
  /// In ko, this message translates to:
  /// **'댓글을 입력하세요'**
  String get enterComment;

  /// No description provided for @loginForComment.
  ///
  /// In ko, this message translates to:
  /// **'로그인 후 댓글을 남길 수 있습니다'**
  String get loginForComment;

  /// No description provided for @anonymous.
  ///
  /// In ko, this message translates to:
  /// **'익명'**
  String get anonymous;

  /// No description provided for @noPost.
  ///
  /// In ko, this message translates to:
  /// **'게시글을 찾을 수 없습니다.'**
  String get noPost;

  /// No description provided for @postLabel.
  ///
  /// In ko, this message translates to:
  /// **'게시글'**
  String get postLabel;

  /// No description provided for @commentLabel.
  ///
  /// In ko, this message translates to:
  /// **'댓글'**
  String get commentLabel;

  /// No description provided for @firstComment.
  ///
  /// In ko, this message translates to:
  /// **'첫 번째 댓글을 남겨보세요.'**
  String get firstComment;

  /// No description provided for @today.
  ///
  /// In ko, this message translates to:
  /// **'오늘'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In ko, this message translates to:
  /// **'이번주'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In ko, this message translates to:
  /// **'이번달'**
  String get thisMonth;

  /// No description provided for @allTime.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get allTime;

  /// No description provided for @religionRanking.
  ///
  /// In ko, this message translates to:
  /// **'종교별 순위'**
  String get religionRanking;

  /// No description provided for @countryRanking.
  ///
  /// In ko, this message translates to:
  /// **'국가별 순위'**
  String get countryRanking;

  /// No description provided for @accountRanking.
  ///
  /// In ko, this message translates to:
  /// **'계정별 순위'**
  String get accountRanking;

  /// No description provided for @donation.
  ///
  /// In ko, this message translates to:
  /// **'응원하기'**
  String get donation;

  /// No description provided for @watchAd.
  ///
  /// In ko, this message translates to:
  /// **'광고 시청하고 1P 받기'**
  String get watchAd;

  /// No description provided for @adPointsEarned.
  ///
  /// In ko, this message translates to:
  /// **'1 P 적립됨'**
  String get adPointsEarned;

  /// No description provided for @back.
  ///
  /// In ko, this message translates to:
  /// **'뒤로'**
  String get back;

  /// No description provided for @religionSupportPointsTitle.
  ///
  /// In ko, this message translates to:
  /// **'종교별 응원 포인트'**
  String get religionSupportPointsTitle;

  /// No description provided for @religionType.
  ///
  /// In ko, this message translates to:
  /// **'종교'**
  String get religionType;

  /// No description provided for @accountType.
  ///
  /// In ko, this message translates to:
  /// **'계정'**
  String get accountType;

  /// No description provided for @countryType.
  ///
  /// In ko, this message translates to:
  /// **'국가'**
  String get countryType;

  /// No description provided for @supportPointHint.
  ///
  /// In ko, this message translates to:
  /// **'응원하기에서 포인트를 쌓아 보세요'**
  String get supportPointHint;

  /// No description provided for @seeAllReligions.
  ///
  /// In ko, this message translates to:
  /// **'전체보기 ({count}개 종교)'**
  String seeAllReligions(int count);

  /// No description provided for @totalCountries.
  ///
  /// In ko, this message translates to:
  /// **'총 {count}개 국가'**
  String totalCountries(int count);

  /// No description provided for @heavenCertificateTitle.
  ///
  /// In ko, this message translates to:
  /// **'🌟 천국 영토 소유 증서'**
  String get heavenCertificateTitle;

  /// No description provided for @heavenSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'당신만의 영원한 안식처를 소유하세요'**
  String get heavenSubtitle;

  /// No description provided for @buyLand.
  ///
  /// In ko, this message translates to:
  /// **'토지 구매'**
  String get buyLand;

  /// No description provided for @translateGuideTooltip.
  ///
  /// In ko, this message translates to:
  /// **'페이지 번역 안내'**
  String get translateGuideTooltip;

  /// No description provided for @pageTranslateTitle.
  ///
  /// In ko, this message translates to:
  /// **'페이지 번역'**
  String get pageTranslateTitle;

  /// No description provided for @pageTranslateBody.
  ///
  /// In ko, this message translates to:
  /// **'이 페이지는 한국어로 되어 있습니다.\n\n번역하려면:\n• Chrome/Edge: 주소창 오른쪽의 번역 아이콘을 누르거나,\n• 페이지에서 우클릭 후 \"Translate to...\" 를 선택하세요.\n\nThis page is in Korean. To translate: use the translate icon in the address bar, or right-click → Translate to your language.'**
  String get pageTranslateBody;

  /// No description provided for @homeTab.
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get homeTab;

  /// No description provided for @supportTab.
  ///
  /// In ko, this message translates to:
  /// **'응원하기'**
  String get supportTab;

  /// No description provided for @activityNewsTab.
  ///
  /// In ko, this message translates to:
  /// **'활동 소식'**
  String get activityNewsTab;

  /// No description provided for @rankLabel.
  ///
  /// In ko, this message translates to:
  /// **'{rank}위'**
  String rankLabel(int rank);

  /// No description provided for @activityNewsTitle.
  ///
  /// In ko, this message translates to:
  /// **'활동 소식'**
  String get activityNewsTitle;

  /// No description provided for @seeAll.
  ///
  /// In ko, this message translates to:
  /// **'전체보기'**
  String get seeAll;

  /// No description provided for @noActivityYet.
  ///
  /// In ko, this message translates to:
  /// **'아직 활동 소식이 없습니다.'**
  String get noActivityYet;

  /// No description provided for @boardTitle.
  ///
  /// In ko, this message translates to:
  /// **'게시판'**
  String get boardTitle;

  /// No description provided for @noPostsYet.
  ///
  /// In ko, this message translates to:
  /// **'아직 게시글이 없습니다.'**
  String get noPostsYet;

  /// No description provided for @noPostsWriteFirst.
  ///
  /// In ko, this message translates to:
  /// **'아직 게시글이 없습니다.\n첫 번째 글을 작성해 보세요!'**
  String get noPostsWriteFirst;

  /// No description provided for @supportThisReligion.
  ///
  /// In ko, this message translates to:
  /// **'이 종교 응원하기'**
  String get supportThisReligion;

  /// No description provided for @noReligionActivity.
  ///
  /// In ko, this message translates to:
  /// **'이 종교의 활동 소식이 없습니다.'**
  String get noReligionActivity;

  /// No description provided for @noReligionBoardPosts.
  ///
  /// In ko, this message translates to:
  /// **'이 종교 게시판에 글이 없습니다.'**
  String get noReligionBoardPosts;

  /// No description provided for @cannotLoadList.
  ///
  /// In ko, this message translates to:
  /// **'목록을 불러올 수 없습니다.'**
  String get cannotLoadList;

  /// No description provided for @commentCount.
  ///
  /// In ko, this message translates to:
  /// **'댓글 {count}'**
  String commentCount(int count);

  /// No description provided for @heavenPurchaseTitle.
  ///
  /// In ko, this message translates to:
  /// **'천국 영토 구매'**
  String get heavenPurchaseTitle;

  /// No description provided for @basicInfo.
  ///
  /// In ko, this message translates to:
  /// **'기본 정보'**
  String get basicInfo;

  /// No description provided for @nameLabel.
  ///
  /// In ko, this message translates to:
  /// **'이름'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In ko, this message translates to:
  /// **'소유자 이름을 입력하세요'**
  String get nameHint;

  /// No description provided for @enterName.
  ///
  /// In ko, this message translates to:
  /// **'이름을 입력해 주세요.'**
  String get enterName;

  /// No description provided for @selectReligion.
  ///
  /// In ko, this message translates to:
  /// **'종교 선택'**
  String get selectReligion;

  /// No description provided for @styleSettings.
  ///
  /// In ko, this message translates to:
  /// **'스타일 설정'**
  String get styleSettings;

  /// No description provided for @baseWorld.
  ///
  /// In ko, this message translates to:
  /// **'세계관 및 종교 (Base World)'**
  String get baseWorld;

  /// No description provided for @locationLabel.
  ///
  /// In ko, this message translates to:
  /// **'입지 및 지형 (Location)'**
  String get locationLabel;

  /// No description provided for @vibeLabel.
  ///
  /// In ko, this message translates to:
  /// **'분위기 및 구성 요소 (Vibe)'**
  String get vibeLabel;

  /// No description provided for @visualLabel.
  ///
  /// In ko, this message translates to:
  /// **'시각적/감각적 효과 (Visual)'**
  String get visualLabel;

  /// No description provided for @specialPerksLabel.
  ///
  /// In ko, this message translates to:
  /// **'특별 서비스 (Special Perks)'**
  String get specialPerksLabel;

  /// No description provided for @shippingInfo.
  ///
  /// In ko, this message translates to:
  /// **'발송 정보'**
  String get shippingInfo;

  /// No description provided for @countryHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 대한민국'**
  String get countryHint;

  /// No description provided for @enterCountry.
  ///
  /// In ko, this message translates to:
  /// **'국가를 입력해 주세요.'**
  String get enterCountry;

  /// No description provided for @addressLabel.
  ///
  /// In ko, this message translates to:
  /// **'주소'**
  String get addressLabel;

  /// No description provided for @addressHint.
  ///
  /// In ko, this message translates to:
  /// **'증명서를 받을 상세 주소'**
  String get addressHint;

  /// No description provided for @enterAddress.
  ///
  /// In ko, this message translates to:
  /// **'주소를 입력해 주세요.'**
  String get enterAddress;

  /// No description provided for @contactLabel.
  ///
  /// In ko, this message translates to:
  /// **'연락처'**
  String get contactLabel;

  /// No description provided for @contactHint.
  ///
  /// In ko, this message translates to:
  /// **'전화번호 또는 이메일'**
  String get contactHint;

  /// No description provided for @enterContact.
  ///
  /// In ko, this message translates to:
  /// **'연락처를 입력해 주세요.'**
  String get enterContact;

  /// No description provided for @selectAllRequired.
  ///
  /// In ko, this message translates to:
  /// **'모든 항목을 선택해 주세요.'**
  String get selectAllRequired;

  /// No description provided for @registerFailed.
  ///
  /// In ko, this message translates to:
  /// **'등록 실패'**
  String get registerFailed;

  /// No description provided for @heavenDonationNoticeShort.
  ///
  /// In ko, this message translates to:
  /// **'이생에서 구매하신 토지 이용료는\n불우한 이웃을 위해 사용됩니다.'**
  String get heavenDonationNoticeShort;

  /// No description provided for @processing.
  ///
  /// In ko, this message translates to:
  /// **'처리 중...'**
  String get processing;

  /// No description provided for @buyHeavenLand.
  ///
  /// In ko, this message translates to:
  /// **'천국 영토 구매하기'**
  String get buyHeavenLand;

  /// No description provided for @pleaseSelect.
  ///
  /// In ko, this message translates to:
  /// **'선택해 주세요.'**
  String get pleaseSelect;

  /// No description provided for @congratsOwner.
  ///
  /// In ko, this message translates to:
  /// **'{name}님의\n토지가 구매되었습니다!'**
  String congratsOwner(String name);

  /// No description provided for @heavenCertificateArrival.
  ///
  /// In ko, this message translates to:
  /// **'약 3~4주 뒤 해당 주소로\n{afterlife} 토지증명서가 도착할 것입니다.'**
  String heavenCertificateArrival(String afterlife);

  /// No description provided for @purchaseDetails.
  ///
  /// In ko, this message translates to:
  /// **'구매 내역'**
  String get purchaseDetails;

  /// No description provided for @ownerLabel.
  ///
  /// In ko, this message translates to:
  /// **'소유자'**
  String get ownerLabel;

  /// No description provided for @shippingCountry.
  ///
  /// In ko, this message translates to:
  /// **'발송 국가'**
  String get shippingCountry;

  /// No description provided for @heavenDonationNoticeLong.
  ///
  /// In ko, this message translates to:
  /// **'이생에서 구매하신 토지 이용료는\n불우한 이웃을 위해 사용됩니다.\n당신의 선행은 천상에 영원히 기록될 것입니다.'**
  String get heavenDonationNoticeLong;

  /// No description provided for @goHome.
  ///
  /// In ko, this message translates to:
  /// **'홈으로'**
  String get goHome;

  /// No description provided for @notificationSectionTitle.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get notificationSectionTitle;

  /// No description provided for @pushNotificationsTitle.
  ///
  /// In ko, this message translates to:
  /// **'푸시 알림'**
  String get pushNotificationsTitle;

  /// No description provided for @notificationStatusWithValue.
  ///
  /// In ko, this message translates to:
  /// **'상태: {value}'**
  String notificationStatusWithValue(String value);

  /// No description provided for @notificationPermissionGranted.
  ///
  /// In ko, this message translates to:
  /// **'허용됨'**
  String get notificationPermissionGranted;

  /// No description provided for @notificationPermissionDenied.
  ///
  /// In ko, this message translates to:
  /// **'거부됨'**
  String get notificationPermissionDenied;

  /// No description provided for @notificationPermissionUnknown.
  ///
  /// In ko, this message translates to:
  /// **'확인 필요'**
  String get notificationPermissionUnknown;

  /// No description provided for @notificationPermissionRequest.
  ///
  /// In ko, this message translates to:
  /// **'알림 허용'**
  String get notificationPermissionRequest;

  /// No description provided for @notificationPermissionGrantedMessage.
  ///
  /// In ko, this message translates to:
  /// **'알림 권한이 허용되었습니다.'**
  String get notificationPermissionGrantedMessage;

  /// No description provided for @notificationPermissionDeniedMessage.
  ///
  /// In ko, this message translates to:
  /// **'알림이 거부되었거나 브라우저에서 차단되었습니다.'**
  String get notificationPermissionDeniedMessage;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'de', 'en', 'es', 'fr', 'ja', 'ko', 'pt', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'ja': return AppLocalizationsJa();
    case 'ko': return AppLocalizationsKo();
    case 'pt': return AppLocalizationsPt();
    case 'ru': return AppLocalizationsRu();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
