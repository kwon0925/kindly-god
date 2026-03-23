// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Kindly-God';

  @override
  String get save => 'Speichern';

  @override
  String get saving => 'Wird gespeichert...';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get close => 'Schließen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get select => 'Auswählen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get loading => 'Wird geladen...';

  @override
  String get error => 'Ein Fehler ist aufgetreten.';

  @override
  String get delete => 'Löschen';

  @override
  String get loginTitle => 'Anmelden';

  @override
  String get loginWithGoogle => 'Mit Google anmelden';

  @override
  String get loginLoading => 'Anmeldung läuft...';

  @override
  String get logout => 'Abmelden';

  @override
  String get loginRequired => 'Anmeldung erforderlich';

  @override
  String get loginRequiredMessage => 'Bitte melde dich mit deinem Google-Konto an.';

  @override
  String get adminAccess => 'Admin-Zugang';

  @override
  String get adminAccessLoading => 'Admin-Zugang wird hergestellt...';

  @override
  String get adminAccessSuccess => 'Als Administrator angemeldet.';

  @override
  String get account => 'Konto';

  @override
  String get myId => 'ID (wird in Rankings angezeigt)';

  @override
  String get myIdHint => 'Gewünschte ID eingeben';

  @override
  String get duplicateCheck => 'Duplikat prüfen';

  @override
  String get idAvailable => 'Diese ID ist verfügbar.';

  @override
  String get idDuplicate => 'Diese ID wird bereits verwendet.';

  @override
  String get idEmpty => 'Bitte gib eine ID ein.';

  @override
  String get myReligion => 'Meine Religion';

  @override
  String get myCountry => 'Mein Land';

  @override
  String get lockedWarning => 'Einmal festgelegte ID, Religion und Land können nicht geändert werden.';

  @override
  String get beforeSaveHint => 'Nach der Bestätigung können Religion und Land nicht mehr geändert werden.';

  @override
  String get saveComplete => 'Einstellungen gespeichert. ID, Religion und Land können nicht geändert werden.';

  @override
  String get confirmDialogTitle => 'Bist du sicher?';

  @override
  String get confirmDialogMessage => 'Einmal gespeichert, können Religion und Land nicht mehr geändert werden.';

  @override
  String adWatchCount(int count) {
    return 'Werbung gesehen: $count Mal';
  }

  @override
  String donationPoints(int points) {
    return 'Gespendete Punkte: $points P';
  }

  @override
  String get languageSettings => 'Spracheinstellungen';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get languageChanged => 'Die Sprache wurde geändert.';

  @override
  String get translate => 'Übersetzen';

  @override
  String get showOriginal => 'Original';

  @override
  String get translating => 'Übersetze...';

  @override
  String get translationUnavailable => 'Installiere die App, um Übersetzung zu nutzen.';

  @override
  String get modelDownloading => 'Sprachpaket wird heruntergeladen... (~30MB)';

  @override
  String get writePost => 'Beitrag schreiben';

  @override
  String get deletePost => 'Beitrag löschen';

  @override
  String get deleteComment => 'Kommentar löschen';

  @override
  String get deleteConfirm => 'Löschen?';

  @override
  String get enterComment => 'Einen Kommentar eingeben';

  @override
  String get loginForComment => 'Melde dich an, um einen Kommentar zu hinterlassen';

  @override
  String get anonymous => 'Anonym';

  @override
  String get noPost => 'Beitrag nicht gefunden.';

  @override
  String get postLabel => 'Beitrag';

  @override
  String get commentLabel => 'Kommentare';

  @override
  String get firstComment => 'Hinterlasse den ersten Kommentar.';

  @override
  String get today => 'Heute';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String get thisMonth => 'Diesen Monat';

  @override
  String get allTime => 'Gesamtzeit';

  @override
  String get religionRanking => 'Religions-Ranking';

  @override
  String get countryRanking => 'Länder-Ranking';

  @override
  String get accountRanking => 'Konto-Ranking';

  @override
  String get donation => 'Unterstützen';

  @override
  String get watchAd => 'Werbung ansehen und 1P verdienen';

  @override
  String get adPointsEarned => '1 P verdient';

  @override
  String get back => 'Zurück';
}
