// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Kindly-God';

  @override
  String get save => 'Save';

  @override
  String get saving => 'Saving...';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get select => 'Select';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'An error occurred.';

  @override
  String get delete => 'Delete';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginWithGoogle => 'Login with Google';

  @override
  String get loginLoading => 'Logging in...';

  @override
  String get logout => 'Logout';

  @override
  String get loginRequired => 'Login Required';

  @override
  String get loginRequiredMessage => 'Please log in with your Google account.';

  @override
  String get adminAccess => 'Admin Access';

  @override
  String get adminAccessLoading => 'Accessing as admin...';

  @override
  String get adminAccessSuccess => 'Logged in as admin.';

  @override
  String get account => 'Account';

  @override
  String get myId => 'ID (shown in rankings)';

  @override
  String get myIdHint => 'Enter your desired ID';

  @override
  String get duplicateCheck => 'Check Duplicate';

  @override
  String get idAvailable => 'This ID is available.';

  @override
  String get idDuplicate => 'This ID is already in use.';

  @override
  String get idEmpty => 'Please enter an ID.';

  @override
  String get myReligion => 'My Religion';

  @override
  String get myCountry => 'My Country';

  @override
  String get lockedWarning => 'Once set, ID, religion, and country cannot be changed.';

  @override
  String get beforeSaveHint => 'Once confirmed, religion and country cannot be changed.';

  @override
  String get saveComplete => 'Settings saved. ID, religion, and country cannot be changed.';

  @override
  String get confirmDialogTitle => 'Are you sure?';

  @override
  String get confirmDialogMessage => 'Once saved, religion and country cannot be changed again.';

  @override
  String adWatchCount(int count) {
    return 'Ads watched: $count times';
  }

  @override
  String donationPoints(int points) {
    return 'Donated: $points P';
  }

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageChanged => 'Language has been changed.';

  @override
  String get translate => 'Translate';

  @override
  String get showOriginal => 'Original';

  @override
  String get translating => 'Translating...';

  @override
  String get translationUnavailable => 'Install the app to use translation.';

  @override
  String get modelDownloading => 'Downloading language pack... (~30MB)';

  @override
  String get writePost => 'Write Post';

  @override
  String get deletePost => 'Delete Post';

  @override
  String get deleteComment => 'Delete Comment';

  @override
  String get deleteConfirm => 'Delete this?';

  @override
  String get enterComment => 'Enter a comment';

  @override
  String get loginForComment => 'Log in to leave a comment';

  @override
  String get anonymous => 'Anonymous';

  @override
  String get noPost => 'Post not found.';

  @override
  String get postLabel => 'Post';

  @override
  String get commentLabel => 'Comments';

  @override
  String get firstComment => 'Be the first to comment.';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get allTime => 'All Time';

  @override
  String get religionRanking => 'Religion Ranking';

  @override
  String get countryRanking => 'Country Ranking';

  @override
  String get accountRanking => 'Account Ranking';

  @override
  String get donation => 'Support';

  @override
  String get watchAd => 'Watch ad & earn 1P';

  @override
  String get adPointsEarned => '1 P earned';

  @override
  String get back => 'Back';

  @override
  String get religionSupportPointsTitle => 'Religion Support Points';

  @override
  String get religionType => 'Religion';

  @override
  String get accountType => 'Account';

  @override
  String get countryType => 'Country';

  @override
  String get supportPointHint => 'Earn points in Support';

  @override
  String seeAllReligions(int count) {
    return 'See all ($count religions)';
  }

  @override
  String totalCountries(int count) {
    return 'Total $count countries';
  }

  @override
  String get heavenCertificateTitle => '🌟 Heavenly Estate Certificate';

  @override
  String get heavenSubtitle => 'Own your own eternal resting place';

  @override
  String get buyLand => 'Buy Land';

  @override
  String get translateGuideTooltip => 'Page translation guide';

  @override
  String get pageTranslateTitle => 'Page Translation';

  @override
  String get pageTranslateBody => 'This page is in Korean. To translate:\n\n• Chrome/Edge: click the translate icon in the address bar,\n• or right-click the page and select \"Translate to...\".';

  @override
  String get homeTab => 'Home';

  @override
  String get supportTab => 'Support';

  @override
  String get activityNewsTab => 'Activity';

  @override
  String rankLabel(int rank) {
    return '#$rank';
  }

  @override
  String get activityNewsTitle => 'Activity News';

  @override
  String get seeAll => 'See All';

  @override
  String get noActivityYet => 'No activity news yet.';

  @override
  String get boardTitle => 'Board';

  @override
  String get noPostsYet => 'No posts yet.';

  @override
  String get noPostsWriteFirst => 'No posts yet.\nWrite the first post!';

  @override
  String get supportThisReligion => 'Support this religion';

  @override
  String get noReligionActivity => 'No activity news for this religion.';

  @override
  String get noReligionBoardPosts => 'No board posts for this religion.';

  @override
  String get cannotLoadList => 'Unable to load the list.';

  @override
  String commentCount(int count) {
    return 'Comments $count';
  }

  @override
  String get heavenPurchaseTitle => 'Heaven Land Purchase';

  @override
  String get basicInfo => 'Basic Info';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHint => 'Enter owner name';

  @override
  String get enterName => 'Please enter your name.';

  @override
  String get selectReligion => 'Select Religion';

  @override
  String get styleSettings => 'Style Settings';

  @override
  String get baseWorld => 'Base World & Religion';

  @override
  String get locationLabel => 'Location & Terrain';

  @override
  String get vibeLabel => 'Vibe & Elements';

  @override
  String get visualLabel => 'Visual/Sensory Effects';

  @override
  String get specialPerksLabel => 'Special Perks';

  @override
  String get shippingInfo => 'Shipping Info';

  @override
  String get countryHint => 'e.g. South Korea';

  @override
  String get enterCountry => 'Please enter country.';

  @override
  String get addressLabel => 'Address';

  @override
  String get addressHint => 'Detailed address for certificate delivery';

  @override
  String get enterAddress => 'Please enter address.';

  @override
  String get contactLabel => 'Contact';

  @override
  String get contactHint => 'Phone number or email';

  @override
  String get enterContact => 'Please enter contact info.';

  @override
  String get selectAllRequired => 'Please select all required items.';

  @override
  String get registerFailed => 'Registration failed';

  @override
  String get heavenDonationNoticeShort => 'Land usage fees purchased in this life\nare used to help neighbors in need.';

  @override
  String get processing => 'Processing...';

  @override
  String get buyHeavenLand => 'Buy Heaven Land';

  @override
  String get pleaseSelect => 'Please select.';

  @override
  String congratsOwner(String name) {
    return '$name,\nyour land has been purchased!';
  }

  @override
  String heavenCertificateArrival(String afterlife) {
    return 'In about 3-4 weeks, a\n$afterlife land certificate will arrive at your address.';
  }

  @override
  String get purchaseDetails => 'Purchase Details';

  @override
  String get ownerLabel => 'Owner';

  @override
  String get shippingCountry => 'Shipping Country';

  @override
  String get heavenDonationNoticeLong => 'Land usage fees purchased in this life\nare used to help neighbors in need.\nYour good deed will be recorded forever in heaven.';

  @override
  String get goHome => 'Go Home';
}
