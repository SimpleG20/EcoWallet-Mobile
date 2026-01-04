import 'package:eco_wallet/features/settings/domain/entities/budget_preferences.dart';

/// Result of a budget limit check indicating which alerts should be triggered.
class BudgetAlertResult {
  final bool shouldAlertDaily;
  final bool shouldAlertWeekly;
  final int? dailyPercentageReached;
  final int? weeklyPercentageReached;

  const BudgetAlertResult({
    this.shouldAlertDaily = false,
    this.shouldAlertWeekly = false,
    this.dailyPercentageReached,
    this.weeklyPercentageReached,
  });

  bool get hasAnyAlert => shouldAlertDaily || shouldAlertWeekly;
}

/// Service responsible for checking budget limits and determining if alerts should be triggered.
class BudgetAlertService {
  /// Checks if current expenses exceed the configured alert thresholds.
  ///
  /// Returns a [BudgetAlertResult] indicating which alerts should be shown.
  BudgetAlertResult checkBudgetLimits({
    required double dailyExpense,
    required double weeklyExpense,
    required BudgetPreferences preferences,
  }) {
    bool alertDaily = false;
    bool alertWeekly = false;
    int? dailyPercentage;
    int? weeklyPercentage;

    // Check daily limit
    final dailyLimit = preferences.dailyBudgetLimit;
    final dailyAlertPercent = preferences.dailyAlertPercentage;

    if (dailyLimit != null && dailyLimit > 0 && dailyAlertPercent != null) {
      final threshold = dailyLimit * (dailyAlertPercent / 100);
      if (dailyExpense >= threshold) {
        alertDaily = true;
        dailyPercentage = ((dailyExpense / dailyLimit) * 100).round();
      }
    }

    // Check weekly limit
    final weeklyLimit = preferences.weeklyBudgetLimit;
    final weeklyAlertPercent = preferences.weeklyAlertPercentage;

    if (weeklyLimit != null && weeklyLimit > 0 && weeklyAlertPercent != null) {
      final threshold = weeklyLimit * (weeklyAlertPercent / 100);
      if (weeklyExpense >= threshold) {
        alertWeekly = true;
        weeklyPercentage = ((weeklyExpense / weeklyLimit) * 100).round();
      }
    }

    return BudgetAlertResult(
      shouldAlertDaily: alertDaily,
      shouldAlertWeekly: alertWeekly,
      dailyPercentageReached: dailyPercentage,
      weeklyPercentageReached: weeklyPercentage,
    );
  }
}
