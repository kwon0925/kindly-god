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

  @override
  String get religionSupportPointsTitle => '宗教別応援ポイント';

  @override
  String get religionType => '宗教';

  @override
  String get accountType => 'アカウント';

  @override
  String get countryType => '国家';

  @override
  String get supportPointHint => '応援でポイントを貯めてみましょう';

  @override
  String seeAllReligions(int count) {
    return 'すべて表示（$count宗教）';
  }

  @override
  String totalCountries(int count) {
    return '合計 $count か国';
  }

  @override
  String get heavenCertificateTitle => '🌟 天国領土所有証書';

  @override
  String get heavenSubtitle => 'あなただけの永遠の安息地を所有しましょう';

  @override
  String get buyLand => '土地購入';

  @override
  String get translateGuideTooltip => 'ページ翻訳案内';

  @override
  String get pageTranslateTitle => 'ページ翻訳';

  @override
  String get pageTranslateBody => 'このページは韓国語です。\n\n翻訳するには:\n• Chrome/Edge: アドレスバー右側の翻訳アイコンを押す\n• または右クリックして「Translate to...」を選択';

  @override
  String get homeTab => 'ホーム';

  @override
  String get supportTab => '応援';

  @override
  String get activityNewsTab => '活動ニュース';

  @override
  String rankLabel(int rank) {
    return '$rank位';
  }

  @override
  String get activityNewsTitle => '活動ニュース';

  @override
  String get seeAll => 'すべて表示';

  @override
  String get noActivityYet => 'まだ活動ニュースがありません。';

  @override
  String get boardTitle => '掲示板';

  @override
  String get noPostsYet => 'まだ投稿がありません。';

  @override
  String get noPostsWriteFirst => 'まだ投稿がありません。\n最初の投稿を書いてみましょう！';

  @override
  String get supportThisReligion => 'この宗教を応援する';

  @override
  String get noReligionActivity => 'この宗教の活動ニュースはありません。';

  @override
  String get noReligionBoardPosts => 'この宗教の掲示板に投稿がありません。';

  @override
  String get cannotLoadList => '一覧を読み込めません。';

  @override
  String commentCount(int count) {
    return 'コメント $count';
  }

  @override
  String get heavenPurchaseTitle => '天国の土地購入';

  @override
  String get basicInfo => '基本情報';

  @override
  String get nameLabel => '名前';

  @override
  String get nameHint => '所有者の名前を入力してください';

  @override
  String get enterName => '名前を入力してください。';

  @override
  String get selectReligion => '宗教を選択';

  @override
  String get styleSettings => 'スタイル設定';

  @override
  String get baseWorld => '世界観と宗教';

  @override
  String get locationLabel => '立地と地形';

  @override
  String get vibeLabel => '雰囲気と構成';

  @override
  String get visualLabel => '視覚・感覚効果';

  @override
  String get specialPerksLabel => '特別サービス';

  @override
  String get shippingInfo => '配送情報';

  @override
  String get countryHint => '例: 日本';

  @override
  String get enterCountry => '国を入力してください。';

  @override
  String get addressLabel => '住所';

  @override
  String get addressHint => '証明書を受け取る詳細住所';

  @override
  String get enterAddress => '住所を入力してください。';

  @override
  String get contactLabel => '連絡先';

  @override
  String get contactHint => '電話番号またはメール';

  @override
  String get enterContact => '連絡先を入力してください。';

  @override
  String get selectAllRequired => 'すべての項目を選択してください。';

  @override
  String get registerFailed => '登録失敗';

  @override
  String get heavenDonationNoticeShort => 'この世で購入した土地利用料は\n困っている人々のために使われます。';

  @override
  String get processing => '処理中...';

  @override
  String get buyHeavenLand => '天国の土地を購入';

  @override
  String get pleaseSelect => '選択してください。';

  @override
  String congratsOwner(String name) {
    return '🎉 $nameさん、\n土地の購入が完了しました！';
  }

  @override
  String heavenCertificateArrival(String afterlife) {
    return '約3〜4週間後、\n$afterlife 土地証明書が住所に届きます。';
  }

  @override
  String get purchaseDetails => '購入内容';

  @override
  String get ownerLabel => '所有者';

  @override
  String get shippingCountry => '配送国';

  @override
  String get heavenDonationNoticeLong => 'この世で購入した土地利用料は\n困っている人々のために使われます。\nあなたの善行は天に永遠に記録されます。';

  @override
  String get goHome => 'ホームへ';

  @override
  String get notificationSectionTitle => '通知';

  @override
  String get pushNotificationsTitle => 'プッシュ通知';

  @override
  String notificationStatusWithValue(String value) {
    return '状態: $value';
  }

  @override
  String get notificationPermissionGranted => '許可';

  @override
  String get notificationPermissionDenied => '拒否';

  @override
  String get notificationPermissionUnknown => '未確認';

  @override
  String get notificationPermissionRequest => '通知を許可';

  @override
  String get notificationPermissionGrantedMessage => '通知が許可されました。';

  @override
  String get notificationPermissionDeniedMessage => '通知が拒否されているか、ブラウザでブロックされています。';
}
