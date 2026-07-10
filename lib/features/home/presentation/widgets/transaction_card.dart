import 'package:eco_wallet/features/settings/domain/entities/settings_entities.dart';
import 'package:flutter/material.dart';

import 'package:eco_wallet/features/wallet/domain/entities/transaction.dart';
import 'package:eco_wallet/l10n/app_localizations.dart';
import 'package:eco_wallet/core/enums/enums.dart';
import 'package:eco_wallet/core/utils/app_formatters.dart';
import 'package:eco_wallet/core/constants/category_data.dart';
import 'package:eco_wallet/core/presentation/widgets/sensitive_text.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.appearancePreferences,
    required this.transaction,
    required this.onTap,
    this.blackAndWhite = false,
    this.hideValue = false,
  });

  final AppearancePreferences appearancePreferences;
  final Transaction transaction;
  final VoidCallback onTap;
  final bool blackAndWhite;
  final bool hideValue;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isIncome = transaction.type == ETransactionType.income;
    double value = transaction.amountAsDouble;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: isIncome
            ? theme.colorScheme.primary.withAlpha(50)
            : blackAndWhite
                ? theme.colorScheme.outlineVariant.withAlpha(80)
                : theme.colorScheme.error.withAlpha(80),
        foregroundColor: isIncome
            ? theme.colorScheme.primary
            : blackAndWhite
                ? theme.colorScheme.outlineVariant
                : theme.colorScheme.error,
        child: Icon(transaction.type == ETransactionType.income
            ? Icons.trending_up
            : CategoryRepository.getIcon(transaction.category)),
      ),
      title: Text(transaction.name),
      subtitle: Text(CategoryRepository.getLabel(transaction.category, loc),
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (hideValue)
            SensitiveText(
              text: AppFormatters.formatCurrencyWithPreference(
                  value, appearancePreferences.currencyFormat, loc.localeName),
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: isIncome ? theme.colorScheme.primary : theme.colorScheme.onSurface),
            )
          else
            Text(
                AppFormatters.formatCurrencyWithPreference(value, appearancePreferences.currencyFormat, loc.localeName),
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: isIncome ? theme.colorScheme.primary : theme.colorScheme.onSurface)),
          Text(
            AppFormatters.formatDateShort(transaction.date, loc.localeName),
            style: theme.textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}
