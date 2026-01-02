import 'package:eco_wallet/core/utils/app_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eco_wallet/core/utils/app_formatters.dart';

import '../../../../core/presentation/widgets/core_widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/settings_widgets.dart';

class BudgetInfoPage extends StatefulWidget {
  const BudgetInfoPage({super.key});

  @override
  State<BudgetInfoPage> createState() => _BudgetInfoPageState();
}

class _BudgetInfoPageState extends State<BudgetInfoPage> {
  int _monthStartDay = 1;
  final _formKey = GlobalKey<FormState>();

  final _expensesMonthlyController = TextEditingController();
  final _weeklyBudgetLimitAlertController = TextEditingController();
  final _weeklyBudgetLimitController = TextEditingController();
  final _dailyBudgetLimitAlertController = TextEditingController();
  final _dailyBudgetLimitController = TextEditingController();

  bool _pendingChanges = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentState = context.read<SettingsBloc>().state;
    if (currentState is SettingsLoadedState) {
      final settings = currentState.preferences.budgetPreferences;

      _monthStartDay = settings.monthStartDay;
      _dailyBudgetLimitController.text = settings.dailyBudgetLimit?.toString() ?? '';
      _weeklyBudgetLimitController.text = settings.weeklyBudgetLimit?.toString() ?? '';
      _expensesMonthlyController.text = settings.monthlyExpenseLimit?.toString() ?? '';
      _dailyBudgetLimitAlertController.text = settings.dailyAlertPercentage?.toString() ?? '';
      _weeklyBudgetLimitAlertController.text = settings.weeklyAlertPercentage?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _expensesMonthlyController.dispose();
    _dailyBudgetLimitController.dispose();
    _weeklyBudgetLimitController.dispose();
    _dailyBudgetLimitAlertController.dispose();
    _weeklyBudgetLimitAlertController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<SettingsBloc, BaseSettingsState>(
        builder: (context, state) {
          if (state is SettingsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SettingsErrorState) {
            return Center(
              child: Text(
                state.message ?? loc.errorUnknown,
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error),
              ),
            );
          }

          if (state is SettingsLoadedState) {
            return Stack(
              children: [
                Column(
                  children: [
                    SettingsSubPageHeader(
                      title: loc.lbBudgetInfo,
                      subtitle: loc.budgetInfoSubTitle,
                      complement: null,
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: SettingsCard(
                        child: Form(
                          key: _formKey,
                          child: _buildBudgetOptions(context, theme, loc),
                        ),
                      ),
                    ),
                  ],
                ),
                SettingsConfirmEditionBtn(
                  onPressed: (ctx) => _submitChanges(ctx),
                  pendingChanges: _pendingChanges,
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
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
    final items = List<String>.generate(31, (index) => (index + 1).toString())
        .map((day) => DropdownMenuItem<String>(value: day, child: Text(day)))
        .toList();
    return DropdownRow(
      icon: icon,
      label: label,
      value: _monthStartDay.toString(),
      items: items,
      onChanged: (value) => setState(() {
        var newValue = int.tryParse(value!) ?? _monthStartDay;
        _monthStartDay = newValue;
      }),
      theme: theme,
    );
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
              TextFormField(
                controller: _expensesMonthlyController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  CurrencyInputFormatter(locale: loc.localeName),
                ],
                decoration: InputDecoration(
                  hintText: loc.lbExpensesLimit,
                  prefixIcon: Icon(Icons.attach_money, color: theme.colorScheme.onSurfaceVariant),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  final number = double.tryParse(value);
                  if (number == null || number < 0) {
                    return loc.errorAmountInvalid;
                  }
                  return null;
                },
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
            decoration: InputDecoration(hintText: '0%'),
            controller: controller,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }
              return AppValidators.isValidPercentage(loc, value);
            },
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
              hintText: loc.lbBudgetLimit,
            ),
          ),
        ),
      ],
    );
  }

  void _submitChanges(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final bloc = context.read<SettingsBloc>();
    final settingsState = bloc.state;
    if (settingsState is! SettingsLoadedState) return;

    final dailyLimit = double.tryParse(_dailyBudgetLimitController.text);
    final weeklyLimit = double.tryParse(_weeklyBudgetLimitController.text);
    final monthlyExpensesLimit = double.tryParse(_expensesMonthlyController.text);
    final dailyAlertPercentage = int.tryParse(_dailyBudgetLimitAlertController.text);
    final weeklyAlertPercentage = int.tryParse(_weeklyBudgetLimitAlertController.text);

    final newPreferences = settingsState.preferences.copyWith(
      budgetPreferences: settingsState.preferences.budgetPreferences.copyWith(
        dailyBudgetLimit: dailyLimit,
        weeklyBudgetLimit: weeklyLimit,
        monthlyExpenseLimit: monthlyExpensesLimit,
        dailyAlertPercentage: dailyAlertPercentage,
        weeklyAlertPercentage: weeklyAlertPercentage,
      ),
    );

    bloc.add(UpdateUserPreferencesEvent(userPreferences: newPreferences));
  }
}
