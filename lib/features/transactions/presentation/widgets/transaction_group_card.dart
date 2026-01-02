import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'transaction_card.dart';
import '../../domain/entities/transaction_group.dart';
import '../../../settings/domain/entities/settings_entities.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../../../home/presentation/widgets/add_transaction_modal.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/utils/app_formatters.dart';

class TransactionGroupCard extends StatelessWidget {
  final TransactionGroup transactionGroup;

  const TransactionGroupCard({
    super.key,
    required this.transactionGroup,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    // Capture bloc reference early to ensure it's available in callbacks
    // even after the widget is dismissed from the tree
    final walletBloc = context.read<WalletBloc>();

    // Reactive and type-safe access to appearance preferences
    final appearancePreferences = context.select((SettingsBloc bloc) {
      final state = bloc.state;
      if (state is SettingsLoadedState) {
        return state.preferences.appearancePreferences;
      }
      return const AppearancePreferences();
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppFormatters.weekdayDateFormatter.format(transactionGroup.date),
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
              ...transactionGroup.transactions.map(
                (transaction) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Dismissible(
                      key: ValueKey(transaction.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
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
                        appearance: appearancePreferences,
                        transaction: transaction,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (ctx) {
                              return BlocProvider.value(
                                value: context.read<WalletBloc>(),
                                child: AddTransactionModal(
                                  transactionType: transaction.type,
                                  transactionToEdit: transaction,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
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
