import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eco_wallet/core/utils/app_formatters.dart';
import 'package:eco_wallet/core/utils/app_validators.dart';

import '../bloc/settings_bloc.dart';
import '../widgets/settings_widgets.dart';
import '../../domain/entities/budget_preferences.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/presentation/widgets/core_widgets.dart';

class BudgetInfoPage extends StatefulWidget {
  const BudgetInfoPage({super.key});

  @override
  State<BudgetInfoPage> createState() => _BudgetInfoPageState();
}

class _BudgetInfoPageState extends State<BudgetInfoPage> {
  final _formKey = GlobalKey<FormState>();

  final _expensesMonthlyController = TextEditingController();
  final _weeklyBudgetLimitAlertController = TextEditingController();
  final _weeklyBudgetLimitController = TextEditingController();
  final _dailyBudgetLimitAlertController = TextEditingController();
  final _dailyBudgetLimitController = TextEditingController();

  BudgetPreferences _currentPreferences = BudgetPreferences();
  BudgetPreferences _initialPreferences = BudgetPreferences();

  bool _pendingChanges = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentState = context.read<SettingsBloc>().state;
    if (currentState is SettingsLoadedState) {
      final settings = currentState.preferences.budgetPreferences;

      _initialPreferences = settings.copyWith();
      _currentPreferences = settings.copyWith();

      _dailyBudgetLimitController.text =
          settings.dailyBudgetLimit?.toString() ?? '';
      _weeklyBudgetLimitController.text =
          settings.weeklyBudgetLimit?.toString() ?? '';
      _expensesMonthlyController.text =
          settings.monthlyExpenseLimit?.toString() ?? '';
      _dailyBudgetLimitAlertController.text =
          settings.dailyAlertPercentage?.toString() ?? '';
      _weeklyBudgetLimitAlertController.text =
          settings.weeklyAlertPercentage?.toString() ?? '';
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
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.error),
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

  Widget _buildBudgetOptions(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    final sections = [
      _buildMonthlySection(context, theme, loc),
      _buildWeeklySection(context, theme, loc),
      _buildDailySection(context, theme, loc),
    ];
    return SettingsSectionList(sections: sections, theme: theme);
  }

  Widget _buildMonthlySection(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        SettingsSectionTitle(title: loc.sectionMonthly),
        const SizedBox(height: 16),
        _buildMonthlyInitialDay(context, theme, loc),
        const SizedBox(height: 16),

        // Expenses Limit
        AnyTextField(
            hintText: _expensesMonthlyController.text.isEmpty
                ? '000.00'
                : _expensesMonthlyController.text,
            controller: _expensesMonthlyController,
            keyboardType: TextInputType.number,
            verticalSpacing: false,
            label: loc.lbExpensesLimit,
            subtitle: loc.expensesLimitDescription,
            outsidePrefixIcon: Icon(Icons.attach_money_outlined,
                color: theme.colorScheme.onSurfaceVariant),
            inputFormatters: [
              CurrencyInputFormatter(locale: loc.localeName),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }
              return AppValidators.validateAmount(loc, value);
            },
            onEditingComplete: () => setState(() {
                  _currentPreferences = _currentPreferences.copyWith(
                    monthlyExpenseLimit: AppFormatters.getCurrencyValue(
                        _expensesMonthlyController.text, loc.localeName),
                  );
                  _pendingChanges = _currentPreferences != _initialPreferences;
                }))
      ],
    );
  }

  Widget _buildMonthlyInitialDay(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    const icon = Icons.calendar_today;
    final label = loc.lbInitialDayOfMonth;
    final items = List<String>.generate(31, (index) => (index + 1).toString())
        .map((day) => DropdownMenuItem<String>(value: day, child: Text(day)))
        .toList();
    return DropdownRow(
      icon: icon,
      label: label,
      value: _currentPreferences.monthStartDay.toString(),
      items: items,
      onChanged: (value) => setState(() {
        _currentPreferences = _currentPreferences.copyWith(
          monthStartDay:
              int.tryParse(value!) ?? _currentPreferences.monthStartDay,
        );
        _pendingChanges = _currentPreferences != _initialPreferences;
      }),
      theme: theme,
    );
  }

  Widget _buildWeeklySection(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(title: loc.sectionWeekly),
        const SizedBox(height: 16),
        AnyTextField(
          hintText: loc.lbBudgetLimit,
          controller: _weeklyBudgetLimitController,
          keyboardType: TextInputType.number,
          outsidePrefixIcon: Icon(Icons.attach_money_outlined,
              color: theme.colorScheme.onSurfaceVariant),
          inputFormatters: [
            CurrencyInputFormatter(locale: loc.localeName),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }
            return AppValidators.validateAmount(loc, value);
          },
          onEditingComplete: () => setState(() {
            final value = AppFormatters.getCurrencyValue(
                _weeklyBudgetLimitController.text, loc.localeName);
            if (value > 0) {
              _currentPreferences =
                  _currentPreferences.copyWith(weeklyBudgetLimit: value);
            } else {
              _currentPreferences =
                  _currentPreferences.copyWith(weeklyBudgetLimit: null);
            }
            _pendingChanges = _currentPreferences != _initialPreferences;
          }),
        ),
        if (_currentPreferences.weeklyBudgetLimit != null &&
            _currentPreferences.weeklyBudgetLimit! > 0) ...[
          const SizedBox(height: 16),
          PercentageTextField(
            verticalSpacing: false,
            controller: _weeklyBudgetLimitAlertController,
            outsidePrefixIcon: Icon(Icons.notifications_active_outlined,
                color: theme.colorScheme.onSurfaceVariant),
            label: loc.lbLimitAlert,
            subtitle: loc.limitAlertDescription,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }
              return AppValidators.isValidPercentage(loc, value);
            },
            onEditingComplete: () => setState(() {
              final value =
                  int.tryParse(_weeklyBudgetLimitAlertController.text);
              if (value != null && value > 0) {
                _currentPreferences = _currentPreferences.copyWith(
                  weeklyAlertPercentage: value,
                );
              } else {
                _currentPreferences = _currentPreferences.copyWith(
                  weeklyAlertPercentage: null,
                );
              }
              _pendingChanges = _currentPreferences != _initialPreferences;
            }),
          ),
        ]
      ],
    );
  }

  Widget _buildDailySection(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(title: loc.sectionDaily),
        const SizedBox(height: 16),
        AnyTextField(
          hintText: loc.lbBudgetLimit,
          controller: _dailyBudgetLimitController,
          keyboardType: TextInputType.number,
          outsidePrefixIcon: Icon(Icons.attach_money_outlined,
              color: theme.colorScheme.onSurfaceVariant),
          inputFormatters: [
            CurrencyInputFormatter(locale: loc.localeName),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }
            return AppValidators.validateAmount(loc, value);
          },
          onEditingComplete: () => setState(() {
            final value = AppFormatters.getCurrencyValue(
                _dailyBudgetLimitController.text, loc.localeName);

            if (value > 0) {
              _currentPreferences =
                  _currentPreferences.copyWith(dailyBudgetLimit: value);
            } else {
              _currentPreferences =
                  _currentPreferences.copyWith(dailyBudgetLimit: null);
            }
            _pendingChanges = _currentPreferences != _initialPreferences;
          }),
        ),
        if (_currentPreferences.dailyBudgetLimit != null &&
            _currentPreferences.dailyBudgetLimit! > 0) ...[
          const SizedBox(height: 16),
          PercentageTextField(
            verticalSpacing: false,
            controller: _dailyBudgetLimitAlertController,
            outsidePrefixIcon: Icon(Icons.notifications_active_outlined,
                color: theme.colorScheme.onSurfaceVariant),
            label: loc.lbLimitAlert,
            subtitle: loc.limitAlertDescription,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }
              return AppValidators.isValidPercentage(loc, value);
            },
            onEditingComplete: () => setState(() {
              final value = int.tryParse(_dailyBudgetLimitAlertController.text);

              if (value != null && value > 0) {
                _currentPreferences = _currentPreferences.copyWith(
                  dailyAlertPercentage: value,
                );
              } else {
                _currentPreferences = _currentPreferences.copyWith(
                  dailyAlertPercentage: null,
                );
              }
              _pendingChanges = _currentPreferences != _initialPreferences;
            }),
          ),
        ],
      ],
    );
  }

  void _submitChanges(BuildContext context) {
    if (_pendingChanges == false) return;
    if (!_formKey.currentState!.validate()) return;

    final bloc = context.read<SettingsBloc>();
    final settingsState = bloc.state;
    if (settingsState is! SettingsLoadedState) return;

    _pendingChanges = false;
    final newPreferences = settingsState.preferences
        .copyWith(budgetPreferences: _currentPreferences);

    bloc.add(UpdateUserPreferencesEvent(userPreferences: newPreferences));
  }
}
