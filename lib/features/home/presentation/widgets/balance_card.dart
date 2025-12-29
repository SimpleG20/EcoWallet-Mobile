import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';

import 'package:eco_wallet/core/theme/app_colors.dart';
import 'package:eco_wallet/core/utils/app_formatters.dart';
import 'package:eco_wallet/features/home/domain/enum/balance_section.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../wallet/domain/entities/transaction.dart';

/// Card widget displaying total balance and monthly savings.
///
/// Features a colored background with shadow and displays:
/// - Total balance amount
/// - Monthly savings with trend indicator
class BalanceCard extends StatefulWidget {
  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.monthlySavings,
    required this.recentTransactions,
  });

  final double totalBalance;
  final double monthlySavings;
  final List<Transaction> recentTransactions;

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  EBalanceSection _currentSection = EBalanceSection.main;

  final double _containerHeight = 180.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkCard.withAlpha(50),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _buildCurrentSection(context, theme, loc));
  }

  Widget _buildCurrentSection(BuildContext context, ThemeData theme, AppLocalizations loc) {
    switch (_currentSection) {
      case EBalanceSection.main:
        return _buildMainSection(theme, loc);
      case EBalanceSection.graph:
        return _buildGraphSection(theme, loc);
    }
  }

  Widget _buildMainSection(ThemeData theme, AppLocalizations loc) {
    return Container(
      height: _containerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBalanceSection(theme, loc),
          const SizedBox(height: 20),
          _buildSavingsSection(theme, loc),
        ],
      ),
    );
  }

  Widget _buildBalanceSection(ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.dashboardTotalBalance,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppFormatters.formatCurrency(widget.totalBalance, loc.localeName),
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSavingsSection(ThemeData theme, AppLocalizations loc) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: theme.colorScheme.onPrimaryContainer.withAlpha(50),
          child: const Icon(Icons.trending_up, size: 20),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.dashboardMonthlySavings,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            Text(
              AppFormatters.formatCurrency(widget.monthlySavings, loc.localeName),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            setState(() {
              _currentSection = _currentSection == EBalanceSection.main ? EBalanceSection.graph : EBalanceSection.main;
            });
          },
          icon: Icon(
            Icons.arrow_forward_ios,
            size: 20,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        )
      ],
    );
  }

  Widget _buildGraphSection(ThemeData theme, AppLocalizations loc) {
    return Container(
      height: _containerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _currentSection = EBalanceSection.main;
                    });
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: theme.colorScheme.onPrimaryContainer,
                  )),
              Text(
                loc.dashboardWeeklyOverview,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      contentPadding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0),
                      actionsPadding: const EdgeInsets.all(8.0),
                      content: Text("Shows weekly transaction overview.\nThe first from right represents today."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(MaterialLocalizations.of(context).okButtonLabel),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(
                  Icons.info_outline,
                  size: 24,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _buildGraphPlaceholder(theme, loc)
        ],
      ),
    );
  }

  Widget _buildGraphPlaceholder(ThemeData theme, AppLocalizations loc) {
    final transactionsPerDay = <DateTime, double>{};
    final now = DateTime.now();
    double maxValue = 0.0;

    for (int i = 0; i < 7; i++) {
      final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final dailyTotal = widget.recentTransactions
          .where((tx) => tx.date.year == day.year && tx.date.month == day.month && tx.date.day == day.day)
          .fold<double>(0.0, (sum, tx) => sum + tx.amount);
      transactionsPerDay[day] = dailyTotal;
      if (i == 0 || dailyTotal > maxValue) {
        maxValue = dailyTotal;
      }
    }
    return Expanded(
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxValue,
          barTouchData: BarTouchData(enabled: false),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final today = DateFormat.E(loc.localeName).format(DateTime.now());
                  final day = DateTime.now().subtract(Duration(days: 6 - value.toInt()));
                  final weekday = DateFormat.E(loc.localeName).format(day);
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
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(7, (index) {
            final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: 6 - index));
            final amount = transactionsPerDay[day] ?? 0.0;
            return BarChartGroupData(
              x: index,
              showingTooltipIndicators: [],
              barRods: [
                BarChartRodData(
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxValue,
                    color: theme.colorScheme.onTertiaryContainer.withAlpha(30),
                  ),
                  toY: amount,
                  color: theme.colorScheme.onPrimaryContainer,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
