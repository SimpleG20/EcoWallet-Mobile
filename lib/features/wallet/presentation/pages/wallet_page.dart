import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/l10n/app_localizations.dart';
import '/features/wallet/presentation/widgets/transaction_card.dart';
import '/features/wallet/presentation/pages/add_transaction_page.dart';

import '../bloc/wallet_bloc.dart';
import '../widgets/balance_card.dart';
import '../widgets/wallet_header.dart';
import '../widgets/wallet_action_buttons.dart';
import '../../domain/entities/transaction.dart';
import '../../../../injection_container.dart' as di;

/// Main page for the Wallet feature displaying balance, actions, and transactions.
///
/// This page follows Clean Architecture by delegating UI components to
/// specialized widgets while maintaining the overall layout structure.
class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

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
        body: BlocBuilder<WalletBloc, WalletState>(
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
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: theme.colorScheme.error),
              ));
            }

            if (state is WalletLoaded) {
              return Column(
                children: [
                  _buildHeaderSection(context, loc, theme, state),
                  const SizedBox(height: 8),
                  _buildTransactionsHeader(loc, theme),
                  const SizedBox(height: 8),
                  _buildTransactionsList(loc, theme, state),
                  const SizedBox(height: 8),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: _buildBottomNavigation(loc, theme),
      ),
    );
  }

  /// Builds the header section with balance card and action buttons.
  Widget _buildHeaderSection(
    BuildContext context,
    AppLocalizations loc,
    ThemeData theme,
    WalletLoaded state,
  ) {
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
                WalletHeader(
                  welcomeText: loc.welcome,
                  titleText: loc.appTitle,
                ),
                const SizedBox(height: 20),
                BalanceCard(
                  totalBalance: state.totalBalance,
                  monthlySavings: state.monthlySavings,
                  locale: loc.localeName,
                  balanceLabel: loc.dashboardTotalBalance,
                  savingsLabel: loc.dashboardMonthlySavings,
                ),
                const SizedBox(height: 8),
                WalletActionButtons(
                  incomeLabel: loc.lbIncome,
                  expenseLabel: loc.lbExpense,
                  onIncomePressed: () => _showAddTransactionModal(
                      context, ETransactionType.income),
                  onExpensePressed: () => _showAddTransactionModal(
                      context, ETransactionType.expense),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTransactionModal(BuildContext context, ETransactionType type,
      {Transaction? transactionToEdit}) {
    final walletBloc = context.read<WalletBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => BlocProvider.value(
        value: walletBloc,
        child: AddTransactionPage(
          transactionType: type,
          transactionToEdit: transactionToEdit,
        ),
      ),
    );
  }

  /// Builds the transactions section header with "View All" button.
  Widget _buildTransactionsHeader(AppLocalizations loc, ThemeData theme) {
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
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: theme.colorScheme.outlineVariant),
                ))
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: state.transactions.length > 5
                      ? 5
                      : state.transactions.length,
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
                        context
                            .read<WalletBloc>()
                            .add(DeleteTransactionEvent(transaction.id));

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(loc.msgTransactionDeleted),
                            action: SnackBarAction(
                              label: loc.btnUndo,
                              onPressed: () {
                                context
                                    .read<WalletBloc>()
                                    .add(AddTransactionEvent(transaction));
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

  /// Builds the bottom navigation bar.
  Widget _buildBottomNavigation(AppLocalizations loc, ThemeData theme) {
    int currentIndex = 0; // TODO: Manage current index state

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: theme.colorScheme.surface,
      selectedItemColor: theme.colorScheme.primary,
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      onTap: (index) {
        // TODO: Handle navigation
      },
      items: [
        _navigationBarItem(
            currentIndex, 0, loc.lbHome, Icons.home_outlined, theme, loc),
        _navigationBarItem(currentIndex, 1, loc.lbWallet,
            Icons.account_balance_wallet_outlined, theme, loc),
        _navigationBarItem(currentIndex, 2, loc.lbAnalytics,
            Icons.bar_chart_outlined, theme, loc),
        _navigationBarItem(currentIndex, 3, loc.lbSettings,
            Icons.settings_outlined, theme, loc),
      ],
    );
  }

  BottomNavigationBarItem _navigationBarItem(int currentIndex, int index,
      String label, IconData icon, ThemeData theme, AppLocalizations loc) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: currentIndex == index
              ? theme.colorScheme.primary
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: currentIndex == index
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.outlineVariant,
        ),
      ),
      label: label,
    );
  }
}
