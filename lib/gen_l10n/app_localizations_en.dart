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
}
