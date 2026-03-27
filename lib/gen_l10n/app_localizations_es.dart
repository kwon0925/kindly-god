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

  @override
  String get religionSupportPointsTitle => 'Puntos de apoyo por religión';

  @override
  String get religionType => 'Religión';

  @override
  String get accountType => 'Cuenta';

  @override
  String get countryType => 'País';

  @override
  String get supportPointHint => 'Acumula puntos en Apoyar';

  @override
  String seeAllReligions(int count) {
    return 'Ver todo ($count religiones)';
  }

  @override
  String totalCountries(int count) {
    return 'Total $count países';
  }

  @override
  String get heavenCertificateTitle => '🌟 Certificado de Territorio Celestial';

  @override
  String get heavenSubtitle => 'Posee tu propio lugar de descanso eterno';

  @override
  String get buyLand => 'Comprar terreno';

  @override
  String get translateGuideTooltip => 'Guía de traducción de página';

  @override
  String get pageTranslateTitle => 'Traducción de página';

  @override
  String get pageTranslateBody => 'Esta página está en coreano.\n\nPara traducir:\n• Chrome/Edge: pulsa el icono de traducción en la barra de direcciones\n• o haz clic derecho y selecciona \"Translate to...\"';

  @override
  String get homeTab => 'Inicio';

  @override
  String get supportTab => 'Apoyar';

  @override
  String get activityNewsTab => 'Noticias';

  @override
  String rankLabel(int rank) {
    return '#$rank';
  }

  @override
  String get activityNewsTitle => 'Noticias de actividad';

  @override
  String get seeAll => 'Ver todo';

  @override
  String get noActivityYet => 'Aún no hay noticias de actividad.';

  @override
  String get boardTitle => 'Foro';

  @override
  String get noPostsYet => 'Aún no hay publicaciones.';

  @override
  String get noPostsWriteFirst => 'Aún no hay publicaciones.\n¡Escribe la primera!';

  @override
  String get supportThisReligion => 'Apoyar esta religión';

  @override
  String get noReligionActivity => 'No hay noticias para esta religión.';

  @override
  String get noReligionBoardPosts => 'No hay publicaciones del foro para esta religión.';

  @override
  String get cannotLoadList => 'No se puede cargar la lista.';

  @override
  String commentCount(int count) {
    return 'Comentarios $count';
  }

  @override
  String get heavenPurchaseTitle => 'Compra de Territorio Celestial';

  @override
  String get basicInfo => 'Información básica';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get nameHint => 'Ingrese el nombre del propietario';

  @override
  String get enterName => 'Ingrese su nombre.';

  @override
  String get selectReligion => 'Seleccionar religión';

  @override
  String get styleSettings => 'Configuración de estilo';

  @override
  String get baseWorld => 'Mundo base y religión';

  @override
  String get locationLabel => 'Ubicación y terreno';

  @override
  String get vibeLabel => 'Ambiente y elementos';

  @override
  String get visualLabel => 'Efectos visuales/sensoriales';

  @override
  String get specialPerksLabel => 'Servicios especiales';

  @override
  String get shippingInfo => 'Información de envío';

  @override
  String get countryHint => 'Ej: Corea del Sur';

  @override
  String get enterCountry => 'Ingrese el país.';

  @override
  String get addressLabel => 'Dirección';

  @override
  String get addressHint => 'Dirección detallada para recibir el certificado';

  @override
  String get enterAddress => 'Ingrese la dirección.';

  @override
  String get contactLabel => 'Contacto';

  @override
  String get contactHint => 'Teléfono o correo';

  @override
  String get enterContact => 'Ingrese el contacto.';

  @override
  String get selectAllRequired => 'Seleccione todos los campos requeridos.';

  @override
  String get registerFailed => 'Error de registro';

  @override
  String get heavenDonationNoticeShort => 'La tarifa del terreno comprado en esta vida\nse usa para ayudar a vecinos necesitados.';

  @override
  String get processing => 'Procesando...';

  @override
  String get buyHeavenLand => 'Comprar territorio celestial';

  @override
  String get pleaseSelect => 'Seleccione.';

  @override
  String congratsOwner(String name) {
    return '🎉 $name,\n¡tu terreno fue comprado!';
  }

  @override
  String heavenCertificateArrival(String afterlife) {
    return 'En unas 3-4 semanas,\nel certificado de tierra de $afterlife llegará a tu dirección.';
  }

  @override
  String get purchaseDetails => 'Detalles de compra';

  @override
  String get ownerLabel => 'Propietario';

  @override
  String get shippingCountry => 'País de envío';

  @override
  String get heavenDonationNoticeLong => 'La tarifa del terreno comprado en esta vida\nse usa para ayudar a vecinos necesitados.\nTu buena acción quedará registrada eternamente en el cielo.';

  @override
  String get goHome => 'Ir al inicio';

  @override
  String get notificationSectionTitle => 'Notificaciones';

  @override
  String get pushNotificationsTitle => 'Notificaciones push';

  @override
  String notificationStatusWithValue(String value) {
    return 'Estado: $value';
  }

  @override
  String get notificationPermissionGranted => 'Permitido';

  @override
  String get notificationPermissionDenied => 'Denegado';

  @override
  String get notificationPermissionUnknown => 'Sin determinar';

  @override
  String get notificationPermissionRequest => 'Permitir notificaciones';

  @override
  String get notificationPermissionGrantedMessage => 'Permiso de notificaciones concedido.';

  @override
  String get notificationPermissionDeniedMessage => 'Las notificaciones fueron denegadas o bloqueadas por el navegador.';
}
