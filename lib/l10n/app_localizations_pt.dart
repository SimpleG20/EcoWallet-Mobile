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
  String get welcome => 'Bem-vindo';

  @override
  String get welcomeBack => 'Bem-vindo de volta!';

  @override
  String get dashboardTotalBalance => 'Saldo Total';

  @override
  String get dashboardIncome => 'Receitas';

  @override
  String get dashboardExpense => 'Despesas';

  @override
  String get dashboardRecentTransactions => 'Transações Recentes';

  @override
  String get dashboardMonthlySavings => 'Economias Mensais';

  @override
  String get dashboardNoTransactions => 'Nenhuma transação disponível.';

  @override
  String get btnSave => 'Salvar Transação';

  @override
  String get btnCancel => 'Cancelar';

  @override
  String get btnViewAll => 'Ver Todos';

  @override
  String get btnHome => 'Início';

  @override
  String get btnWallet => 'Carteira';

  @override
  String get btnSettings => 'Configurações';

  @override
  String get btnAnalytics => 'Análises';

  @override
  String get btnProfile => 'Perfil';

  @override
  String get lbUncategorized => 'Sem Categoria';

  @override
  String get errorTitleEmpty => 'Por favor, insira um título.';

  @override
  String get errorAmountInvalid => 'Por favor, insira um valor válido.';

  @override
  String get errorAmountMustBePositive => 'O valor deve ser maior que zero.';

  @override
  String get errorAmountFormat =>
      'Formato de número inválido. Use apenas dígitos e um separador decimal.';
}
