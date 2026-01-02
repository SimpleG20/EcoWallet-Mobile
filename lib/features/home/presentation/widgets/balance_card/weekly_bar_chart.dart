import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/ui_data.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/weekly_transaction_data.dart';

/// Stateful bar chart widget for displaying weekly transaction data with
/// interactive tooltips that show the value when a bar is tapped.
class WeeklyBarChart extends StatefulWidget {
  const WeeklyBarChart({
    super.key,
    required this.weeklyData,
  });

  final WeeklyTransactionData weeklyData;

  @override
  State<WeeklyBarChart> createState() => _WeeklyBarChartState();
}

class _WeeklyBarChartState extends State<WeeklyBarChart> {
  int? _selectedBarIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: widget.weeklyData.maxAmount,
        barTouchData: _buildBarTouchData(theme, loc),
        gridData: FlGridData(show: false),
        titlesData: _buildTitlesData(theme, loc),
        borderData: FlBorderData(show: false),
        barGroups: _buildBarGroups(theme),
      ),
    );
  }

  BarTouchData _buildBarTouchData(ThemeData theme, AppLocalizations loc) {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        tooltipMargin: 8,
        getTooltipColor: (_) => theme.colorScheme.inverseSurface,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          final dayData = widget.weeklyData.dailyAmounts[group.x];
          final weekday = DateFormat.EEEE(loc.localeName).format(dayData.date);
          final formattedAmount = NumberFormat.currency(
            locale: loc.localeName,
            symbol: r'$',
            decimalDigits: 2,
          ).format(dayData.amount);

          return BarTooltipItem(
            '$weekday\n',
            theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onInverseSurface,
                  fontWeight: FontWeight.w500,
                ) ??
                const TextStyle(),
            children: [
              TextSpan(
                text: formattedAmount,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onInverseSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
      touchCallback: (event, response) {
        if (event is FlTapUpEvent) {
          final touchedIndex = response?.spot?.touchedBarGroupIndex;
          setState(() {
            // Toggle tooltip: tap same bar to dismiss, tap different bar to show
            if (_selectedBarIndex == touchedIndex || touchedIndex == null) {
              _selectedBarIndex = null;
            } else {
              _selectedBarIndex = touchedIndex;
            }
          });
        }
      },
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
            if (index < 0 || index >= widget.weeklyData.dailyAmounts.length) {
              return const SizedBox.shrink();
            }

            final dayData = widget.weeklyData.dailyAmounts[index];
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
    return List.generate(widget.weeklyData.dailyAmounts.length, (index) {
      final dayData = widget.weeklyData.dailyAmounts[index];
      final isSelected = _selectedBarIndex == index;

      return BarChartGroupData(
        x: index,
        showingTooltipIndicators: isSelected ? [0] : [],
        barRods: [
          BarChartRodData(
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: widget.weeklyData.maxAmount,
              color: theme.colorScheme.onTertiaryContainer.withAlpha(30),
            ),
            toY: dayData.amount,
            color: isSelected ? theme.colorScheme.onSecondaryContainer : theme.colorScheme.onPrimaryContainer,
            width: kBalanceCardBarWidth,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }
}
