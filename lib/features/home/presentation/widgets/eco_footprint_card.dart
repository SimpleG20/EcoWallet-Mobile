import 'package:eco_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class EcoFootprintCard extends StatelessWidget {
  const EcoFootprintCard({super.key, required this.co2Emissions, required this.treesNeeded});

  final double co2Emissions;
  final int treesNeeded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.ecoGradientStart,
            AppColors.ecoGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.lbMonthlyProgress,
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: (co2Emissions / 50).clamp(0, 1),
                          strokeWidth: 6,
                          valueColor: AlwaysStoppedAnimation(_getDangerColor(co2Emissions)),
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      Column(
                        children: [
                          Icon(Icons.eco, color: _getDangerColor(co2Emissions), size: 40),
                          Text(
                            '${(co2Emissions / 50 * 100).toStringAsFixed(0)}%',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      loc.lbEcoFootprint,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      loc.ecoFootprintValue(co2Emissions.toStringAsFixed(1)),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loc.lbEcoFootprintCompensation,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      loc.ecoFootprintCompensation(treesNeeded),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getDangerColor(double value) {
    if (value < 10) {
      return Colors.white;
    } else if (value < 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
