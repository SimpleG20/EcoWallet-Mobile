import 'package:eco_wallet/features/home/domain/entities/eco_data.dart';
import 'package:eco_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class EcoFootprintCard extends StatelessWidget {
  const EcoFootprintCard({super.key, required this.ecoData});

  static const double kMaxCarbonFootprint = 400.0;

  final EcoData ecoData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    // Theme-aware colors
    final gradientStart = isDark ? AppColors.ecoGradientStartDark : AppColors.ecoGradientStart;
    final gradientEnd = isDark ? AppColors.ecoGradientEndDark : AppColors.ecoGradientEnd;
    final textColor = isDark ? AppColors.darkForeground : Colors.white;
    final shadowColor = isDark 
        ? AppColors.darkPrimary.withValues(alpha: 0.2) 
        : Colors.green.withValues(alpha: 0.3);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gradientStart, gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
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
              color: textColor,
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
                          value: 1 - (ecoData.carbonFootprint / kMaxCarbonFootprint).clamp(0, 1),
                          strokeWidth: 6,
                          valueColor: AlwaysStoppedAnimation(_getDangerColor(ecoData.carbonFootprint, isDark)),
                          backgroundColor: textColor.withValues(alpha: 0.2),
                        ),
                      ),
                      Column(
                        children: [
                          Icon(Icons.eco, color: _getDangerColor(ecoData.carbonFootprint, isDark), size: 40),
                          Text(
                            '${(100 - (ecoData.carbonFootprint / kMaxCarbonFootprint * 100)).clamp(0, 100).toStringAsFixed(0)}%',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: textColor,
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
                        color: textColor,
                      ),
                    ),
                    Text(
                      loc.ecoFootprintValue(ecoData.carbonFootprint.toStringAsFixed(1)),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loc.lbEcoFootprintCompensation,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: textColor,
                      ),
                    ),
                    Text(
                      loc.ecoFootprintCompensation(ecoData.treesPlanted),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: textColor,
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

  Color _getDangerColor(double value, bool isDark) {
    final goodColor = isDark ? AppColors.darkForeground : Colors.white;
    if (value < kMaxCarbonFootprint / 3) {
      return goodColor;
    } else if (value < 2 * kMaxCarbonFootprint / 3) {
      return isDark ? Colors.orange.shade300 : Colors.orange;
    } else {
      return isDark ? Colors.red.shade300 : Colors.red;
    }
  }
}
