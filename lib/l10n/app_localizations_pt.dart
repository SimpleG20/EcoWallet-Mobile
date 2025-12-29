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
  String get addTransaction => 'Adicionar Transação';

  @override
  String get editTransaction => 'Editar Transação';

  @override
  String get dashboardTotalBalance => 'Saldo Total';

  @override
  String get dashboardMonthlySavings => 'Economias Mensais';

  @override
  String get dashboardWeeklyOverview => 'Visão Geral Semanal';

  @override
  String get dashboardRecentTransactions => 'Transações Recentes';

  @override
  String get dashboardNoTransactions => 'Nenhuma transação disponível.';

  @override
  String get dashboardWeeklyOverviewInfo =>
      'Mostra a visão geral das transações da semana.\nA barra mais à direita representa hoje.';

  @override
  String get searchTransactions => 'Pesquisar transações...';

  @override
  String get filterTransactions => 'Filtrar Transações';

  @override
  String get addFilters => 'Adicionar Filtros';

  @override
  String get btnApply => 'Aplicar';

  @override
  String get btnClear => 'Limpar';

  @override
  String get btnUndo => 'Desfazer';

  @override
  String get btnRedo => 'Refazer';

  @override
  String get btnSave => 'Salvar';

  @override
  String get btnViewAll => 'Ver Todos';

  @override
  String get lbAll => 'Todos';

  @override
  String get lbName => 'Nome';

  @override
  String get lbDate => 'Data';

  @override
  String get lbHome => 'Início';

  @override
  String get lbFood => 'Alimentação';

  @override
  String get lbType => 'Tipo';

  @override
  String get lbBills => 'Contas';

  @override
  String get lbWallet => 'Carteira';

  @override
  String get lbCancel => 'Cancelar';

  @override
  String get lbIncome => 'Receitas';

  @override
  String get lbSalary => 'Salário';

  @override
  String get lbHealth => 'Saúde';

  @override
  String get lbOthers => 'Outros';

  @override
  String get lbAmount => 'Valor';

  @override
  String get lbReserve => 'Reserva';

  @override
  String get lbProfile => 'Perfil';

  @override
  String get lbExpense => 'Despesas';

  @override
  String get lbSettings => 'Configurações';

  @override
  String get lbShopping => 'Compras';

  @override
  String get lbCategory => 'Categoria';

  @override
  String get lbAnalytics => 'Análises';

  @override
  String get lbTransport => 'Transporte';

  @override
  String get lbUncategorized => 'Sem Categoria';

  @override
  String get lbEntertainment => 'Entretenimento';

  @override
  String get lbAllTransactions => 'Todas as Transações';

  @override
  String get lbSelectDateRange => 'Selecionar Período';

  @override
  String get formNameHint => 'Insira o nome da transação';

  @override
  String get formCategoryHint => 'Escreva a categoria';

  @override
  String get msgTransactionAdded => 'Transação adicionada com sucesso.';

  @override
  String get msgTransactionUpdated => 'Transação atualizada com sucesso.';

  @override
  String get msgTransactionDeleted => 'Transação removida com sucesso.';

  @override
  String get errorAmountEmpty => 'Por favor, insira um valor.';

  @override
  String get errorCategoryEmpty => 'Por favor, selecione uma categoria.';

  @override
  String get errorDateEmpty => 'Por favor, selecione uma data.';

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
