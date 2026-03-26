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

  @override
  String get religionSupportPointsTitle => 'Очки поддержки по религиям';

  @override
  String get religionType => 'Религия';

  @override
  String get accountType => 'Аккаунт';

  @override
  String get countryType => 'Страна';

  @override
  String get supportPointHint => 'Набирайте очки в разделе Поддержка';

  @override
  String seeAllReligions(int count) {
    return 'Показать все ($count религий)';
  }

  @override
  String totalCountries(int count) {
    return 'Всего $count стран';
  }

  @override
  String get heavenCertificateTitle => '🌟 Сертификат владения небесной территорией';

  @override
  String get heavenSubtitle => 'Владейте своим вечным местом покоя';

  @override
  String get buyLand => 'Купить землю';

  @override
  String get translateGuideTooltip => 'Подсказка по переводу страницы';

  @override
  String get pageTranslateTitle => 'Перевод страницы';

  @override
  String get pageTranslateBody => 'Эта страница на корейском языке.\n\nЧтобы перевести:\n• Chrome/Edge: нажмите значок перевода в адресной строке\n• или кликните правой кнопкой и выберите \"Translate to...\"';

  @override
  String get homeTab => 'Главная';

  @override
  String get supportTab => 'Поддержка';

  @override
  String get activityNewsTab => 'Новости';

  @override
  String rankLabel(int rank) {
    return '#$rank';
  }

  @override
  String get activityNewsTitle => 'Новости активности';

  @override
  String get seeAll => 'Показать все';

  @override
  String get noActivityYet => 'Пока нет новостей активности.';

  @override
  String get boardTitle => 'Форум';

  @override
  String get noPostsYet => 'Пока нет публикаций.';

  @override
  String get noPostsWriteFirst => 'Пока нет публикаций.\nНапишите первую!';

  @override
  String get supportThisReligion => 'Поддержать эту религию';

  @override
  String get noReligionActivity => 'Нет новостей для этой религии.';

  @override
  String get noReligionBoardPosts => 'Нет постов форума для этой религии.';

  @override
  String get cannotLoadList => 'Не удалось загрузить список.';

  @override
  String commentCount(int count) {
    return 'Комментарии $count';
  }

  @override
  String get heavenPurchaseTitle => 'Покупка небесной земли';

  @override
  String get basicInfo => 'Основная информация';

  @override
  String get nameLabel => 'Имя';

  @override
  String get nameHint => 'Введите имя владельца';

  @override
  String get enterName => 'Введите имя.';

  @override
  String get selectReligion => 'Выберите религию';

  @override
  String get styleSettings => 'Настройки стиля';

  @override
  String get baseWorld => 'Базовый мир и религия';

  @override
  String get locationLabel => 'Местоположение и рельеф';

  @override
  String get vibeLabel => 'Атмосфера и элементы';

  @override
  String get visualLabel => 'Визуальные/чувственные эффекты';

  @override
  String get specialPerksLabel => 'Особые услуги';

  @override
  String get shippingInfo => 'Информация о доставке';

  @override
  String get countryHint => 'Например: Южная Корея';

  @override
  String get enterCountry => 'Введите страну.';

  @override
  String get addressLabel => 'Адрес';

  @override
  String get addressHint => 'Подробный адрес для сертификата';

  @override
  String get enterAddress => 'Введите адрес.';

  @override
  String get contactLabel => 'Контакт';

  @override
  String get contactHint => 'Телефон или e-mail';

  @override
  String get enterContact => 'Введите контакт.';

  @override
  String get selectAllRequired => 'Выберите все обязательные пункты.';

  @override
  String get registerFailed => 'Ошибка регистрации';

  @override
  String get heavenDonationNoticeShort => 'Плата за землю, купленную в этой жизни,\nиспользуется для помощи нуждающимся соседям.';

  @override
  String get processing => 'Обработка...';

  @override
  String get buyHeavenLand => 'Купить небесную землю';

  @override
  String get pleaseSelect => 'Пожалуйста, выберите.';

  @override
  String congratsOwner(String name) {
    return '🎉 $name,\nваша земля успешно куплена!';
  }

  @override
  String heavenCertificateArrival(String afterlife) {
    return 'Примерно через 3-4 недели\nсертификат земли $afterlife будет доставлен по вашему адресу.';
  }

  @override
  String get purchaseDetails => 'Детали покупки';

  @override
  String get ownerLabel => 'Владелец';

  @override
  String get shippingCountry => 'Страна доставки';

  @override
  String get heavenDonationNoticeLong => 'Плата за землю, купленную в этой жизни,\nиспользуется для помощи нуждающимся соседям.\nВаше доброе дело навсегда будет записано на небесах.';

  @override
  String get goHome => 'На главную';
}
