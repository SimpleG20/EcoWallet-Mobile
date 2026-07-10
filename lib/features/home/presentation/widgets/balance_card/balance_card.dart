import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eco_wallet/core/constants/ui_data.dart';
import 'package:eco_wallet/core/theme/app_colors.dart';
import 'package:eco_wallet/features/settings/domain/entities/settings_entities.dart';
import 'package:eco_wallet/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:eco_wallet/features/home/domain/entities/weekly_transaction_data.dart';
import 'package:eco_wallet/features/home/domain/enum/balance_section.dart';
import 'package:eco_wallet/features/home/presentation/widgets/balance_card/balance_main_section.dart';
import 'package:eco_wallet/features/home/presentation/widgets/balance_card/balance_graph_section.dart';

/// Card widget displaying total balance and weekly transaction overview.
///
/// Features a colored background with shadow and displays:
/// - Total balance amount
/// - Monthly savings with trend indicator
/// - Weekly transaction bar chart (switchable section)
class BalanceCard extends StatefulWidget {
  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.monthlySavings,
    required this.weeklyData,
  });

  final double totalBalance;
  final double monthlySavings;
  final WeeklyTransactionData weeklyData;

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  EBalanceSection _currentSection = EBalanceSection.main;

  void _toggleSection() {
    setState(() {
      _currentSection = _currentSection == EBalanceSection.main ? EBalanceSection.graph : EBalanceSection.main;
    });
  }

  void _goToMainSection() {
    setState(() {
      _currentSection = EBalanceSection.main;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Reactive and type-safe access to appearance preferences
    final appearancePreferences = context.select((SettingsBloc bloc) {
      final state = bloc.state;
      if (state is SettingsLoadedState) {
        return state.preferences.appearancePreferences;
      }
      return const AppearancePreferences();
    });

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(kBalanceCardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkCard.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _currentSection == EBalanceSection.main
          ? BalanceMainSection(
              appearancePreferences: appearancePreferences,
              totalBalance: widget.totalBalance,
              monthlySavings: widget.monthlySavings,
              onToggleSection: _toggleSection,
            )
          : BalanceGraphSection(
              weeklyData: widget.weeklyData,
              onBackPressed: _goToMainSection,
            ),
    );
  }
}
