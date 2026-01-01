import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Entity representing notification preferences.
class NotificationPreferences extends Equatable {
  final bool dailyReminderEnabled;
  final TimeOfDay reminderTime;
  final bool billsReminderEnabled;
  final bool monthlyReportEnabled;
  final bool quietHoursEnabled;
  final TimeOfDay quietHoursStart;
  final TimeOfDay quietHoursEnd;
  final bool energySavingTipsEnabled;
  final bool highConsumptionAlertEnabled;
  final double highConsumptionThreshold;

  const NotificationPreferences({
    this.dailyReminderEnabled = false,
    this.reminderTime = const TimeOfDay(hour: 9, minute: 0),
    this.billsReminderEnabled = false,
    this.monthlyReportEnabled = false,
    this.quietHoursEnabled = false,
    this.quietHoursStart = const TimeOfDay(hour: 22, minute: 0),
    this.quietHoursEnd = const TimeOfDay(hour: 7, minute: 0),
    this.energySavingTipsEnabled = false,
    this.highConsumptionAlertEnabled = false,
    this.highConsumptionThreshold = 500.0,
  });

  NotificationPreferences copyWith({
    bool? dailyReminderEnabled,
    TimeOfDay? reminderTime,
    bool? billsReminderEnabled,
    bool? monthlyReportEnabled,
    bool? quietHoursEnabled,
    TimeOfDay? quietHoursStart,
    TimeOfDay? quietHoursEnd,
    bool? energySavingTipsEnabled,
    bool? highConsumptionAlertEnabled,
    double? highConsumptionThreshold,
  }) {
    return NotificationPreferences(
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      billsReminderEnabled: billsReminderEnabled ?? this.billsReminderEnabled,
      monthlyReportEnabled: monthlyReportEnabled ?? this.monthlyReportEnabled,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      energySavingTipsEnabled: energySavingTipsEnabled ?? this.energySavingTipsEnabled,
      highConsumptionAlertEnabled: highConsumptionAlertEnabled ?? this.highConsumptionAlertEnabled,
      highConsumptionThreshold: highConsumptionThreshold ?? this.highConsumptionThreshold,
    );
  }

  @override
  List<Object?> get props => [
        dailyReminderEnabled,
        reminderTime,
        billsReminderEnabled,
        monthlyReportEnabled,
        quietHoursEnabled,
        quietHoursStart,
        quietHoursEnd,
        energySavingTipsEnabled,
        highConsumptionAlertEnabled,
        highConsumptionThreshold,
      ];
}
