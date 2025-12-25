// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'EcoWallet';

  @override
  String get totalBalance => 'Saldo Total';

  @override
  String get income => 'Receitas';

  @override
  String get expense => 'Despesas';

  @override
  String get errorTitleEmpty => 'Por favor, insira um título.';

  @override
  String get errorAmountInvalid => 'Por favor, insira um valor válido.';

  @override
  String get btnSave => 'Salvar Transação';
}
