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

  @override
  String get religionSupportPointsTitle => '宗教应援积分';

  @override
  String get religionType => '宗教';

  @override
  String get accountType => '账户';

  @override
  String get countryType => '国家';

  @override
  String get supportPointHint => '在应援中积累积分';

  @override
  String seeAllReligions(int count) {
    return '查看全部（$count个宗教）';
  }

  @override
  String totalCountries(int count) {
    return '共 $count 个国家';
  }

  @override
  String get heavenCertificateTitle => '🌟 天国领土所有证书';

  @override
  String get heavenSubtitle => '拥有属于你的永恒安息之地';

  @override
  String get buyLand => '购买土地';

  @override
  String get translateGuideTooltip => '页面翻译说明';

  @override
  String get pageTranslateTitle => '页面翻译';

  @override
  String get pageTranslateBody => '此页面为韩语。\n\n翻译方法：\n• Chrome/Edge：点击地址栏右侧翻译图标\n• 或右键页面选择“Translate to...”';

  @override
  String get homeTab => '首页';

  @override
  String get supportTab => '应援';

  @override
  String get activityNewsTab => '活动消息';

  @override
  String rankLabel(int rank) {
    return '第$rank位';
  }

  @override
  String get activityNewsTitle => '活动消息';

  @override
  String get seeAll => '查看全部';

  @override
  String get noActivityYet => '暂无活动消息。';

  @override
  String get boardTitle => '论坛';

  @override
  String get noPostsYet => '暂无帖子。';

  @override
  String get noPostsWriteFirst => '暂无帖子。\n来写第一篇吧！';

  @override
  String get supportThisReligion => '支持该宗教';

  @override
  String get noReligionActivity => '该宗教暂无活动消息。';

  @override
  String get noReligionBoardPosts => '该宗教论坛暂无帖子。';

  @override
  String get cannotLoadList => '无法加载列表。';

  @override
  String commentCount(int count) {
    return '评论 $count';
  }

  @override
  String get heavenPurchaseTitle => '天堂领土购买';

  @override
  String get basicInfo => '基本信息';

  @override
  String get nameLabel => '姓名';

  @override
  String get nameHint => '请输入所有者姓名';

  @override
  String get enterName => '请输入姓名。';

  @override
  String get selectReligion => '选择宗教';

  @override
  String get styleSettings => '风格设置';

  @override
  String get baseWorld => '世界观与宗教';

  @override
  String get locationLabel => '地形与位置';

  @override
  String get vibeLabel => '氛围与构成';

  @override
  String get visualLabel => '视觉/感官效果';

  @override
  String get specialPerksLabel => '特别服务';

  @override
  String get shippingInfo => '寄送信息';

  @override
  String get countryHint => '例如：韩国';

  @override
  String get enterCountry => '请输入国家。';

  @override
  String get addressLabel => '地址';

  @override
  String get addressHint => '填写接收证书的详细地址';

  @override
  String get enterAddress => '请输入地址。';

  @override
  String get contactLabel => '联系方式';

  @override
  String get contactHint => '手机号或邮箱';

  @override
  String get enterContact => '请输入联系方式。';

  @override
  String get selectAllRequired => '请完成所有必填项目。';

  @override
  String get registerFailed => '提交失败';

  @override
  String get heavenDonationNoticeShort => '今生购买的土地使用费\n将用于帮助困难邻里。';

  @override
  String get processing => '处理中...';

  @override
  String get buyHeavenLand => '购买天堂领土';

  @override
  String get pleaseSelect => '请选择。';

  @override
  String congratsOwner(String name) {
    return '🎉 $name，\n您的领土已购买成功！';
  }

  @override
  String heavenCertificateArrival(String afterlife) {
    return '约3~4周后，\n$afterlife 土地证书将寄送到您的地址。';
  }

  @override
  String get purchaseDetails => '购买明细';

  @override
  String get ownerLabel => '所有者';

  @override
  String get shippingCountry => '寄送国家';

  @override
  String get heavenDonationNoticeLong => '今生购买的土地使用费\n将用于帮助困难邻里。\n您的善行将永远铭刻于天上。';

  @override
  String get goHome => '返回首页';

  @override
  String get notificationSectionTitle => '通知';

  @override
  String get pushNotificationsTitle => '推送通知';

  @override
  String notificationStatusWithValue(String value) {
    return '状态：$value';
  }

  @override
  String get notificationPermissionGranted => '已允许';

  @override
  String get notificationPermissionDenied => '已拒绝';

  @override
  String get notificationPermissionUnknown => '待确认';

  @override
  String get notificationPermissionRequest => '允许通知';

  @override
  String get notificationPermissionGrantedMessage => '已允许通知权限。';

  @override
  String get notificationPermissionDeniedMessage => '通知被拒绝或已被浏览器拦截。';
}
