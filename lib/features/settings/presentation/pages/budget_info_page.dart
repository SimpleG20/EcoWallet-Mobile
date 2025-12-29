import 'package:flutter/material.dart';

import 'package:eco_wallet/core/presentation/widgets/dropdown_row.dart';

import '../widgets/settings_section_list.dart';
import '../widgets/settings_section_title.dart';
import '../widgets/settings_sub_page_header.dart';
import '../../../../l10n/app_localizations.dart';

class BudgetInfoPage extends StatefulWidget {
  const BudgetInfoPage({super.key});

  @override
  State<BudgetInfoPage> createState() => _BudgetInfoPageState();
}

class _BudgetInfoPageState extends State<BudgetInfoPage> {
  final _expensesMonthlyController = TextEditingController();
  final _weeklyBudgetLimitAlertController = TextEditingController();
  final _weeklyBudgetLimitController = TextEditingController();
  final _dailyBudgetLimitAlertController = TextEditingController();
  final _dailyBudgetLimitController = TextEditingController();

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

  Widget _buildBudgetOptions(BuildContext context, ThemeData theme, AppLocalizations loc) {
    final sections = [
      _buildMonthlySection(context, theme, loc),
      _buildWeeklySection(context, theme, loc),
      _buildDailySection(context, theme, loc),
    ];
    return SettingsSectionList(sections: sections, theme: theme);
  }

  Widget _buildMonthlySection(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        SettingsSectionTitle(title: loc.sectionMonthly),
        const SizedBox(height: 16),
        _buildMonthlyInitialDay(context, theme, loc),
        const SizedBox(height: 16),
        _buildMonthlyExpensesLimit(context, theme, loc),
      ],
    );
  }

  Widget _buildMonthlyInitialDay(BuildContext context, ThemeData theme, AppLocalizations loc) {
    const icon = Icons.calendar_today;
    final label = loc.lbInitialDayOfMonth;
    final value = "1";
    final items = List<String>.generate(31, (index) => (index + 1).toString())
        .map((day) => DropdownMenuItem<String>(value: day, child: Text(day)))
        .toList();
    return DropdownRow(icon: icon, label: label, value: value, items: items, onChanged: (value) {}, theme: theme);
  }

  Widget _buildMonthlyExpensesLimit(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Row(
      children: [
        Icon(Icons.attach_money, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.lbExpensesLimit,
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 200,
              child: Text(
                loc.expensesLimitDescription,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          ],
        ),
        const Spacer(),
        IconButton(
          icon: Icon(Icons.edit, color: theme.colorScheme.primary),
          onPressed: () => _showExpensesLimitModal(context, theme, loc),
        )
      ],
    );
  }

  _showExpensesLimitModal(BuildContext context, ThemeData theme, AppLocalizations loc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.setMonthlyExpensesLimit,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _expensesMonthlyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: loc.lbExpensesLimit,
                  prefixIcon: Icon(Icons.attach_money, color: theme.colorScheme.onSurfaceVariant),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(loc.btnSave),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeeklySection(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(title: loc.sectionWeekly),
        const SizedBox(height: 16),
        _buildBudgetLimitAlertValue(context, theme, loc, _weeklyBudgetLimitAlertController),
        const SizedBox(height: 16),
        _buildBudgetLimit(context, theme, loc, _weeklyBudgetLimitController),
      ],
    );
  }

  Widget _buildDailySection(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(title: loc.sectionDaily),
        const SizedBox(height: 16),
        _buildBudgetLimitAlertValue(context, theme, loc, _dailyBudgetLimitAlertController),
        const SizedBox(height: 16),
        _buildBudgetLimit(context, theme, loc, _dailyBudgetLimitController),
      ],
    );
  }

  Widget _buildBudgetLimitAlertValue(
      BuildContext context, ThemeData theme, AppLocalizations loc, TextEditingController controller) {
    return Row(
      children: [
        Icon(Icons.notifications_active, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.lbLimitAlert,
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 200,
              child: Text(
                loc.limitAlertDescription,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          ],
        ),
        Expanded(
          child: TextFormField(
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(8.0),
              ),
              isDense: true,
            ),
            controller: controller,
            keyboardType: TextInputType.number,
          ),
        )
      ],
    );
  }

  Widget _buildBudgetLimit(
      BuildContext context, ThemeData theme, AppLocalizations loc, TextEditingController controller) {
    return Row(
      children: [
        Icon(Icons.attach_money, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: loc.lbBudgetLimit,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
