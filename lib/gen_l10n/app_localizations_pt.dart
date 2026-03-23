// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Kindly-God';

  @override
  String get save => 'Salvar';

  @override
  String get saving => 'Salvando...';

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Fechar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get select => 'Selecionar';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get loading => 'Carregando...';

  @override
  String get error => 'Ocorreu um erro.';

  @override
  String get delete => 'Excluir';

  @override
  String get loginTitle => 'Entrar';

  @override
  String get loginWithGoogle => 'Entrar com Google';

  @override
  String get loginLoading => 'Entrando...';

  @override
  String get logout => 'Sair';

  @override
  String get loginRequired => 'Login necessário';

  @override
  String get loginRequiredMessage => 'Por favor, faça login com sua conta Google.';

  @override
  String get adminAccess => 'Acesso de administrador';

  @override
  String get adminAccessLoading => 'Acessando como administrador...';

  @override
  String get adminAccessSuccess => 'Conectado como administrador.';

  @override
  String get account => 'Conta';

  @override
  String get myId => 'ID (mostrado no ranking)';

  @override
  String get myIdHint => 'Digite o ID desejado';

  @override
  String get duplicateCheck => 'Verificar duplicata';

  @override
  String get idAvailable => 'Este ID está disponível.';

  @override
  String get idDuplicate => 'Este ID já está em uso.';

  @override
  String get idEmpty => 'Por favor, insira um ID.';

  @override
  String get myReligion => 'Minha religião';

  @override
  String get myCountry => 'Meu país';

  @override
  String get lockedWarning => 'Uma vez definidos, ID, religião e país não podem ser alterados.';

  @override
  String get beforeSaveHint => 'Uma vez confirmados, religião e país não podem ser alterados.';

  @override
  String get saveComplete => 'Configurações salvas. ID, religião e país não podem ser alterados.';

  @override
  String get confirmDialogTitle => 'Tem certeza?';

  @override
  String get confirmDialogMessage => 'Uma vez salvo, religião e país não podem ser alterados novamente.';

  @override
  String adWatchCount(int count) {
    return 'Anúncios assistidos: $count vezes';
  }

  @override
  String donationPoints(int points) {
    return 'Pontos doados: $points P';
  }

  @override
  String get languageSettings => 'Configurações de idioma';

  @override
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get languageChanged => 'O idioma foi alterado.';

  @override
  String get translate => 'Traduzir';

  @override
  String get showOriginal => 'Original';

  @override
  String get translating => 'Traduzindo...';

  @override
  String get translationUnavailable => 'Instale o aplicativo para usar a tradução.';

  @override
  String get modelDownloading => 'Baixando pacote de idioma... (~30MB)';

  @override
  String get writePost => 'Escrever post';

  @override
  String get deletePost => 'Excluir post';

  @override
  String get deleteComment => 'Excluir comentário';

  @override
  String get deleteConfirm => 'Excluir?';

  @override
  String get enterComment => 'Digite um comentário';

  @override
  String get loginForComment => 'Faça login para deixar um comentário';

  @override
  String get anonymous => 'Anônimo';

  @override
  String get noPost => 'Post não encontrado.';

  @override
  String get postLabel => 'Post';

  @override
  String get commentLabel => 'Comentários';

  @override
  String get firstComment => 'Seja o primeiro a comentar.';

  @override
  String get today => 'Hoje';

  @override
  String get thisWeek => 'Esta semana';

  @override
  String get thisMonth => 'Este mês';

  @override
  String get allTime => 'Todo o tempo';

  @override
  String get religionRanking => 'Ranking por religião';

  @override
  String get countryRanking => 'Ranking por país';

  @override
  String get accountRanking => 'Ranking de contas';

  @override
  String get donation => 'Apoiar';

  @override
  String get watchAd => 'Assistir anúncio e ganhar 1P';

  @override
  String get adPointsEarned => '1 P ganho';

  @override
  String get back => 'Voltar';
}
