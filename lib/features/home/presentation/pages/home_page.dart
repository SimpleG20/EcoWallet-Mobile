import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/transaction_type_data.dart';
import '../widgets/add_transaction_modal.dart';
import '../widgets/balance_card/balance_card.dart';
import '../widgets/home_header.dart';
import '../widgets/transaction_card.dart';
import '../widgets/home_action_buttons.dart';
import '../../domain/usecases/calculate_weekly_transactions.dart';
import '../../../../injection_container.dart' as di;
import '../../../../l10n/app_localizations.dart';
import '../../../wallet/domain/entities/transaction.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';

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
            // Loading
            if (state is WalletLoading) {
              // TODO: Skeleton loader
              return const Center(child: CircularProgressIndicator());
            }

            // Error
            if (state is WalletError) {
              return Center(
                  child: Text(
                state.message,
                style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.error),
              ));
            }

            if (state is WalletLoaded) {
              return _buildBody(context, loc, theme, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations loc,
    ThemeData theme,
    WalletLoaded state,
  ) {
    return Column(
      children: [
        _buildHeaderSection(context, loc, theme, state),
        const SizedBox(height: 8),
        _buildTransactionsHeader(context, loc, theme),
        const SizedBox(height: 8),
        _buildTransactionsList(context, loc, theme, state),
        const SizedBox(height: 8),
      ],
    );
  }

  /// Builds the header section with balance card and action buttons.
  Widget _buildHeaderSection(
    BuildContext context,
    AppLocalizations loc,
    ThemeData theme,
    WalletLoaded state,
  ) {
    // Calculate weekly transaction data using the use case
    final weeklyData = _calculateWeeklyTransactions(state.recentTransactions);

    return SizedBox(
      height: 350,
      child: Stack(
        children: [
          // Background decoration
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
          // Content overlay
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
                  totalBalance: state.totalBalance,
                  monthlySavings: state.monthlySavings,
                  weeklyData: weeklyData,
                ),
                const SizedBox(height: 8),
                HomeActionButtons(
                  incomeLabel: loc.lbIncome,
                  expenseLabel: loc.lbExpense,
                  onIncomePressed: () => _showAddTransactionModal(context, ETransactionType.income),
                  onExpensePressed: () => _showAddTransactionModal(context, ETransactionType.expense),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTransactionModal(BuildContext context, ETransactionType type, {Transaction? transactionToEdit}) {
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

  /// Builds the transactions section header with "View All" button.
  Widget _buildTransactionsHeader(BuildContext context, AppLocalizations loc, ThemeData theme) {
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
              // context.read<RouteBloc>().add(NavigateToAllTransactionsEvent(ERoute.Wallet));
              // TODO: Navigate to all transactions screen
            },
            child: Text(loc.btnViewAll),
          ),
        ],
      ),
    );
  }

  /// Builds the scrollable transactions list.
  Widget _buildTransactionsList(
    BuildContext ctx,
    AppLocalizations loc,
    ThemeData theme,
    WalletLoaded state,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(12.0),
          color: theme.colorScheme.surface,
          clipBehavior: Clip.antiAlias,
          child: state.transactions.isEmpty
              ? Center(
                  child: Text(
                  textAlign: TextAlign.center,
                  loc.dashboardNoTransactions,
                  style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.outlineVariant),
                ))
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: state.transactions.length > 5 ? 5 : state.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = state.transactions[index];
                    return Dismissible(
                      key: Key(transaction.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        final walletBloc = context.read<WalletBloc>();

                        walletBloc.add(DeleteTransactionEvent(transaction.id));

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(loc.msgTransactionDeleted),
                            action: SnackBarAction(
                              label: loc.btnUndo,
                              onPressed: () {
                                walletBloc.add(AddTransactionEvent(transaction));
                              },
                            ),
                          ),
                        );
                      },
                      child: TransactionCard(
                        transaction: transaction,
                        onTap: () {
                          _showAddTransactionModal(
                            context,
                            transaction.type,
                            transactionToEdit: transaction,
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
