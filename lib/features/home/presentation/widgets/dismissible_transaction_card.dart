import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eco_wallet/l10n/app_localizations.dart';
import 'package:eco_wallet/features/settings/domain/entities/settings_entities.dart';
import 'package:eco_wallet/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:eco_wallet/features/wallet/domain/entities/transaction.dart';
import 'package:eco_wallet/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:eco_wallet/features/home/presentation/widgets/transaction_card.dart';

class DismissibleTransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final bool hideValue;
  const DismissibleTransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
    this.hideValue = false,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    // Reactive and type-safe access to appearance preferences
    final appearancePreferences = context.select((SettingsBloc bloc) {
      final state = bloc.state;
      if (state is SettingsLoadedState) {
        return state.preferences.appearancePreferences;
      }
      return const AppearancePreferences();
    });

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
        final settingsBloc = context.read<SettingsBloc>().state;

        if (settingsBloc is! SettingsLoadedState) {
          return;
        }

        walletBloc.add(DeleteTransactionEvent(transaction.id));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.msgTransactionDeleted),
            action: SnackBarAction(
              label: loc.btnUndo,
              onPressed: () {
                walletBloc.add(AddTransactionEvent(
                  settingsBloc.preferences.budgetPreferences.monthStartDay,
                  transaction,
                  budgetPreferences: settingsBloc.preferences.budgetPreferences,
                ));
              },
            ),
          ),
        );
      },
      child: TransactionCard(
        appearancePreferences: appearancePreferences,
        transaction: transaction,
        onTap: onTap ?? () {},
        hideValue: hideValue,
      ),
    );
  }
}
