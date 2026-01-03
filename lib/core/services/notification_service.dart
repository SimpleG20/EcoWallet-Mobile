import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_10y.dart' as tz_data;

import 'package:eco_wallet/injection_container.dart';
import 'package:eco_wallet/l10n/app_localizations.dart';

import '../config/app_config.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static const int _dailyReminderId = 1;

  Future<void> init() async {
    tz_data.initializeTimeZones();

    // Set the local timezone based on device settings
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _plugin.initialize(initSettings);
  }

  Future<void> requestPermissions() async {
    // check which OS we're on and request permissions accordingly
    final config = sl.get<AppConfig>();

    if (config.platform == TargetPlatform.iOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (config.platform == TargetPlatform.android) {
      await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  /// Envia notificação de teste imediata
  Future<void> showTestNotification(String title, String body) async {
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

  /// Agenda o Lembrete Diário
  Future<void> scheduleDailyReminder(AppLocalizations loc, TimeOfDay time) async {
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
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyReminder() async {
    await _plugin.cancel(_dailyReminderId);
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final local = tz.local;
    final now = tz.TZDateTime.now(local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(local, now.year, now.month, now.day, time.hour, time.minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
