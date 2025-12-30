import '../entities/weekly_transaction_data.dart';
import '../../../wallet/domain/entities/transaction.dart';

/// Use case to calculate weekly transaction aggregation.
///
/// Takes a list of transactions and returns aggregated daily totals
/// for the last 7 days, suitable for chart display.
class CalculateWeeklyTransactions {
  /// Calculates aggregated daily transaction amounts for the last 7 days.
  ///
  /// [transactions] - List of all transactions to aggregate.
  /// Returns [WeeklyTransactionData] with daily amounts ordered from oldest to newest.
  WeeklyTransactionData call(List<Transaction> transactions) {
    final now = DateTime.now();
    final dailyAmounts = <DailyTransactionAmount>[];
    double maxAmount = 0.0;

    // Iterate from 6 days ago to today (index 0 = oldest, index 6 = today)
    for (int i = 6; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      
      final dailyTotal = transactions
          .where((tx) =>
              tx.date.year == day.year &&
              tx.date.month == day.month &&
              tx.date.day == day.day)
          .fold<double>(0.0, (sum, tx) => sum + tx.amount);

      dailyAmounts.add(DailyTransactionAmount(date: day, amount: dailyTotal));

      if (dailyTotal > maxAmount) {
        maxAmount = dailyTotal;
      }
    }

    return WeeklyTransactionData(
      dailyAmounts: dailyAmounts,
      maxAmount: maxAmount,
    );
  }
}
