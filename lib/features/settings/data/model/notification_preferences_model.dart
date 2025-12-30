import 'package:eco_wallet/core/utils/app_formatters.dart';
import 'package:eco_wallet/features/settings/domain/entities/notification_preferences.dart';

class NotificationPreferencesModel extends NotificationPreferences {
  const NotificationPreferencesModel({
    required super.dailyReminderEnabled,
    required super.reminderTime,
    required super.billsReminderEnabled,
    required super.monthlyReportEnabled,
    required super.quietHoursEnabled,
    required super.quietHoursStart,
    required super.quietHoursEnd,
    required super.energySavingTipsEnabled,
    required super.highConsumptionAlertEnabled,
    required super.highConsumptionThreshold,
  });

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferencesModel(
      dailyReminderEnabled: json['dailyReminderEnabled'] as bool,
      reminderTime: AppFormatters.parseTimeOfDay(json['reminderTime'] as String),
      billsReminderEnabled: json['billsReminderEnabled'] as bool,
      monthlyReportEnabled: json['monthlyReportEnabled'] as bool,
      quietHoursEnabled: json['quietHoursEnabled'] as bool,
      quietHoursStart: AppFormatters.parseTimeOfDay(json['quietHoursStart'] as String),
      quietHoursEnd: AppFormatters.parseTimeOfDay(json['quietHoursEnd'] as String),
      energySavingTipsEnabled: json['energySavingTipsEnabled'] as bool,
      highConsumptionAlertEnabled: json['highConsumptionAlertEnabled'] as bool,
      highConsumptionThreshold: json['highConsumptionThreshold'] as double,
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
      'energySavingTipsEnabled': preferences.energySavingTipsEnabled,
      'highConsumptionAlertEnabled': preferences.highConsumptionAlertEnabled,
      'highConsumptionThreshold': preferences.highConsumptionThreshold,
    };
  }
}
