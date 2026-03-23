// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Kindly-God';

  @override
  String get save => '保存';

  @override
  String get saving => '保存中...';

  @override
  String get cancel => 'キャンセル';

  @override
  String get close => '閉じる';

  @override
  String get confirm => '確認';

  @override
  String get select => '選択する';

  @override
  String get retry => '再試行';

  @override
  String get loading => '読み込み中...';

  @override
  String get error => 'エラーが発生しました。';

  @override
  String get delete => '削除';

  @override
  String get loginTitle => 'ログイン';

  @override
  String get loginWithGoogle => 'Googleでログイン';

  @override
  String get loginLoading => 'ログイン中...';

  @override
  String get logout => 'ログアウト';

  @override
  String get loginRequired => 'ログインが必要です';

  @override
  String get loginRequiredMessage => 'Googleアカウントでログインしてください。';

  @override
  String get adminAccess => '管理者アクセス';

  @override
  String get adminAccessLoading => '管理者アクセス中...';

  @override
  String get adminAccessSuccess => '管理者としてログインしました。';

  @override
  String get account => 'アカウント';

  @override
  String get myId => 'ID（ランキングに表示）';

  @override
  String get myIdHint => 'IDを入力してください';

  @override
  String get duplicateCheck => '重複確認';

  @override
  String get idAvailable => '使用可能なIDです。';

  @override
  String get idDuplicate => '既に使用されているIDです。';

  @override
  String get idEmpty => 'IDを入力してください。';

  @override
  String get myReligion => '私の宗教';

  @override
  String get myCountry => '私の国';

  @override
  String get lockedWarning => '一度設定したID・宗教・国は変更できません。';

  @override
  String get beforeSaveHint => '確認後、宗教と国は変更できなくなります。';

  @override
  String get saveComplete => '設定が完了しました。ID・宗教・国は変更できません。';

  @override
  String get confirmDialogTitle => '本当に保存しますか？';

  @override
  String get confirmDialogMessage => '一度保存すると、宗教と国を再び変更することはできません。';

  @override
  String adWatchCount(int count) {
    return '広告視聴 $count 回';
  }

  @override
  String donationPoints(int points) {
    return '寄付ポイント $points P';
  }

  @override
  String get languageSettings => '言語設定';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get languageChanged => '言語が変更されました。';

  @override
  String get translate => '翻訳';

  @override
  String get showOriginal => '原文';

  @override
  String get translating => '翻訳中...';

  @override
  String get translationUnavailable => '翻訳はアプリをインストールしてご利用ください。';

  @override
  String get modelDownloading => '言語パックをダウンロード中... (約30MB)';

  @override
  String get writePost => '投稿する';

  @override
  String get deletePost => '投稿を削除';

  @override
  String get deleteComment => 'コメントを削除';

  @override
  String get deleteConfirm => '削除しますか？';

  @override
  String get enterComment => 'コメントを入力してください';

  @override
  String get loginForComment => 'ログイン後にコメントできます';

  @override
  String get anonymous => '匿名';

  @override
  String get noPost => '投稿が見つかりません。';

  @override
  String get postLabel => '投稿';

  @override
  String get commentLabel => 'コメント';

  @override
  String get firstComment => '最初のコメントを残してください。';

  @override
  String get today => '今日';

  @override
  String get thisWeek => '今週';

  @override
  String get thisMonth => '今月';

  @override
  String get allTime => '全体';

  @override
  String get religionRanking => '宗教別ランキング';

  @override
  String get countryRanking => '国別ランキング';

  @override
  String get accountRanking => 'アカウントランキング';

  @override
  String get donation => '応援する';

  @override
  String get watchAd => '広告を見て1Pゲット';

  @override
  String get adPointsEarned => '1 P 獲得';

  @override
  String get back => '戻る';
}
