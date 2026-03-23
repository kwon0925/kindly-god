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
}
