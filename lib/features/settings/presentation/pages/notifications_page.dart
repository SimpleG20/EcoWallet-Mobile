import 'package:eco_wallet/features/settings/presentation/widgets/settings_sub_page_header.dart';
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
            child: _buildNotificationsOptions(context, theme, loc),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsOptions(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    final sections = [
      _buildRemindersSection(context, theme, loc),
      _buildReportsSection(context, theme, loc),
      _buildDoNotDisturbSection(context, theme, loc),
      _buildEcoSection(context, theme, loc),
      _buildTestNotificationButton(context, theme, loc),
    ];
    return SettingsSectionList(sections: sections, theme: theme);
  }

  Widget _buildRemindersSection(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        SettingsSectionTitle(title: "Reminders"),
        const SizedBox(height: 16),
        _buildDailyReminderOption(context, theme, loc),
        const SizedBox(height: 16),
        _buildBillsReminderOption(context, theme, loc),
      ],
    );
  }

  Widget _buildDailyReminderOption(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Row(
      children: [
        Icon(Icons.notifications_outlined,
            color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Daily Reminder", //loc.dailyReminder,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                "Receive daily notifications about your energy usage", //loc.dailyReminderDescription,
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

  Widget _buildBillsReminderOption(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Row(
      children: [
        Icon(Icons.receipt_long_outlined,
            color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bills Reminder", //loc.billsReminder,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                "Get notified about upcoming bills", //loc.billsReminderDescription,
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

  Widget _buildReportsSection(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        SettingsSectionTitle(title: "Reports"),
        const SizedBox(height: 16),
        _buildMonthlyReportOption(context, theme, loc),
      ],
    );
  }

  Widget _buildMonthlyReportOption(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Row(
      children: [
        Icon(Icons.calendar_month_outlined,
            color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Monthly Report",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                "Receive monthly consumption summary",
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

  Widget _buildDoNotDisturbSection(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            "Do Not Disturb",
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            Icon(Icons.nightlight_outlined,
                color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Quiet Hours",
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
              Expanded(child: Text("From:", style: theme.textTheme.bodyMedium)),
              TextButton(
                onPressed: () {},
                child: const Text("22:00"),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text("To:", style: theme.textTheme.bodyMedium)),
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

  Widget _buildEcoSection(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        SettingsSectionTitle(title: "Eco Notifications"),
        const SizedBox(height: 16),
        _buildEnergySavingTipsOption(context, theme, loc),
        const SizedBox(height: 16),
        _buildHighConsumptionAlertOption(context, theme, loc)
      ],
    );
  }

  Widget _buildEnergySavingTipsOption(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Row(
      children: [
        Icon(Icons.energy_savings_leaf_outlined,
            color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Energy Saving Tips",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                "Receive tips to reduce energy consumption",
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

  Widget _buildHighConsumptionAlertOption(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.warning_amber_outlined,
                color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "High Consumption Alert",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    "Alert when consumption exceeds threshold",
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
                  "Threshold: 500 kWh",
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

  Widget _buildTestNotificationButton(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: OutlinedButton.icon(
        onPressed: () {
          // Send test notification
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Test notification sent!')),
          );
        },
        icon: const Icon(Icons.send_outlined),
        label: const Text('Send Test Notification'),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    );
  }
}
