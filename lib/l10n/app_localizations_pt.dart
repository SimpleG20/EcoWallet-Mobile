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
  String get dashboardTotalBalance => 'Saldo Total';

  @override
  String get dashboardIncome => 'Receitas';

  @override
  String get dashboardExpense => 'Despesas';

  @override
  String get btnSave => 'Salvar Transação';

  @override
  String get btnCancel => 'Cancelar';

  @override
  String get errorTitleEmpty => 'Por favor, insira um título.';

  @override
  String get errorAmountInvalid => 'Por favor, insira um valor válido.';
}
