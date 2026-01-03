import 'package:eco_wallet/features/settings/domain/entities/notification_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/settings_bloc.dart';
import '../widgets/settings_widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../injection_container.dart' as di;
import '../../../../core/services/notification_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _formKey = GlobalKey<FormState>();

  NotificationPreferences _currentPreferences = NotificationPreferences();
  NotificationPreferences _initialPreferences = NotificationPreferences();

  bool _pendingChanges = false;

  Future<void> _selectTime(BuildContext context, TimeOfDay initialTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null && picked != _currentPreferences.reminderTime) {
      setState(() {
        _currentPreferences = _currentPreferences.copyWith(reminderTime: picked);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final settingsState = context.read<SettingsBloc>().state;
    if (settingsState is! SettingsLoadedState) return;

    final settings = settingsState.preferences.notificationPreferences;
    _currentPreferences = settings.copyWith();
    _initialPreferences = settings.copyWith();
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
      value: _currentPreferences.dailyReminderEnabled,
      onChanged: (bool newValue) {
        setState(() {
          _currentPreferences = _currentPreferences.copyWith(dailyReminderEnabled: newValue);
          _pendingChanges = _currentPreferences != _initialPreferences;
        });
      },
      trailing: IconButton(
        icon: const Icon(Icons.access_time),
        onPressed: _currentPreferences.dailyReminderEnabled
            ? () => _selectTime(context, _currentPreferences.reminderTime)
            : null,
        tooltip: _currentPreferences.reminderTime.format(context),
      ),
    );
  }

  Widget _buildBillsReminderOption(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return NotificationOptionRow(
      icon: Icons.receipt_long_outlined,
      title: loc.lbBillsReminder,
      description: loc.billsReminderDescription,
      value: _currentPreferences.billsReminderEnabled,
      onChanged: (bool newValue) {
        setState(() {
          _currentPreferences = _currentPreferences.copyWith(billsReminderEnabled: newValue);
          _pendingChanges = _currentPreferences != _initialPreferences;
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
      value: _currentPreferences.monthlyReportEnabled,
      onChanged: (bool newValue) {
        setState(() {
          _currentPreferences = _currentPreferences.copyWith(monthlyReportEnabled: newValue);
          _pendingChanges = _currentPreferences != _initialPreferences;
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
              value: _currentPreferences.quietHoursEnabled,
              onChanged: (bool newValue) {
                setState(() {
                  _currentPreferences = _currentPreferences.copyWith(quietHoursEnabled: newValue);
                  _pendingChanges = _currentPreferences != _initialPreferences;
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
                onPressed: () => _selectTime(context, _currentPreferences.quietHoursStart),
                child: Text(_currentPreferences.quietHoursStart.format(context)),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(loc.lbTo, style: theme.textTheme.bodyMedium)),
              TextButton(
                onPressed: () => _selectTime(context, _currentPreferences.quietHoursEnd),
                child: Text(_currentPreferences.quietHoursEnd.format(context)),
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
        onPressed: () async {
          final notificationService = di.sl<NotificationService>();
          await notificationService.requestPermissions();
          await notificationService.showTestNotification(loc.ntfTestTitle, loc.ntfTestBody);
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
    if (_pendingChanges == false) return;
    if (!_formKey.currentState!.validate()) return;

    final bloc = context.read<SettingsBloc>();
    final currentState = bloc.state;

    if (currentState is! SettingsLoadedState) return;

    final updatedPreferences = currentState.preferences.copyWith(
      notificationPreferences: _currentPreferences,
    );

    _initialPreferences = _currentPreferences.copyWith();
    _pendingChanges = false;

    bloc.add(UpdateUserPreferencesEvent(userPreferences: updatedPreferences));
  }
}
