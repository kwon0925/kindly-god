// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Kindly-God';

  @override
  String get save => 'Сохранить';

  @override
  String get saving => 'Сохранение...';

  @override
  String get cancel => 'Отмена';

  @override
  String get close => 'Закрыть';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get select => 'Выбрать';

  @override
  String get retry => 'Повторить';

  @override
  String get loading => 'Загрузка...';

  @override
  String get error => 'Произошла ошибка.';

  @override
  String get delete => 'Удалить';

  @override
  String get loginTitle => 'Войти';

  @override
  String get loginWithGoogle => 'Войти через Google';

  @override
  String get loginLoading => 'Вход...';

  @override
  String get logout => 'Выйти';

  @override
  String get loginRequired => 'Требуется вход';

  @override
  String get loginRequiredMessage => 'Пожалуйста, войдите через аккаунт Google.';

  @override
  String get adminAccess => 'Доступ администратора';

  @override
  String get adminAccessLoading => 'Получение доступа администратора...';

  @override
  String get adminAccessSuccess => 'Вход выполнен как администратор.';

  @override
  String get account => 'Аккаунт';

  @override
  String get myId => 'ID (отображается в рейтинге)';

  @override
  String get myIdHint => 'Введите желаемый ID';

  @override
  String get duplicateCheck => 'Проверить дубликат';

  @override
  String get idAvailable => 'Этот ID доступен.';

  @override
  String get idDuplicate => 'Этот ID уже используется.';

  @override
  String get idEmpty => 'Пожалуйста, введите ID.';

  @override
  String get myReligion => 'Моя религия';

  @override
  String get myCountry => 'Моя страна';

  @override
  String get lockedWarning => 'Однажды установленные ID, религия и страна не могут быть изменены.';

  @override
  String get beforeSaveHint => 'После подтверждения религию и страну нельзя изменить.';

  @override
  String get saveComplete => 'Настройки сохранены. ID, религия и страна не могут быть изменены.';

  @override
  String get confirmDialogTitle => 'Вы уверены?';

  @override
  String get confirmDialogMessage => 'После сохранения религию и страну нельзя изменить снова.';

  @override
  String adWatchCount(int count) {
    return 'Просмотрено рекламы: $count раз';
  }

  @override
  String donationPoints(int points) {
    return 'Пожертвовано: $points P';
  }

  @override
  String get languageSettings => 'Настройки языка';

  @override
  String get selectLanguage => 'Выбрать язык';

  @override
  String get languageChanged => 'Язык был изменён.';

  @override
  String get translate => 'Перевести';

  @override
  String get showOriginal => 'Оригинал';

  @override
  String get translating => 'Перевод...';

  @override
  String get translationUnavailable => 'Установите приложение для использования перевода.';

  @override
  String get modelDownloading => 'Загрузка языкового пакета... (~30МБ)';

  @override
  String get writePost => 'Написать пост';

  @override
  String get deletePost => 'Удалить пост';

  @override
  String get deleteComment => 'Удалить комментарий';

  @override
  String get deleteConfirm => 'Удалить?';

  @override
  String get enterComment => 'Введите комментарий';

  @override
  String get loginForComment => 'Войдите, чтобы оставить комментарий';

  @override
  String get anonymous => 'Аноним';

  @override
  String get noPost => 'Пост не найден.';

  @override
  String get postLabel => 'Пост';

  @override
  String get commentLabel => 'Комментарии';

  @override
  String get firstComment => 'Оставьте первый комментарий.';

  @override
  String get today => 'Сегодня';

  @override
  String get thisWeek => 'На этой неделе';

  @override
  String get thisMonth => 'В этом месяце';

  @override
  String get allTime => 'За всё время';

  @override
  String get religionRanking => 'Рейтинг по религии';

  @override
  String get countryRanking => 'Рейтинг по стране';

  @override
  String get accountRanking => 'Рейтинг аккаунтов';

  @override
  String get donation => 'Поддержать';

  @override
  String get watchAd => 'Смотреть рекламу и получить 1P';

  @override
  String get adPointsEarned => '1 P получено';

  @override
  String get back => 'Назад';
}
