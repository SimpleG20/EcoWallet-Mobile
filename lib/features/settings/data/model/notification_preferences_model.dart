import 'package:eco_wallet/core/utils/app_formatters.dart';
import 'package:eco_wallet/features/settings/domain/entities/notification_preferences.dart';
import 'package:flutter/material.dart';

class NotificationPreferencesModel extends NotificationPreferences {
  const NotificationPreferencesModel({
    required super.dailyReminderEnabled,
    required super.reminderTime,
    required super.monthlyReportEnabled,
    required super.quietHoursEnabled,
    required super.quietHoursStart,
    required super.quietHoursEnd,
  });

  factory NotificationPreferencesModel.defaults() {
    return const NotificationPreferencesModel(
      dailyReminderEnabled: false,
      reminderTime: TimeOfDay(hour: 9, minute: 0),
      monthlyReportEnabled: false,
      quietHoursEnabled: false,
      quietHoursStart: TimeOfDay(hour: 22, minute: 0),
      quietHoursEnd: TimeOfDay(hour: 7, minute: 0),
    );
  }

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferencesModel(
      dailyReminderEnabled: _parseBool(json['dailyReminderEnabled'], false),
      reminderTime: _parseTimeOfDay(
          json['reminderTime'], const TimeOfDay(hour: 9, minute: 0)),
      monthlyReportEnabled: _parseBool(json['monthlyReportEnabled'], false),
      quietHoursEnabled: _parseBool(json['quietHoursEnabled'], false),
      quietHoursStart: _parseTimeOfDay(
          json['quietHoursStart'], const TimeOfDay(hour: 22, minute: 0)),
      quietHoursEnd: _parseTimeOfDay(
          json['quietHoursEnd'], const TimeOfDay(hour: 7, minute: 0)),
    );
  }

  /// Parses a boolean value from JSON that may be a bool, int (0/1), or string.
  static bool _parseBool(dynamic value, bool defaultValue) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String)
      return int.tryParse(value) == 1 || value.toLowerCase() == 'true';
    return defaultValue;
  }

  /// Parses a TimeOfDay from a string in "HH:mm" format.
  static TimeOfDay _parseTimeOfDay(dynamic value, TimeOfDay defaultValue) {
    if (value == null) return defaultValue;
    if (value is! String) return defaultValue;
    try {
      return AppFormatters.parseTimeOfDay(value);
    } catch (_) {
      return defaultValue;
    }
  }

  static Map<String, dynamic> toJson(NotificationPreferences preferences) {
    return {
      'dailyReminderEnabled': preferences.dailyReminderEnabled,
      'reminderTime': AppFormatters.formatTimeOfDay(preferences.reminderTime),
      'monthlyReportEnabled': preferences.monthlyReportEnabled,
      'quietHoursEnabled': preferences.quietHoursEnabled,
      'quietHoursStart':
          AppFormatters.formatTimeOfDay(preferences.quietHoursStart),
      'quietHoursEnd': AppFormatters.formatTimeOfDay(preferences.quietHoursEnd),
    };
  }
}
