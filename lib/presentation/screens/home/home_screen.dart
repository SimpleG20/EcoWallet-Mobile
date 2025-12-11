import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecowallet/core/utils/currency_formatter.dart';
import 'package:ecowallet/core/utils/date_formatter.dart';
import 'package:ecowallet/domain/entities/transaction.dart';
import 'package:ecowallet/presentation/blocs/transaction/transaction_bloc.dart';
import 'package:ecowallet/presentation/blocs/transaction/transaction_event.dart';
import 'package:ecowallet/presentation/blocs/transaction/transaction_state.dart';
import 'package:ecowallet/presentation/blocs/theme/theme_bloc.dart';
import 'package:ecowallet/presentation/screens/add_transaction/add_transaction_screen.dart';

/// Home screen displaying transactions and balance
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(const LoadTransactions());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('EcoWallet'),
          actions: [
            IconButton(
              icon: Icon(
                context.watch<ThemeBloc>().state.isDark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: () =>
                  context.read<ThemeBloc>().add(const ToggleTheme()),
            ),
          ],
        ),
        body: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state.status == TransactionStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == TransactionStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage ?? 'An error occurred',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context
                          .read<TransactionBloc>()
                          .add(const LoadTransactions()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TransactionBloc>().add(const LoadTransactions());
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildBalanceCard(context, state),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Recent Transactions',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  state.transactions.isEmpty
                      ? SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No transactions yet',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap + to add your first transaction',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                                _buildTransactionItem(context, state.transactions[index]),
                            childCount: state.transactions.length,
                          ),
                        ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const AddTransactionScreen(),
              ),
            );
            if (context.mounted) {
              context.read<TransactionBloc>().add(const LoadTransactions());
            }
          },
          child: const Icon(Icons.add),
        ),
      );

  Widget _buildBalanceCard(BuildContext context, TransactionState state) =>
      Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Balance',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              CurrencyFormatter.format(state.balance),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Transactions',
                    state.transactions.length.toString(),
                    Icons.receipt_long,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'This Month',
                    state.currentMonthTransactionsCount.toString(),
                    Icons.calendar_today,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  Widget _buildTransactionItem(BuildContext context, Transaction transaction) {
    final isIncome = transaction.type == TransactionType.income;
    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Transaction'),
            content: const Text(
              'Are you sure you want to delete this transaction?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        if (result == true && context.mounted) {
          context
              .read<TransactionBloc>()
              .add(DeleteTransactionEvent(transaction.id));
        }
        return false;
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: isIncome
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),
          title: Text(
            transaction.description,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(transaction.category),
              Text(
                DateFormatter.getRelativeTime(transaction.date),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          trailing: Text(
            '${isIncome ? '+' : '-'}${CurrencyFormatter.format(transaction.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
