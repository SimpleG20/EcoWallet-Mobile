import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/settings_bloc.dart';
import '../widgets/settings_section_list.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/settings_section_title.dart';
import '../widgets/settings_widgets.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _formKey = GlobalKey<FormState>();

  bool _dailyReminderEnabled = false;
  bool _billsReminderEnabled = false;
  bool _monthlyReportEnabled = false;
  bool _quietHoursEnabled = false;

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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsBloc, BaseSettingsState>(
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
    );

    final updatedPreferences = currentState.preferences.copyWith(
      notificationPreferences: updatedNotificationPreferences,
    );

    bloc.add(UpdateUserPreferencesEvent(userPreferences: updatedPreferences));
  }
}
