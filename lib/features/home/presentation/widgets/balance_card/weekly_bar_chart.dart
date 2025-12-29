import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/ui_data.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/weekly_transaction_data.dart';

/// Stateless bar chart widget for displaying weekly transaction data.
class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({
    super.key,
    required this.weeklyData,
  });

  final WeeklyTransactionData weeklyData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: weeklyData.maxAmount,
        barTouchData: BarTouchData(enabled: false),
        gridData: FlGridData(show: false),
        titlesData: _buildTitlesData(theme, loc),
        borderData: FlBorderData(show: false),
        barGroups: _buildBarGroups(theme),
      ),
    );
  }

  FlTitlesData _buildTitlesData(ThemeData theme, AppLocalizations loc) {
    final today = DateFormat.E(loc.localeName).format(DateTime.now());

    return FlTitlesData(
      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= weeklyData.dailyAmounts.length) {
              return const SizedBox.shrink();
            }

            final dayData = weeklyData.dailyAmounts[index];
            final weekday = DateFormat.E(loc.localeName).format(dayData.date);
            final isToday = today == weekday;

            return Text(
              weekday.substring(0, 1).toUpperCase(),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            );
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(ThemeData theme) {
    return List.generate(weeklyData.dailyAmounts.length, (index) {
      final dayData = weeklyData.dailyAmounts[index];
      return BarChartGroupData(
        x: index,
        showingTooltipIndicators: [],
        barRods: [
          BarChartRodData(
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: weeklyData.maxAmount,
              color: theme.colorScheme.onTertiaryContainer.withAlpha(30),
            ),
            toY: dayData.amount,
            color: theme.colorScheme.onPrimaryContainer,
            width: kBalanceCardBarWidth,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }
}
