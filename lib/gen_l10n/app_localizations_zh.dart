// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Kindly-God';

  @override
  String get save => '保存';

  @override
  String get saving => '保存中...';

  @override
  String get cancel => '取消';

  @override
  String get close => '关闭';

  @override
  String get confirm => '确认';

  @override
  String get select => '选择';

  @override
  String get retry => '重试';

  @override
  String get loading => '加载中...';

  @override
  String get error => '发生错误。';

  @override
  String get delete => '删除';

  @override
  String get loginTitle => '登录';

  @override
  String get loginWithGoogle => '使用Google登录';

  @override
  String get loginLoading => '登录中...';

  @override
  String get logout => '退出登录';

  @override
  String get loginRequired => '需要登录';

  @override
  String get loginRequiredMessage => '请使用Google账户登录。';

  @override
  String get adminAccess => '管理员访问';

  @override
  String get adminAccessLoading => '管理员访问中...';

  @override
  String get adminAccessSuccess => '已以管理员身份登录。';

  @override
  String get account => '账户';

  @override
  String get myId => '用户名（排行榜显示）';

  @override
  String get myIdHint => '输入您的用户名';

  @override
  String get duplicateCheck => '重复检查';

  @override
  String get idAvailable => '该用户名可用。';

  @override
  String get idDuplicate => '该用户名已被使用。';

  @override
  String get idEmpty => '请输入用户名。';

  @override
  String get myReligion => '我的宗教';

  @override
  String get myCountry => '我的国家';

  @override
  String get lockedWarning => '用户名、宗教和国家一经设置，无法更改。';

  @override
  String get beforeSaveHint => '确认后，宗教和国家将无法更改。';

  @override
  String get saveComplete => '设置已完成。用户名、宗教和国家无法更改。';

  @override
  String get confirmDialogTitle => '确认保存？';

  @override
  String get confirmDialogMessage => '保存后，宗教和国家将无法再次更改。';

  @override
  String adWatchCount(int count) {
    return '观看广告 $count 次';
  }

  @override
  String donationPoints(int points) {
    return '捐赠积分 $points P';
  }

  @override
  String get languageSettings => '语言设置';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get languageChanged => '语言已更改。';

  @override
  String get translate => '翻译';

  @override
  String get showOriginal => '原文';

  @override
  String get translating => '翻译中...';

  @override
  String get translationUnavailable => '请安装应用以使用翻译功能。';

  @override
  String get modelDownloading => '下载语言包中... (约30MB)';

  @override
  String get writePost => '写文章';

  @override
  String get deletePost => '删除文章';

  @override
  String get deleteComment => '删除评论';

  @override
  String get deleteConfirm => '确认删除？';

  @override
  String get enterComment => '请输入评论';

  @override
  String get loginForComment => '登录后可留言';

  @override
  String get anonymous => '匿名';

  @override
  String get noPost => '找不到文章。';

  @override
  String get postLabel => '文章';

  @override
  String get commentLabel => '评论';

  @override
  String get firstComment => '成为第一个评论者。';

  @override
  String get today => '今天';

  @override
  String get thisWeek => '本周';

  @override
  String get thisMonth => '本月';

  @override
  String get allTime => '全部';

  @override
  String get religionRanking => '宗教排行';

  @override
  String get countryRanking => '国家排行';

  @override
  String get accountRanking => '账户排行';

  @override
  String get donation => '支援';

  @override
  String get watchAd => '看广告获得1P';

  @override
  String get adPointsEarned => '已获得 1 P';

  @override
  String get back => '返回';
}
