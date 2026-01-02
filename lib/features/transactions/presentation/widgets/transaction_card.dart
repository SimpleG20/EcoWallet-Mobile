import 'package:eco_wallet/features/settings/domain/entities/settings_entities.dart';
import 'package:flutter/material.dart';

import 'package:eco_wallet/core/utils/app_formatters.dart';

import '../../../wallet/domain/entities/transaction.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/category_data.dart';
import '../../../../core/constants/transaction_type_data.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.appearance,
    required this.transaction,
    required this.onTap,
  });

  final AppearancePreferences appearance;
  final Transaction transaction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isIncome = transaction.type == ETransactionType.income;
    double value = transaction.amount + transaction.cents / 100;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor:
            isIncome ? theme.colorScheme.primary.withAlpha(50) : theme.colorScheme.outlineVariant.withAlpha(80),
        foregroundColor: isIncome ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
        child: Icon(transaction.type == ETransactionType.income
            ? Icons.trending_up
            : CategoryRepository.getIconByLabel(transaction.category, loc)),
      ),
      title: Text(transaction.name),
      subtitle: Text(transaction.category.isNotEmpty ? transaction.category : loc.lbUncategorized,
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant.withAlpha(150))),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(AppFormatters.formatCurrencyWithPreference(value, appearance.currencyFormat, loc.localeName),
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: isIncome ? theme.colorScheme.primary : theme.colorScheme.onSurface)),
          Text(
            transaction.date.year.toString(),
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withAlpha(150)),
          )
        ],
      ),
    );
  }
}
