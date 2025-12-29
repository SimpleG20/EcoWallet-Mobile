import 'package:eco_wallet/features/settings/presentation/widgets/settings_section_list.dart';
import 'package:eco_wallet/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:eco_wallet/features/settings/presentation/widgets/settings_sub_page_header.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class BudgetInfoPage extends StatefulWidget {
  const BudgetInfoPage({super.key});

  @override
  State<BudgetInfoPage> createState() => _BudgetInfoPageState();
}

class _BudgetInfoPageState extends State<BudgetInfoPage> {
  final _initialDayController = TextEditingController();
  final _expensesMonthlyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Column(
      children: [
        SettingsSubPageHeader(
          title: loc.lbBudgetInfo,
          subtitle: loc.budgetInfoSubTitle,
          complement: null,
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
              clipBehavior: Clip.hardEdge,
              child: _buildBudgetOptions(context, theme, loc)),
        ),
      ],
    );
  }

  Widget _buildBudgetOptions(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    final sections = [_buildMonthlySection(context, theme, loc)];
    return SettingsSectionList(sections: sections, theme: theme);
  }

  Widget _buildMonthlySection(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        SettingsSectionTitle(title: "Monthly"),
        const SizedBox(height: 16),
        _buildMonthlyInitialDay(context, theme, loc),
        const SizedBox(height: 16),
        _buildMonthlyExpensesLimit(context, theme, loc),
      ],
    );
  }

  Widget _buildMonthlyExpensesLimit(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Monthly Expenses Limit",
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _expensesMonthlyController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter your monthly limit",
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildMonthlyInitialDay(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Initial Day of the Month",
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _initialDayController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter the initial day (1-31)",
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
