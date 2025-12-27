import 'package:eco_wallet/core/utils/app_formatters.dart';
import 'package:eco_wallet/features/home/presentation/widgets/transaction_card.dart';
import 'package:eco_wallet/features/wallet/data/datasources/mock_transactions.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/transaction.dart';
import '/l10n/app_localizations.dart';

/// Main page for the Wallet feature displaying balance, actions, and transactions.
///
/// This page follows Clean Architecture by delegating UI components to
/// specialized widgets while maintaining the overall layout structure.
class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final List<String> _filters = ["Income", "Expense", "Last 7 days"];
  bool _showFilters = false;
  List<String> _activeFilters = [];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final transactions = kMockTransactions;

    return Scaffold(
      backgroundColor: theme.colorScheme.outline,
      appBar: AppBar(),
      body: Column(
        children: [
          _buildHeader(context, loc, theme),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0.0),
              child: _buildTransactionsList(theme, loc, transactions),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  Widget _buildHeader(
      BuildContext context, AppLocalizations loc, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loc.lbAllTransactions,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
                icon: const Icon(Icons.filter_list),
              )
            ],
          ),
          const SizedBox(height: 8),
          _buildSearchBar(theme, loc)
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme, AppLocalizations loc) {
    return Column(
      children: [
        TextField(
          cursorColor: theme.colorScheme.onSurface,
          decoration: InputDecoration(
            hintText: loc.searchTransactions,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withAlpha(150),
            ),
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (_showFilters) ...[const SizedBox(height: 8), _buildFilterSection()],
      ],
    );
  }

  SizedBox _buildFilterSection() {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Chip(
                    label: Text(_filters[index]),
                    onDeleted: () {
                      setState(() {
                        _filters.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(
      ThemeData theme, AppLocalizations loc, List<Transaction> transactions) {
    final groups = _groupTransactionsByDate(transactions);
    final bottomPadding = 48.0 + MediaQuery.of(context).padding.bottom;

    return ListView.builder(
      padding: EdgeInsets.only(bottom: bottomPadding),
      itemCount: groups.length,
      itemBuilder: (ctx, index) {
        final group = groups[index];
        return _buildGroup(group.date, group.transactions);
      },
    );
  }

  List<TransactionGroup> _groupTransactionsByDate(
      List<Transaction> transactions) {
    Map<String, List<Transaction>> groupedMap = {};

    for (var transaction in transactions) {
      String dateKey = AppFormatters.dateOnlyFormatter.format(transaction.date);
      if (!groupedMap.containsKey(dateKey)) {
        groupedMap[dateKey] = [];
      }
      groupedMap[dateKey]!.add(transaction);
    }

    List<TransactionGroup> groups = [];
    groupedMap.forEach((dateStr, txns) {
      DateTime date = AppFormatters.dateOnlyFormatter.parse(dateStr);
      groups.add(TransactionGroup(date: date, transactions: txns));
    });

    groups.sort((a, b) => b.date.compareTo(a.date));

    return groups;
  }

  Widget _buildGroup(DateTime date, List<Transaction> transactions) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppFormatters.weekdayDateFormatter.format(date),
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            children: [
              ...transactions.map(
                (transaction) {
                  return TransactionCard(
                      transaction: transaction,
                      onTap: () {},
                      blackAndWhite: true);
                },
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class TransactionGroup {
  final DateTime date;
  final List<Transaction> transactions;

  TransactionGroup({required this.date, required this.transactions});
}
