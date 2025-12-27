import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/l10n/app_localizations.dart';
import '../bloc/transactions_history_bloc.dart';
import '../bloc/transactions_history_event.dart';
import '../bloc/transactions_history_state.dart';
import '../widgets/transaction_filter_modal.dart';
import '../widgets/transaction_group_card.dart';
import '../../domain/entities/transaction_group.dart';
import '../../domain/entities/transactions_filter.dart';
import '../../../wallet/domain/entities/transaction.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/presentation/widgets/page_header.dart';
import '../../../../injection_container.dart' as di;

/// Main page for the Wallet feature displaying balance, actions, and transactions.
///
/// This page follows Clean Architecture by delegating UI components to
/// specialized widgets while maintaining the overall layout structure.
class TransactionWalletPage extends StatefulWidget {
  const TransactionWalletPage({super.key});

  @override
  State<TransactionWalletPage> createState() => _TransactionWalletPageState();
}

class _TransactionWalletPageState extends State<TransactionWalletPage> {
  bool _showFilters = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) =>
          di.sl<TransactionsHistoryBloc>()..add(LoadTransactionsHistoryEvent()),
      child: Scaffold(
        backgroundColor: theme.colorScheme.outline,
        body:
            BlocBuilder<TransactionsHistoryBloc, BaseTransactionsHistoryState>(
          builder: (context, state) {
            // Loading
            if (state is TransactionsHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Error
            if (state is TransactionsHistoryError) {
              return Center(
                  child: Text(
                state.message,
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: theme.colorScheme.error),
              ));
            }
            if (state is TransactionsHistoryLoaded) {
              return _buildBody(context, loc, theme, state);
            }

            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {},
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations loc, ThemeData theme,
      TransactionsHistoryLoaded state) {
    return Column(
      children: [
        PageHeader(
          title: loc.lbAllTransactions,
          actions: _buildActions(theme, state),
          subSection: _buildSearchBar(context, theme, loc, state),
        ),
        // _buildSearchBar(context, theme, loc, state),
        _buildTransactionsList(theme, loc, state.visibleTransactions),
      ],
    );
  }

  List<Widget> _buildActions(ThemeData theme, TransactionsHistoryLoaded state) {
    return [
      IconButton(
        onPressed: () {
          setState(() {
            _showFilters = !_showFilters;
          });
        },
        icon: Badge(
          isLabelVisible: !_showFilters && state.filter.isEmpty == false,
          child: Icon(
            Icons.filter_list,
            color: _showFilters
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    ];
  }

  Widget _buildSearchBar(BuildContext context, ThemeData theme,
      AppLocalizations loc, TransactionsHistoryLoaded state) {
    return Column(
      children: [
        TextField(
          onSubmitted: (value) => {
            context
                .read<TransactionsHistoryBloc>()
                .add(SearchQueryHistoryEvent(value))
          },
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
        if (_showFilters) ...[
          const SizedBox(height: 8),
          _buildFilterSection(context, theme, loc, state)
        ],
      ],
    );
  }

  SizedBox _buildFilterSection(BuildContext context, ThemeData theme,
      AppLocalizations loc, TransactionsHistoryLoaded state) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openFilterModal(context, state),
          ),
          Expanded(
            child: state.filter.isEmpty
                ? TextButton(
                    onPressed: () => _openFilterModal(context, state),
                    style: TextButton.styleFrom(
                        foregroundColor:
                            theme.colorScheme.onSurfaceVariant.withAlpha(150),
                        alignment: Alignment.centerLeft),
                    child: Text(
                      loc.addFilters,
                      style: theme.textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.filter.length,
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: theme.colorScheme.primaryContainer,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            state.filter.getFilters(loc)[index],
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (!state.filter.isEmpty)
            TextButton(
              child: Text(loc.btnClear),
              onPressed: () {
                context
                    .read<TransactionsHistoryBloc>()
                    .add(UpdateFiltersEvent(TransactionFilter.empty()));
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(
      ThemeData theme, AppLocalizations loc, List<Transaction> transactions) {
    final groups = _getGroupTransactionsByDate(transactions);
    final bottomPadding = 48.0 + MediaQuery.of(context).padding.bottom;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0.0),
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<TransactionsHistoryBloc>().add(RefreshHistoryEvent());

            await Future.delayed(const Duration(seconds: 1));
          },
          child: groups.isEmpty
              ? Center(child: Text(loc.dashboardNoTransactions))
              : ListView.builder(
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  itemCount: groups.length,
                  itemBuilder: (ctx, index) {
                    final group = groups[index];
                    return TransactionGroupCard(transactionGroup: group);
                  },
                ),
        ),
      ),
    );
  }

  List<TransactionGroup> _getGroupTransactionsByDate(
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

  void _openFilterModal(BuildContext context, TransactionsHistoryLoaded state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<TransactionsHistoryBloc>(),
          child: TransactionFilterModal(
            currentFilter: state.filter,
          ),
        );
      },
    );
  }
}
