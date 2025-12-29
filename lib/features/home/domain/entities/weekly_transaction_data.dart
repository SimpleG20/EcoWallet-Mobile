import 'package:flutter/foundation.dart';

/// Represents a single day's transaction total.
@immutable
class DailyTransactionAmount {
  const DailyTransactionAmount({
    required this.date,
    required this.amount,
  });

  /// The date of the transactions.
  final DateTime date;

  /// The total amount for the day.
  final double amount;
}

/// Aggregated weekly transaction data for chart display.
@immutable
class WeeklyTransactionData {
  const WeeklyTransactionData({
    required this.dailyAmounts,
    required this.maxAmount,
  });

  /// List of daily transaction amounts for the last 7 days.
  /// Index 0 is the oldest day, index 6 is today.
  final List<DailyTransactionAmount> dailyAmounts;

  /// The maximum daily amount (used for chart scaling).
  final double maxAmount;

  /// Creates empty data with zeros for all 7 days.
  factory WeeklyTransactionData.empty() {
    final now = DateTime.now();
    return WeeklyTransactionData(
      dailyAmounts: List.generate(7, (index) {
        final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: 6 - index));
        return DailyTransactionAmount(date: day, amount: 0.0);
      }),
      maxAmount: 0.0,
    );
  }
}
