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
}
