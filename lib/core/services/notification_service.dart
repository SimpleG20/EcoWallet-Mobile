import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_10y.dart' as tz_data;

import 'package:eco_wallet/injection_container.dart';
import 'package:eco_wallet/l10n/app_localizations.dart';
import 'package:eco_wallet/features/settings/domain/entities/notification_preferences.dart';

import '../config/app_config.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int _dailyReminderId = 1;
  static const int _monthlyReportId = 2;
  static const int _dailyBudgetAlertId = 4;
  static const int _weeklyBudgetAlertId = 5;

  /// Stores the current quiet hours settings for filtering
  NotificationPreferences? _notificationPreferences;

  /// Updates the notification preferences for quiet hours filtering
  void updatePreferences(NotificationPreferences prefs) {
    _notificationPreferences = prefs;
  }

  Future<void> init() async {
    tz_data.initializeTimeZones();

    // Set the local timezone based on device settings
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _plugin.initialize(initSettings);
  }

  Future<void> requestPermissions() async {
    // check which OS we're on and request permissions accordingly
    final config = sl.get<AppConfig>();

    if (config.platform == TargetPlatform.iOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (config.platform == TargetPlatform.android) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  /// Checks if the current time is within quiet hours
  bool isInQuietHours() {
    final prefs = _notificationPreferences;
    if (prefs == null || !prefs.quietHoursEnabled) {
      return false;
    }

    final now = TimeOfDay.now();
    final start = prefs.quietHoursStart;
    final end = prefs.quietHoursEnd;

    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    // Handle overnight quiet hours (e.g., 22:00 to 07:00)
    if (startMinutes > endMinutes) {
      // Quiet hours span midnight
      return nowMinutes >= startMinutes || nowMinutes < endMinutes;
    } else {
      // Quiet hours within same day
      return nowMinutes >= startMinutes && nowMinutes < endMinutes;
    }
  }

  /// Sends a test notification immediately (respects quiet hours)
  Future<void> showTestNotification(String title, String body) async {
    if (isInQuietHours()) {
      // Silently skip notification during quiet hours
      return;
    }

    await _plugin.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Testes',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(categoryIdentifier: 'test_notification'),
      ),
    );
  }

  /// Gets the Android schedule mode based on permissions
  Future<AndroidScheduleMode> _getAndroidScheduleMode() async {
    final config = sl.get<AppConfig>();
    var scheduleMode = AndroidScheduleMode.inexactAllowWhileIdle;

    if (config.platform == TargetPlatform.android) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        final canScheduleExact =
            await androidPlugin.canScheduleExactNotifications();
        if (canScheduleExact == true) {
          scheduleMode = AndroidScheduleMode.exactAllowWhileIdle;
        }
      }
    }

    return scheduleMode;
  }

  /// Requests iOS notification permissions and returns whether granted
  Future<bool> _requestiOSPermissions() async {
    final config = sl.get<AppConfig>();
    
    if (config.platform == TargetPlatform.iOS) {
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (iosPlugin != null) {
        final granted = await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted == true;
      }
    }
    return true; // Not iOS, proceed
  }

  /// Schedules the Daily Reminder notification
  Future<void> scheduleDailyReminder(
      AppLocalizations loc, TimeOfDay time) async {
    if (!await _requestiOSPermissions()) return;

    final scheduleMode = await _getAndroidScheduleMode();

    await _plugin.zonedSchedule(
      _dailyReminderId,
      loc.ntfDailyReminderTitle,
      loc.ntfDailyReminderBody,
      _nextInstanceOfTime(time),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminders',
          loc.ntfDailyReminderChannelName,
          channelDescription: loc.ntfDailyReminderChannelDescription,
        ),
        iOS: const DarwinNotificationDetails(
          categoryIdentifier: 'daily_reminder',
        ),
      ),
      androidScheduleMode: scheduleMode,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyReminder() async {
    await _plugin.cancel(_dailyReminderId);
  }

  /// Schedules the Monthly Report notification on the 1st of each month at 10:00 AM
  Future<void> scheduleMonthlyReport(AppLocalizations loc) async {
    if (!await _requestiOSPermissions()) return;

    final scheduleMode = await _getAndroidScheduleMode();

    await _plugin.zonedSchedule(
      _monthlyReportId,
      loc.ntfMonthlyReportTitle,
      loc.ntfMonthlyReportBody,
      _nextInstanceOfMonthDay(1, 10, 0),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'monthly_reports',
          loc.ntfMonthlyReportChannelName,
          channelDescription: loc.ntfMonthlyReportChannelDescription,
        ),
        iOS: const DarwinNotificationDetails(
          categoryIdentifier: 'monthly_report',
        ),
      ),
      androidScheduleMode: scheduleMode,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }

  Future<void> cancelMonthlyReport() async {
    await _plugin.cancel(_monthlyReportId);
  }

  /// Calculates the next occurrence of a specific time of day
  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final local = tz.local;
    final now = tz.TZDateTime.now(local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        local, now.year, now.month, now.day, time.hour, time.minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  /// Calculates the next occurrence of a specific day of month and time
  tz.TZDateTime _nextInstanceOfMonthDay(int day, int hour, int minute) {
    final local = tz.local;
    final now = tz.TZDateTime.now(local);
    
    // Try this month first
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        local, now.year, now.month, day, hour, minute);

    // If the date has passed, schedule for next month
    if (scheduledDate.isBefore(now)) {
      // Move to next month
      if (now.month == 12) {
        scheduledDate = tz.TZDateTime(local, now.year + 1, 1, day, hour, minute);
      } else {
        scheduledDate = tz.TZDateTime(local, now.year, now.month + 1, day, hour, minute);
      }
    }
    
    return scheduledDate;
  }

  /// Shows a notification when automatic backup is completed
  Future<void> showBackupCompleteNotification({
    required String title,
    required String body,
  }) async {
    if (isInQuietHours()) {
      return;
    }

    await _plugin.show(
      3, // backup notification id
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'backup_channel',
          'Backup Notifications',
          channelDescription: 'Notifications for backup completion',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(categoryIdentifier: 'backup_notification'),
      ),
    );
  }

  /// Shows a notification for daily budget alert
  Future<void> showDailyBudgetAlert({
    required String title,
    required String body,
    required String channelName,
    required String channelDescription,
  }) async {
    if (isInQuietHours()) return;

    await _plugin.show(
      _dailyBudgetAlertId,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'budget_alerts',
          channelName,
          channelDescription: channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          categoryIdentifier: 'budget_alert',
        ),
      ),
    );
  }

  /// Shows a notification for weekly budget alert
  Future<void> showWeeklyBudgetAlert({
    required String title,
    required String body,
    required String channelName,
    required String channelDescription,
  }) async {
    if (isInQuietHours()) return;

    await _plugin.show(
      _weeklyBudgetAlertId,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'budget_alerts',
          channelName,
          channelDescription: channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          categoryIdentifier: 'budget_alert',
        ),
      ),
    );
  }
}

