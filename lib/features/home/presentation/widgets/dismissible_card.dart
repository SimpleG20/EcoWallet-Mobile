import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../wallet/domain/entities/transaction.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import 'transaction_card.dart';

class DismissibleTransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  const DismissibleTransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

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
        onTap: onTap ?? () {},
      ),
    );
  }
}
