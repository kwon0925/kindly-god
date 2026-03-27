// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Kindly-God';

  @override
  String get save => 'حفظ';

  @override
  String get saving => 'جارٍ الحفظ...';

  @override
  String get cancel => 'إلغاء';

  @override
  String get close => 'إغلاق';

  @override
  String get confirm => 'تأكيد';

  @override
  String get select => 'اختيار';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get error => 'حدث خطأ.';

  @override
  String get delete => 'حذف';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginWithGoogle => 'تسجيل الدخول بـ Google';

  @override
  String get loginLoading => 'جارٍ تسجيل الدخول...';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get loginRequired => 'يجب تسجيل الدخول';

  @override
  String get loginRequiredMessage => 'يرجى تسجيل الدخول باستخدام حساب Google.';

  @override
  String get adminAccess => 'وصول المسؤول';

  @override
  String get adminAccessLoading => 'جارٍ الدخول كمسؤول...';

  @override
  String get adminAccessSuccess => 'تم تسجيل الدخول كمسؤول.';

  @override
  String get account => 'الحساب';

  @override
  String get myId => 'المعرف (يظهر في التصنيفات)';

  @override
  String get myIdHint => 'أدخل المعرف المطلوب';

  @override
  String get duplicateCheck => 'التحقق من التكرار';

  @override
  String get idAvailable => 'هذا المعرف متاح.';

  @override
  String get idDuplicate => 'هذا المعرف مستخدم بالفعل.';

  @override
  String get idEmpty => 'يرجى إدخال معرف.';

  @override
  String get myReligion => 'ديني';

  @override
  String get myCountry => 'بلدي';

  @override
  String get lockedWarning => 'لا يمكن تغيير المعرف والدين والبلد بعد تحديدهم.';

  @override
  String get beforeSaveHint => 'بعد التأكيد، لن يمكن تغيير الدين والبلد.';

  @override
  String get saveComplete => 'تم حفظ الإعدادات. لا يمكن تغيير المعرف والدين والبلد.';

  @override
  String get confirmDialogTitle => 'هل أنت متأكد؟';

  @override
  String get confirmDialogMessage => 'بعد الحفظ، لن يمكن تغيير الدين والبلد مجدداً.';

  @override
  String adWatchCount(int count) {
    return 'مشاهدة الإعلانات: $count مرة';
  }

  @override
  String donationPoints(int points) {
    return 'النقاط المتبرع بها: $points P';
  }

  @override
  String get languageSettings => 'إعدادات اللغة';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get languageChanged => 'تم تغيير اللغة.';

  @override
  String get translate => 'ترجمة';

  @override
  String get showOriginal => 'الأصل';

  @override
  String get translating => 'جارٍ الترجمة...';

  @override
  String get translationUnavailable => 'ثبّت التطبيق لاستخدام الترجمة.';

  @override
  String get modelDownloading => 'جارٍ تنزيل حزمة اللغة... (~30MB)';

  @override
  String get writePost => 'كتابة منشور';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get deleteComment => 'حذف التعليق';

  @override
  String get deleteConfirm => 'حذف؟';

  @override
  String get enterComment => 'أدخل تعليقاً';

  @override
  String get loginForComment => 'سجّل الدخول لترك تعليق';

  @override
  String get anonymous => 'مجهول';

  @override
  String get noPost => 'المنشور غير موجود.';

  @override
  String get postLabel => 'منشور';

  @override
  String get commentLabel => 'تعليقات';

  @override
  String get firstComment => 'كن أول من يعلّق.';

  @override
  String get today => 'اليوم';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get allTime => 'الكل';

  @override
  String get religionRanking => 'تصنيف الأديان';

  @override
  String get countryRanking => 'تصنيف البلدان';

  @override
  String get accountRanking => 'تصنيف الحسابات';

  @override
  String get donation => 'دعم';

  @override
  String get watchAd => 'مشاهدة إعلان وكسب 1P';

  @override
  String get adPointsEarned => 'تم كسب 1 P';

  @override
  String get back => 'رجوع';

  @override
  String get religionSupportPointsTitle => 'نقاط الدعم حسب الدين';

  @override
  String get religionType => 'الدين';

  @override
  String get accountType => 'الحساب';

  @override
  String get countryType => 'الدولة';

  @override
  String get supportPointHint => 'اجمع النقاط من قسم الدعم';

  @override
  String seeAllReligions(int count) {
    return 'عرض الكل ($count ديانات)';
  }

  @override
  String totalCountries(int count) {
    return 'إجمالي $count دولة';
  }

  @override
  String get heavenCertificateTitle => '🌟 شهادة ملكية أراضي الجنة';

  @override
  String get heavenSubtitle => 'امتلك مكان راحتك الأبدي الخاص بك';

  @override
  String get buyLand => 'شراء أرض';

  @override
  String get translateGuideTooltip => 'دليل ترجمة الصفحة';

  @override
  String get pageTranslateTitle => 'ترجمة الصفحة';

  @override
  String get pageTranslateBody => 'هذه الصفحة باللغة الكورية.\n\nللترجمة:\n• في Chrome/Edge اضغط أيقونة الترجمة في شريط العنوان\n• أو انقر بزر الفأرة الأيمن واختر \"Translate to...\"';

  @override
  String get homeTab => 'الرئيسية';

  @override
  String get supportTab => 'الدعم';

  @override
  String get activityNewsTab => 'الأخبار';

  @override
  String rankLabel(int rank) {
    return '#$rank';
  }

  @override
  String get activityNewsTitle => 'أخبار النشاط';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get noActivityYet => 'لا توجد أخبار نشاط بعد.';

  @override
  String get boardTitle => 'المنتدى';

  @override
  String get noPostsYet => 'لا توجد منشورات بعد.';

  @override
  String get noPostsWriteFirst => 'لا توجد منشورات بعد.\nاكتب أول منشور!';

  @override
  String get supportThisReligion => 'ادعم هذا الدين';

  @override
  String get noReligionActivity => 'لا توجد أخبار لهذا الدين.';

  @override
  String get noReligionBoardPosts => 'لا توجد منشورات منتدى لهذا الدين.';

  @override
  String get cannotLoadList => 'تعذر تحميل القائمة.';

  @override
  String commentCount(int count) {
    return 'التعليقات $count';
  }

  @override
  String get heavenPurchaseTitle => 'شراء أرض سماوية';

  @override
  String get basicInfo => 'المعلومات الأساسية';

  @override
  String get nameLabel => 'الاسم';

  @override
  String get nameHint => 'أدخل اسم المالك';

  @override
  String get enterName => 'يرجى إدخال الاسم.';

  @override
  String get selectReligion => 'اختر الدين';

  @override
  String get styleSettings => 'إعدادات النمط';

  @override
  String get baseWorld => 'العالم الأساسي والدين';

  @override
  String get locationLabel => 'الموقع والتضاريس';

  @override
  String get vibeLabel => 'الأجواء والعناصر';

  @override
  String get visualLabel => 'التأثيرات البصرية/الحسية';

  @override
  String get specialPerksLabel => 'الخدمات الخاصة';

  @override
  String get shippingInfo => 'معلومات الشحن';

  @override
  String get countryHint => 'مثال: كوريا الجنوبية';

  @override
  String get enterCountry => 'يرجى إدخال الدولة.';

  @override
  String get addressLabel => 'العنوان';

  @override
  String get addressHint => 'العنوان التفصيلي لاستلام الشهادة';

  @override
  String get enterAddress => 'يرجى إدخال العنوان.';

  @override
  String get contactLabel => 'جهة الاتصال';

  @override
  String get contactHint => 'رقم الهاتف أو البريد الإلكتروني';

  @override
  String get enterContact => 'يرجى إدخال جهة الاتصال.';

  @override
  String get selectAllRequired => 'يرجى اختيار جميع الحقول المطلوبة.';

  @override
  String get registerFailed => 'فشل التسجيل';

  @override
  String get heavenDonationNoticeShort => 'رسوم استخدام الأرض المشتراة في هذه الحياة\nتُستخدم لمساعدة الجيران المحتاجين.';

  @override
  String get processing => 'جارٍ المعالجة...';

  @override
  String get buyHeavenLand => 'شراء أرض سماوية';

  @override
  String get pleaseSelect => 'يرجى الاختيار.';

  @override
  String congratsOwner(String name) {
    return '🎉 $name،\nتم شراء أرضك بنجاح!';
  }

  @override
  String heavenCertificateArrival(String afterlife) {
    return 'خلال حوالي 3-4 أسابيع،\nستصل شهادة أرض $afterlife إلى عنوانك.';
  }

  @override
  String get purchaseDetails => 'تفاصيل الشراء';

  @override
  String get ownerLabel => 'المالك';

  @override
  String get shippingCountry => 'دولة الشحن';

  @override
  String get heavenDonationNoticeLong => 'رسوم استخدام الأرض المشتراة في هذه الحياة\nتُستخدم لمساعدة الجيران المحتاجين.\nسيتم تسجيل عملك الصالح إلى الأبد في السماء.';

  @override
  String get goHome => 'العودة للرئيسية';

  @override
  String get notificationSectionTitle => 'الإشعارات';

  @override
  String get pushNotificationsTitle => 'إشعارات الدفع';

  @override
  String notificationStatusWithValue(String value) {
    return 'الحالة: $value';
  }

  @override
  String get notificationPermissionGranted => 'مسموح';

  @override
  String get notificationPermissionDenied => 'مرفوض';

  @override
  String get notificationPermissionUnknown => 'غير محدد';

  @override
  String get notificationPermissionRequest => 'السماح بالإشعارات';

  @override
  String get notificationPermissionGrantedMessage => 'تم منح إذن الإشعارات.';

  @override
  String get notificationPermissionDeniedMessage => 'تم رفض الإشعارات أو حظرها في المتصفح.';
}
