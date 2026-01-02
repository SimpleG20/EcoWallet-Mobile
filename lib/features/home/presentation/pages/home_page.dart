import 'package:eco_wallet/core/presentation/controllers/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../widgets/home_header.dart';
import '../widgets/dismissible_transaction_card.dart';
import '../widgets/eco_footprint_card.dart';
import '../widgets/home_action_buttons.dart';
import '../widgets/add_transaction_modal.dart';
import '../widgets/balance_card/balance_card.dart';
import '../widgets/skeletons/home_page_skeleton.dart';
import '../../domain/entities/eco_data.dart';
import '../../domain/entities/weekly_transaction_data.dart';
import '../../domain/usecases/calculate_weekly_transactions.dart';
import '../../../wallet/domain/entities/transaction.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../injection_container.dart' as di;
import '../../../../core/constants/transaction_type_data.dart';

/// Main home page of the application.
///
/// Displays the user's financial overview including balance, weekly chart,
/// eco footprint, and recent transactions.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Use case instance for calculating weekly transactions
  static final _calculateWeeklyTransactions = CalculateWeeklyTransactions();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => di.sl<WalletBloc>()..add(LoadWalletDataEvent()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primaryContainer,
        ),
        body: BlocBuilder<WalletBloc, BaseWalletState>(
          builder: (context, state) {
            if (state is WalletLoading) {
              return const HomePageSkeleton();
            }

            if (state is WalletError) {
              return Center(
                child: Text(
                  state.message,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              );
            }

            if (state is WalletLoaded) {
              return _HomeBody(
                loc: loc,
                theme: theme,
                state: state,
                ecoData: EcoData.fromTransactions(loc, state.transactions),
                weeklyData: _calculateWeeklyTransactions(state.recentTransactions),
                onAddTransaction: (type, {Transaction? transaction}) =>
                    _showAddTransactionModal(context, type, transactionToEdit: transaction),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showAddTransactionModal(
    BuildContext context,
    ETransactionType type, {
    Transaction? transactionToEdit,
  }) {
    final walletBloc = context.read<WalletBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => BlocProvider.value(
        value: walletBloc,
        child: AddTransactionModal(
          transactionType: type,
          transactionToEdit: transactionToEdit,
        ),
      ),
    );
  }
}

/// Internal widget containing the home page body content.
class _HomeBody extends StatelessWidget {
  const _HomeBody({
    required this.loc,
    required this.theme,
    required this.state,
    required this.ecoData,
    required this.weeklyData,
    required this.onAddTransaction,
  });

  final AppLocalizations loc;
  final ThemeData theme;
  final WalletLoaded state;
  final EcoData ecoData;
  final WeeklyTransactionData weeklyData;
  final void Function(ETransactionType type, {Transaction? transaction}) onAddTransaction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HeaderSection(
          loc: loc,
          theme: theme,
          totalBalance: state.totalBalance,
          monthlySavings: state.monthlySavings,
          weeklyData: weeklyData,
          onIncomePressed: () => onAddTransaction(ETransactionType.income),
          onExpensePressed: () => onAddTransaction(ETransactionType.expense),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                EcoFootprintCard(ecoData: ecoData),
                const SizedBox(height: 8),
                _TransactionsSection(
                  loc: loc,
                  theme: theme,
                  transactions: state.transactions,
                  onTransactionTap: (transaction) => onAddTransaction(
                    transaction.type,
                    transaction: transaction,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Header section containing the balance card and action buttons.
class _HeaderSection extends StatelessWidget {
  const _HeaderSection({
    required this.loc,
    required this.theme,
    required this.totalBalance,
    required this.monthlySavings,
    required this.weeklyData,
    required this.onIncomePressed,
    required this.onExpensePressed,
  });

  final AppLocalizations loc;
  final ThemeData theme;
  final double totalBalance;
  final double monthlySavings;
  final WeeklyTransactionData weeklyData;
  final VoidCallback onIncomePressed;
  final VoidCallback onExpensePressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Stack(
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(16.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeader(
                  welcomeText: loc.welcome,
                  titleText: loc.appTitle,
                ),
                const SizedBox(height: 20),
                BalanceCard(
                  totalBalance: totalBalance,
                  monthlySavings: monthlySavings,
                  weeklyData: weeklyData,
                ),
                const SizedBox(height: 8),
                HomeActionButtons(
                  incomeLabel: loc.lbIncome,
                  expenseLabel: loc.lbExpense,
                  onIncomePressed: onIncomePressed,
                  onExpensePressed: onExpensePressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Section displaying recent transactions header and list.
class _TransactionsSection extends StatelessWidget {
  const _TransactionsSection({
    required this.loc,
    required this.theme,
    required this.transactions,
    required this.onTransactionTap,
  });

  final AppLocalizations loc;
  final ThemeData theme;
  final List<Transaction> transactions;
  final void Function(Transaction) onTransactionTap;

  static const int _maxVisibleTransactions = 5;

  @override
  Widget build(BuildContext context) {
    final hideValue = context.select((SettingsBloc bloc) {
      final state = bloc.state;
      if (state is SettingsLoadedState) {
        return state.preferences.appearancePreferences.hideValues;
      }
      return false;
    });

    return Column(
      children: [
        _buildHeader(context),
        const SizedBox(height: 8),
        _buildList(hideValue),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            loc.dashboardRecentTransactions,
            style: theme.textTheme.titleMedium,
          ),
          TextButton(
            onPressed: () {
              context.read<NavigationCubit>().goToWallet();
            },
            child: Text(loc.btnViewAll),
          ),
        ],
      ),
    );
  }

  Widget _buildList(bool hideValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.2),
              blurRadius: 8,
            ),
          ],
        ),
        child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          child: transactions.isEmpty ? _buildEmptyState() : _buildTransactionsList(hideValue),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        textAlign: TextAlign.center,
        loc.dashboardNoTransactions,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
    );
  }

  Widget _buildTransactionsList(bool hideValue) {
    final visibleCount = transactions.length > _maxVisibleTransactions ? _maxVisibleTransactions : transactions.length;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: visibleCount,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return DismissibleTransactionCard(
          transaction: transaction,
          onTap: () => onTransactionTap(transaction),
          hideValue: hideValue,
        );
      },
    );
  }
}
