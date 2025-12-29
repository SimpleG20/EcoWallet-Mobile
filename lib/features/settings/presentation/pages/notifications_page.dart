import 'package:eco_wallet/features/settings/presentation/widgets/settings_sub_page_header.dart';
import 'package:eco_wallet/features/settings/presentation/widgets/settings_card.dart';
import 'package:flutter/material.dart';

import '../widgets/settings_section_list.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/settings_section_title.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _dailyReminderEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Column(
      children: [
        SettingsSubPageHeader(
          title: loc.lbNotifications,
          subtitle: loc.notificationsSubTitle,
          complement: null,
        ),
        const SizedBox(height: 24),
        Expanded(
          child: SettingsCard(
            child: _buildNotificationsOptions(context, theme, loc),
          ),
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
    return Row(
      children: [
        Icon(Icons.notifications_outlined, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.lbDailyReminder,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                loc.dailyReminderDescription,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: _dailyReminderEnabled, // Replace with actual state
          onChanged: (bool newValue) {
            setState(() {
              _dailyReminderEnabled = newValue;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.access_time),
          onPressed: _dailyReminderEnabled ? () => _selectTime(context) : null,
          tooltip: _reminderTime.format(context),
        ),
      ],
    );
  }

  Widget _buildBillsReminderOption(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Row(
      children: [
        Icon(Icons.receipt_long_outlined, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.lbBillsReminder,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                loc.billsReminderDescription,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: false, // Replace with actual state
          onChanged: (bool newValue) {
            // Handle toggle
          },
        ),
      ],
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
    return Row(
      children: [
        Icon(Icons.calendar_month_outlined, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.lbMonthlyReport,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                loc.monthlyReportDescription,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: false,
          onChanged: (bool newValue) {},
        ),
      ],
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
              value: false,
              onChanged: (bool newValue) {},
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 8),
          child: Row(
            children: [
              Expanded(child: Text(loc.lbFrom, style: theme.textTheme.bodyMedium)),
              TextButton(
                onPressed: () {},
                child: const Text("22:00"),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(loc.lbTo, style: theme.textTheme.bodyMedium)),
              TextButton(
                onPressed: () {},
                child: const Text("07:00"),
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
    return Row(
      children: [
        Icon(Icons.energy_savings_leaf_outlined, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.lbEnergySavingTips,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                loc.energySavingTipsDescription,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: false,
          onChanged: (bool newValue) {},
        ),
      ],
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
              value: false,
              onChanged: (bool newValue) {},
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  loc.thresholdLabel("500"),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Show dialog to edit threshold
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
}
