import 'package:eco_wallet/core/utils/app_formatters.dart';
import 'package:eco_wallet/features/settings/domain/entities/notification_preferences.dart';
import 'package:flutter/material.dart';

class NotificationPreferencesModel extends NotificationPreferences {
  const NotificationPreferencesModel({
    required super.dailyReminderEnabled,
    required super.reminderTime,
    required super.billsReminderEnabled,
    required super.monthlyReportEnabled,
    required super.quietHoursEnabled,
    required super.quietHoursStart,
    required super.quietHoursEnd,
  });

  factory NotificationPreferencesModel.defaults() {
    return const NotificationPreferencesModel(
      dailyReminderEnabled: false,
      reminderTime: TimeOfDay(hour: 9, minute: 0),
      billsReminderEnabled: false,
      monthlyReportEnabled: false,
      quietHoursEnabled: false,
      quietHoursStart: TimeOfDay(hour: 22, minute: 0),
      quietHoursEnd: TimeOfDay(hour: 7, minute: 0),
    );
  }

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferencesModel(
      dailyReminderEnabled: int.tryParse(json['dailyReminderEnabled']) == 1,
      reminderTime: AppFormatters.parseTimeOfDay(json['reminderTime']),
      billsReminderEnabled: int.tryParse(json['billsReminderEnabled']) == 1,
      monthlyReportEnabled: int.tryParse(json['monthlyReportEnabled']) == 1,
      quietHoursEnabled: int.tryParse(json['quietHoursEnabled']) == 1,
      quietHoursStart: AppFormatters.parseTimeOfDay(json['quietHoursStart']),
      quietHoursEnd: AppFormatters.parseTimeOfDay(json['quietHoursEnd']),
    );
  }

  static Map<String, dynamic> toJson(NotificationPreferences preferences) {
    return {
      'dailyReminderEnabled': preferences.dailyReminderEnabled,
      'reminderTime': AppFormatters.formatTimeOfDay(preferences.reminderTime),
      'billsReminderEnabled': preferences.billsReminderEnabled,
      'monthlyReportEnabled': preferences.monthlyReportEnabled,
      'quietHoursEnabled': preferences.quietHoursEnabled,
      'quietHoursStart': AppFormatters.formatTimeOfDay(preferences.quietHoursStart),
      'quietHoursEnd': AppFormatters.formatTimeOfDay(preferences.quietHoursEnd),
    };
  }
}
