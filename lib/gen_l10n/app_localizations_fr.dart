// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Kindly-God';

  @override
  String get save => 'Enregistrer';

  @override
  String get saving => 'Enregistrement...';

  @override
  String get cancel => 'Annuler';

  @override
  String get close => 'Fermer';

  @override
  String get confirm => 'Confirmer';

  @override
  String get select => 'Sélectionner';

  @override
  String get retry => 'Réessayer';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Une erreur s\'est produite.';

  @override
  String get delete => 'Supprimer';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get loginWithGoogle => 'Se connecter avec Google';

  @override
  String get loginLoading => 'Connexion en cours...';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get loginRequired => 'Connexion requise';

  @override
  String get loginRequiredMessage => 'Veuillez vous connecter avec votre compte Google.';

  @override
  String get adminAccess => 'Accès administrateur';

  @override
  String get adminAccessLoading => 'Accès en tant qu\'administrateur...';

  @override
  String get adminAccessSuccess => 'Connecté en tant qu\'administrateur.';

  @override
  String get account => 'Compte';

  @override
  String get myId => 'ID (affiché dans les classements)';

  @override
  String get myIdHint => 'Entrez l\'ID souhaité';

  @override
  String get duplicateCheck => 'Vérifier la duplication';

  @override
  String get idAvailable => 'Cet ID est disponible.';

  @override
  String get idDuplicate => 'Cet ID est déjà utilisé.';

  @override
  String get idEmpty => 'Veuillez entrer un ID.';

  @override
  String get myReligion => 'Ma religion';

  @override
  String get myCountry => 'Mon pays';

  @override
  String get lockedWarning => 'Une fois définis, l\'ID, la religion et le pays ne peuvent pas être modifiés.';

  @override
  String get beforeSaveHint => 'Une fois confirmés, la religion et le pays ne peuvent pas être modifiés.';

  @override
  String get saveComplete => 'Paramètres enregistrés. ID, religion et pays ne peuvent pas être modifiés.';

  @override
  String get confirmDialogTitle => 'Êtes-vous sûr ?';

  @override
  String get confirmDialogMessage => 'Une fois enregistrée, la religion et le pays ne peuvent plus être modifiés.';

  @override
  String adWatchCount(int count) {
    return 'Publicités vues : $count fois';
  }

  @override
  String donationPoints(int points) {
    return 'Points donnés : $points P';
  }

  @override
  String get languageSettings => 'Paramètres de langue';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get languageChanged => 'La langue a été changée.';

  @override
  String get translate => 'Traduire';

  @override
  String get showOriginal => 'Original';

  @override
  String get translating => 'Traduction...';

  @override
  String get translationUnavailable => 'Installez l\'application pour utiliser la traduction.';

  @override
  String get modelDownloading => 'Téléchargement du pack de langue... (~30Mo)';

  @override
  String get writePost => 'Écrire un article';

  @override
  String get deletePost => 'Supprimer l\'article';

  @override
  String get deleteComment => 'Supprimer le commentaire';

  @override
  String get deleteConfirm => 'Supprimer ?';

  @override
  String get enterComment => 'Entrez un commentaire';

  @override
  String get loginForComment => 'Connectez-vous pour laisser un commentaire';

  @override
  String get anonymous => 'Anonyme';

  @override
  String get noPost => 'Article introuvable.';

  @override
  String get postLabel => 'Article';

  @override
  String get commentLabel => 'Commentaires';

  @override
  String get firstComment => 'Soyez le premier à commenter.';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get thisMonth => 'Ce mois';

  @override
  String get allTime => 'Tout le temps';

  @override
  String get religionRanking => 'Classement par religion';

  @override
  String get countryRanking => 'Classement par pays';

  @override
  String get accountRanking => 'Classement des comptes';

  @override
  String get donation => 'Soutenir';

  @override
  String get watchAd => 'Regarder une pub et gagner 1P';

  @override
  String get adPointsEarned => '1 P gagné';

  @override
  String get back => 'Retour';

  @override
  String get religionSupportPointsTitle => 'Points de soutien par religion';

  @override
  String get religionType => 'Religion';

  @override
  String get accountType => 'Compte';

  @override
  String get countryType => 'Pays';

  @override
  String get supportPointHint => 'Gagnez des points dans Soutenir';

  @override
  String seeAllReligions(int count) {
    return 'Voir tout ($count religions)';
  }

  @override
  String totalCountries(int count) {
    return 'Total $count pays';
  }

  @override
  String get heavenCertificateTitle => '🌟 Certificat de territoire céleste';

  @override
  String get heavenSubtitle => 'Possédez votre propre lieu de repos éternel';

  @override
  String get buyLand => 'Acheter un terrain';

  @override
  String get translateGuideTooltip => 'Guide de traduction de page';

  @override
  String get pageTranslateTitle => 'Traduction de page';

  @override
  String get pageTranslateBody => 'Cette page est en coréen.\n\nPour traduire :\n• Chrome/Edge : cliquez sur l\'icône de traduction dans la barre d\'adresse\n• ou clic droit puis \"Translate to...\"';

  @override
  String get homeTab => 'Accueil';

  @override
  String get supportTab => 'Soutenir';

  @override
  String get activityNewsTab => 'Actualités';

  @override
  String rankLabel(int rank) {
    return '#$rank';
  }

  @override
  String get activityNewsTitle => 'Actualités d\'activité';

  @override
  String get seeAll => 'Voir tout';

  @override
  String get noActivityYet => 'Aucune actualité pour le moment.';

  @override
  String get boardTitle => 'Forum';

  @override
  String get noPostsYet => 'Aucun post pour le moment.';

  @override
  String get noPostsWriteFirst => 'Aucun post pour le moment.\nÉcrivez le premier !';

  @override
  String get supportThisReligion => 'Soutenir cette religion';

  @override
  String get noReligionActivity => 'Aucune actualité pour cette religion.';

  @override
  String get noReligionBoardPosts => 'Aucun post du forum pour cette religion.';

  @override
  String get cannotLoadList => 'Impossible de charger la liste.';

  @override
  String commentCount(int count) {
    return 'Commentaires $count';
  }

  @override
  String get heavenPurchaseTitle => 'Achat de territoire céleste';

  @override
  String get basicInfo => 'Informations de base';

  @override
  String get nameLabel => 'Nom';

  @override
  String get nameHint => 'Entrez le nom du propriétaire';

  @override
  String get enterName => 'Veuillez entrer le nom.';

  @override
  String get selectReligion => 'Sélectionner la religion';

  @override
  String get styleSettings => 'Paramètres de style';

  @override
  String get baseWorld => 'Monde de base et religion';

  @override
  String get locationLabel => 'Emplacement et terrain';

  @override
  String get vibeLabel => 'Ambiance et éléments';

  @override
  String get visualLabel => 'Effets visuels/sensoriels';

  @override
  String get specialPerksLabel => 'Services spéciaux';

  @override
  String get shippingInfo => 'Informations de livraison';

  @override
  String get countryHint => 'Ex : Corée du Sud';

  @override
  String get enterCountry => 'Veuillez entrer le pays.';

  @override
  String get addressLabel => 'Adresse';

  @override
  String get addressHint => 'Adresse détaillée pour recevoir le certificat';

  @override
  String get enterAddress => 'Veuillez entrer l\'adresse.';

  @override
  String get contactLabel => 'Contact';

  @override
  String get contactHint => 'Téléphone ou e-mail';

  @override
  String get enterContact => 'Veuillez entrer un contact.';

  @override
  String get selectAllRequired => 'Veuillez sélectionner tous les champs requis.';

  @override
  String get registerFailed => 'Échec de l\'enregistrement';

  @override
  String get heavenDonationNoticeShort => 'Les frais de terrain achetés dans cette vie\nservent à aider les voisins dans le besoin.';

  @override
  String get processing => 'Traitement...';

  @override
  String get buyHeavenLand => 'Acheter un territoire céleste';

  @override
  String get pleaseSelect => 'Veuillez sélectionner.';

  @override
  String congratsOwner(String name) {
    return '🎉 $name,\nvotre terrain a été acheté !';
  }

  @override
  String heavenCertificateArrival(String afterlife) {
    return 'Dans 3 à 4 semaines environ,\nle certificat de terre de $afterlife arrivera à votre adresse.';
  }

  @override
  String get purchaseDetails => 'Détails de l\'achat';

  @override
  String get ownerLabel => 'Propriétaire';

  @override
  String get shippingCountry => 'Pays de livraison';

  @override
  String get heavenDonationNoticeLong => 'Les frais de terrain achetés dans cette vie\nservent à aider les voisins dans le besoin.\nVotre bonne action sera enregistrée éternellement au ciel.';

  @override
  String get goHome => 'Accueil';

  @override
  String get notificationSectionTitle => 'Notifications';

  @override
  String get pushNotificationsTitle => 'Notifications push';

  @override
  String notificationStatusWithValue(String value) {
    return 'État : $value';
  }

  @override
  String get notificationPermissionGranted => 'Autorisé';

  @override
  String get notificationPermissionDenied => 'Refusé';

  @override
  String get notificationPermissionUnknown => 'Non déterminé';

  @override
  String get notificationPermissionRequest => 'Autoriser les notifications';

  @override
  String get notificationPermissionGrantedMessage => 'Autorisation de notification accordée.';

  @override
  String get notificationPermissionDeniedMessage => 'Les notifications ont été refusées ou bloquées par le navigateur.';
}
