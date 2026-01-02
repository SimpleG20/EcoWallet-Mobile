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

  const NotificationPreferences({
    this.dailyReminderEnabled = false,
    this.reminderTime = const TimeOfDay(hour: 9, minute: 0),
    this.billsReminderEnabled = false,
    this.monthlyReportEnabled = false,
    this.quietHoursEnabled = false,
    this.quietHoursStart = const TimeOfDay(hour: 22, minute: 0),
    this.quietHoursEnd = const TimeOfDay(hour: 7, minute: 0),
  });

  NotificationPreferences copyWith({
    bool? dailyReminderEnabled,
    TimeOfDay? reminderTime,
    bool? billsReminderEnabled,
    bool? monthlyReportEnabled,
    bool? quietHoursEnabled,
    TimeOfDay? quietHoursStart,
    TimeOfDay? quietHoursEnd,
  }) {
    return NotificationPreferences(
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      billsReminderEnabled: billsReminderEnabled ?? this.billsReminderEnabled,
      monthlyReportEnabled: monthlyReportEnabled ?? this.monthlyReportEnabled,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
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
      ];
}
