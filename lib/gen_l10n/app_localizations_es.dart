// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Kindly-God';

  @override
  String get save => 'Guardar';

  @override
  String get saving => 'Guardando...';

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Cerrar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get select => 'Seleccionar';

  @override
  String get retry => 'Reintentar';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Se produjo un error.';

  @override
  String get delete => 'Eliminar';

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get loginWithGoogle => 'Iniciar sesión con Google';

  @override
  String get loginLoading => 'Iniciando sesión...';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get loginRequired => 'Se requiere inicio de sesión';

  @override
  String get loginRequiredMessage => 'Por favor, inicia sesión con tu cuenta de Google.';

  @override
  String get adminAccess => 'Acceso de administrador';

  @override
  String get adminAccessLoading => 'Accediendo como administrador...';

  @override
  String get adminAccessSuccess => 'Sesión iniciada como administrador.';

  @override
  String get account => 'Cuenta';

  @override
  String get myId => 'ID (mostrado en rankings)';

  @override
  String get myIdHint => 'Ingresa el ID deseado';

  @override
  String get duplicateCheck => 'Verificar duplicado';

  @override
  String get idAvailable => 'Este ID está disponible.';

  @override
  String get idDuplicate => 'Este ID ya está en uso.';

  @override
  String get idEmpty => 'Por favor, ingresa un ID.';

  @override
  String get myReligion => 'Mi religión';

  @override
  String get myCountry => 'Mi país';

  @override
  String get lockedWarning => 'Una vez establecidos, ID, religión y país no pueden cambiarse.';

  @override
  String get beforeSaveHint => 'Una vez confirmados, religión y país no pueden cambiarse.';

  @override
  String get saveComplete => 'Configuración guardada. ID, religión y país no pueden cambiarse.';

  @override
  String get confirmDialogTitle => '¿Estás seguro?';

  @override
  String get confirmDialogMessage => 'Una vez guardado, la religión y el país no se pueden cambiar nuevamente.';

  @override
  String adWatchCount(int count) {
    return 'Anuncios vistos: $count veces';
  }

  @override
  String donationPoints(int points) {
    return 'Puntos donados: $points P';
  }

  @override
  String get languageSettings => 'Configuración de idioma';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get languageChanged => 'El idioma ha sido cambiado.';

  @override
  String get translate => 'Traducir';

  @override
  String get showOriginal => 'Original';

  @override
  String get translating => 'Traduciendo...';

  @override
  String get translationUnavailable => 'Instala la app para usar la traducción.';

  @override
  String get modelDownloading => 'Descargando paquete de idioma... (~30MB)';

  @override
  String get writePost => 'Escribir publicación';

  @override
  String get deletePost => 'Eliminar publicación';

  @override
  String get deleteComment => 'Eliminar comentario';

  @override
  String get deleteConfirm => '¿Eliminar esto?';

  @override
  String get enterComment => 'Ingresa un comentario';

  @override
  String get loginForComment => 'Inicia sesión para dejar un comentario';

  @override
  String get anonymous => 'Anónimo';

  @override
  String get noPost => 'Publicación no encontrada.';

  @override
  String get postLabel => 'Publicación';

  @override
  String get commentLabel => 'Comentarios';

  @override
  String get firstComment => 'Sé el primero en comentar.';

  @override
  String get today => 'Hoy';

  @override
  String get thisWeek => 'Esta semana';

  @override
  String get thisMonth => 'Este mes';

  @override
  String get allTime => 'Todo el tiempo';

  @override
  String get religionRanking => 'Clasificación por religión';

  @override
  String get countryRanking => 'Clasificación por país';

  @override
  String get accountRanking => 'Clasificación de cuentas';

  @override
  String get donation => 'Apoyar';

  @override
  String get watchAd => 'Ver anuncio y ganar 1P';

  @override
  String get adPointsEarned => '1 P ganado';

  @override
  String get back => 'Volver';
}
