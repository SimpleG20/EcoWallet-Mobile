import 'package:eco_wallet/core/presentation/widgets/any_text_field.dart';
import 'package:eco_wallet/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:eco_wallet/features/settings/presentation/widgets/settings_confirm_edition_btn.dart';
import 'package:eco_wallet/features/settings/presentation/widgets/settings_sub_page_header.dart';
import 'package:eco_wallet/features/settings/presentation/widgets/settings_card.dart';
import 'package:eco_wallet/features/settings/presentation/widgets/notification_option_row.dart';
import 'package:eco_wallet/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/notification_service.dart';
import '../widgets/settings_section_list.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/settings_section_title.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _formKey = GlobalKey<FormState>();

  final _consumptionThresholdController = TextEditingController();

  bool _dailyReminderEnabled = false;
  bool _billsReminderEnabled = false;
  bool _monthlyReportEnabled = false;
  bool _quietHoursEnabled = false;
  bool _energySavingTipsEnabled = false;
  bool _highConsumptionAlertEnabled = false;

  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 7, minute: 0);

  bool _pendingChanges = false;

  Future<void> _selectTime(BuildContext context, TimeOfDay initialTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null && picked != _reminderTime) {
      setState(() {
        initialTime = picked;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final settingsState = context.read<SettingsBloc>().state;
    if (settingsState is! SettingsLoadedState) return;

    final settings = settingsState.preferences.notificationPreferences;
    _dailyReminderEnabled = settings.dailyReminderEnabled;
    _reminderTime = settings.reminderTime;
    _billsReminderEnabled = settings.billsReminderEnabled;
    _monthlyReportEnabled = settings.monthlyReportEnabled;
    _quietHoursEnabled = settings.quietHoursEnabled;
    _quietHoursStart = settings.quietHoursStart;
    _quietHoursEnd = settings.quietHoursEnd;
    _energySavingTipsEnabled = settings.energySavingTipsEnabled;
    _highConsumptionAlertEnabled = settings.highConsumptionAlertEnabled;
    _consumptionThresholdController.text = settings.highConsumptionThreshold.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return BlocListener<SettingsBloc, BaseSettingsState>(
      listener: (context, state) async {
        if (state is PreferencesUpdatedState) {
          final settingsBloc = context.read<SettingsBloc>();
          final loc = AppLocalizations.of(context)!;
          final notificationService = di.sl<NotificationService>();
          final notifs = state.preferences.notificationPreferences;
          if (notifs.dailyReminderEnabled) {
            await notificationService.requestPermissions();
            await notificationService.scheduleDailyReminder(loc, notifs.reminderTime);
          } else {
            await notificationService.cancelDailyReminder();
          }
          settingsBloc.add(LoadSettingsEvent());
        }
      },
      child: BlocBuilder<SettingsBloc, BaseSettingsState>(
        builder: (context, state) {
          if (state is SettingsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SettingsErrorState) {
            return Center(
              child: Text(
                state.message ?? loc.errorUnknown,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            );
          }

          if (state is SettingsLoadedState) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
              ),
              body: _buildContent(context, theme, loc),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Stack(
      children: [
        Column(
          children: [
            SettingsSubPageHeader(
              title: loc.lbNotifications,
              subtitle: loc.notificationsSubTitle,
              complement: null,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Form(
                key: _formKey,
                child: SettingsCard(
                  child: _buildNotificationsOptions(context, theme, loc),
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

  Widget _buildNotificationsOptions(BuildContext context, ThemeData theme, AppLocalizations loc) {
    final sections = [
      _buildRemindersSection(context, theme, loc),
      _buildReportsSection(context, theme, loc),
      _buildDoNotDisturbSection(context, theme, loc),
      _buildEcoSection(context, theme, loc),
      _buildTestNotificationButton(context, theme, loc),
    ];
    return SettingsSectionList(sections: sections, theme: theme);
  }

  Widget _buildRemindersSection(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        SettingsSectionTitle(title: loc.sectionReminders),
        const SizedBox(height: 16),
        _buildDailyReminderOption(context, theme, loc),
        const SizedBox(height: 16),
        _buildBillsReminderOption(context, theme, loc),
      ],
    );
  }

  Widget _buildDailyReminderOption(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return NotificationOptionRow(
      icon: Icons.notifications_outlined,
      title: loc.lbDailyReminder,
      description: loc.dailyReminderDescription,
      value: _dailyReminderEnabled,
      onChanged: (bool newValue) {
        setState(() {
          _dailyReminderEnabled = newValue;
        });
      },
      trailing: IconButton(
        icon: const Icon(Icons.access_time),
        onPressed: _dailyReminderEnabled ? () => _selectTime(context, _reminderTime) : null,
        tooltip: _reminderTime.format(context),
      ),
    );
  }

  Widget _buildBillsReminderOption(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return NotificationOptionRow(
      icon: Icons.receipt_long_outlined,
      title: loc.lbBillsReminder,
      description: loc.billsReminderDescription,
      value: _billsReminderEnabled,
      onChanged: (bool newValue) {
        setState(() {
          _billsReminderEnabled = newValue;
        });
      },
    );
  }

  Widget _buildReportsSection(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(title: loc.sectionReports),
        const SizedBox(height: 16),
        _buildMonthlyReportOption(context, theme, loc),
      ],
    );
  }

  Widget _buildMonthlyReportOption(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return NotificationOptionRow(
      icon: Icons.calendar_month_outlined,
      title: loc.lbMonthlyReport,
      description: loc.monthlyReportDescription,
      value: _monthlyReportEnabled,
      onChanged: (bool newValue) {
        setState(() {
          _monthlyReportEnabled = newValue;
        });
      },
    );
  }

  Widget _buildDoNotDisturbSection(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.sectionDoNotDisturb,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.nightlight_outlined, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                loc.lbQuietHours,
                style: theme.textTheme.bodyLarge,
              ),
            ),
            Switch(
              value: _quietHoursEnabled,
              onChanged: (bool newValue) {
                setState(() {
                  _quietHoursEnabled = newValue;
                });
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 8),
          child: Row(
            children: [
              Expanded(child: Text(loc.lbFrom, style: theme.textTheme.bodyMedium)),
              TextButton(
                onPressed: () => _selectTime(context, _quietHoursStart),
                child: Text(_quietHoursStart.format(context)),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(loc.lbTo, style: theme.textTheme.bodyMedium)),
              TextButton(
                onPressed: () => _selectTime(context, _quietHoursEnd),
                child: Text(_quietHoursEnd.format(context)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEcoSection(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(title: loc.sectionEcoNotifications),
        const SizedBox(height: 16),
        _buildEnergySavingTipsOption(context, theme, loc),
        const SizedBox(height: 16),
        _buildHighConsumptionAlertOption(context, theme, loc)
      ],
    );
  }

  Widget _buildEnergySavingTipsOption(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return NotificationOptionRow(
      icon: Icons.energy_savings_leaf_outlined,
      title: loc.lbEnergySavingTips,
      description: loc.energySavingTipsDescription,
      value: _energySavingTipsEnabled,
      onChanged: (bool newValue) {
        setState(() {
          _energySavingTipsEnabled = newValue;
        });
      },
    );
  }

  Widget _buildHighConsumptionAlertOption(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.warning_amber_outlined, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.lbHighConsumptionAlert,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    loc.highConsumptionAlertDescription,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _highConsumptionAlertEnabled,
              onChanged: (bool newValue) {
                setState(() {
                  _highConsumptionAlertEnabled = newValue;
                });
              },
            ),
          ],
        ),
        if (_highConsumptionAlertEnabled)
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    loc.thresholdLabel(_consumptionThresholdController.text),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showModalToEditThreshold(context, theme, loc);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTestNotificationButton(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: OutlinedButton.icon(
        onPressed: () {
          // Send test notification
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.msgTestNotificationSent)),
          );
        },
        icon: const Icon(Icons.send_outlined),
        label: Text(loc.btnSendTestNotification),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    );
  }

  void _showModalToEditThreshold(BuildContext context, ThemeData theme, AppLocalizations loc) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnyTextField(
                label: loc.lbEditThreshold,
                hintText: loc.hintConsumptionThreshold,
                controller: _consumptionThresholdController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.errorEmpty;
                  }
                  final parsed = double.tryParse(value);
                  if (parsed == null || parsed <= 0) {
                    return loc.errorNumberPositive;
                  }
                  return null;
                },
                prefixIcon: const Icon(Icons.warning_amber_outlined),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(loc.btnSave),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitChanges(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final bloc = context.read<SettingsBloc>();
    final currentState = bloc.state;

    if (currentState is! SettingsLoadedState) return;

    final updatedNotificationPreferences = currentState.preferences.notificationPreferences.copyWith(
      dailyReminderEnabled: _dailyReminderEnabled,
      billsReminderEnabled: _billsReminderEnabled,
      monthlyReportEnabled: _monthlyReportEnabled,
      reminderTime: _reminderTime,
      energySavingTipsEnabled: _energySavingTipsEnabled,
      highConsumptionAlertEnabled: _highConsumptionAlertEnabled,
    );

    final updatedPreferences = currentState.preferences.copyWith(
      notificationPreferences: updatedNotificationPreferences,
    );

    bloc.add(UpdateUserPreferencesEvent(userPreferences: updatedPreferences));
  }
}
