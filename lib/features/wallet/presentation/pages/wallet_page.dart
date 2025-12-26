import 'package:flutter/material.dart';
import 'package:eco_wallet/l10n/app_localizations.dart';
import 'package:eco_wallet/features/wallet/presentation/widgets/transaction_card.dart';

import '../../domain/entities/transaction.dart';
import '../widgets/balance_card.dart';
import '../widgets/wallet_action_buttons.dart';
import '../widgets/wallet_header.dart';

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

    // TODO: Replace with data from repository/use case
    final transactions = _getMockTransactions();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          _buildHeaderSection(context, loc, theme),
          const SizedBox(height: 8),
          _buildTransactionsHeader(loc, theme),
          const SizedBox(height: 8),
          _buildTransactionsList(loc, theme, transactions),
          const SizedBox(height: 8),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(loc, theme),
    );
  }

  /// Builds the header section with balance card and action buttons.
  Widget _buildHeaderSection(
    BuildContext context,
    AppLocalizations loc,
    ThemeData theme,
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
                  totalBalance: 5250,
                  monthlySavings: 1200,
                  locale: loc.localeName,
                  balanceLabel: loc.dashboardTotalBalance,
                  savingsLabel: loc.dashboardMonthlySavings,
                ),
                const SizedBox(height: 8),
                WalletActionButtons(
                  incomeLabel: loc.dashboardIncome,
                  expenseLabel: loc.dashboardExpense,
                  onIncomePressed: () {
                    // TODO: Navigate to add income screen
                  },
                  onExpensePressed: () {
                    // TODO: Navigate to add expense screen
                  },
                ),
              ],
            ),
          ),
        ],
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
    List<Transaction> transactions,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(12.0),
          color: theme.colorScheme.surface,
          clipBehavior: Clip.antiAlias,
          child: transactions.isEmpty
              ? Center(
                  child: Text(
                  textAlign: TextAlign.center,
                  loc.dashboardNoTransactions,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: theme.colorScheme.outlineVariant),
                ))
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: transactions.length > 5 ? 5 : transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return TransactionCard(
                      transaction: transaction,
                      onTap: () {
                        // TODO: Navigate to transaction details
                      },
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
        _navigationBarItem(currentIndex, 0, theme, loc, Icons.home_outlined),
        _navigationBarItem(
            currentIndex, 1, theme, loc, Icons.account_balance_wallet_outlined),
        _navigationBarItem(
            currentIndex, 2, theme, loc, Icons.bar_chart_outlined),
        _navigationBarItem(
            currentIndex, 3, theme, loc, Icons.settings_outlined),
      ],
    );
  }

  BottomNavigationBarItem _navigationBarItem(int currentIndex, int index,
      ThemeData theme, AppLocalizations loc, IconData icon) {
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
      label: loc.btnWallet,
    );
  }

  /// Returns mock transactions for development/testing.
  /// TODO: Remove when integrating with actual data source.
  List<Transaction> _getMockTransactions() {
    return [
      Transaction(
        id: '1',
        name: 'Grocery Shopping',
        amount: 150,
        cents: 75,
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: ETransactionType.expense,
        category: 'Food',
      ),
      Transaction(
        id: '2',
        name: 'Salary',
        amount: 3000,
        cents: 0,
        date: DateTime.now().subtract(const Duration(days: 3)),
        type: ETransactionType.income,
        category: 'Salary',
      ),
      // Transaction(
      //   id: '3',
      //   name: 'Movie Night',
      //   amount: 45,
      //   cents: 50,
      //   date: DateTime.now().subtract(const Duration(days: 5)),
      //   type: ETransactionType.expense,
      //   category: 'Entertainment',
      // ),
      // Transaction(
      //   id: '4',
      //   name: 'Electricity Bill',
      //   amount: 120,
      //   cents: 20,
      //   date: DateTime.now().subtract(const Duration(days: 7)),
      //   type: ETransactionType.expense,
      //   category: 'Utilities',
      // ),
      // Transaction(
      //   id: '5',
      //   name: 'Freelance Project',
      //   amount: 800,
      //   cents: 0,
      //   date: DateTime.now().subtract(const Duration(days: 10)),
      //   type: ETransactionType.income,
      //   category: 'Work',
      // ),
      // Transaction(
      //   id: '6',
      //   name: 'Dinner Out',
      //   amount: 60,
      //   cents: 30,
      //   date: DateTime.now().subtract(const Duration(days: 12)),
      //   type: ETransactionType.expense,
      //   category: 'Food',
      // ),
      // Transaction(
      //   id: '7',
      //   name: 'Gas Station',
      //   amount: 80,
      //   cents: 0,
      //   date: DateTime.now().subtract(const Duration(days: 14)),
      //   type: ETransactionType.expense,
      //   category: 'Transport',
      // ),
      // Transaction(
      //   id: '8',
      //   name: 'Netflix Subscription',
      //   amount: 39,
      //   cents: 90,
      //   date: DateTime.now().subtract(const Duration(days: 15)),
      //   type: ETransactionType.expense,
      //   category: 'Entertainment',
      // ),
      // Transaction(
      //   id: '9',
      //   name: 'Bonus',
      //   amount: 500,
      //   cents: 0,
      //   date: DateTime.now().subtract(const Duration(days: 17)),
      //   type: ETransactionType.income,
      //   category: 'Salary',
      // ),
      // Transaction(
      //   id: '10',
      //   name: 'Supermarket',
      //   amount: 200,
      //   cents: 50,
      //   date: DateTime.now().subtract(const Duration(days: 20)),
      //   type: ETransactionType.expense,
      //   category: 'Food',
      // ),
    ];
  }
}
