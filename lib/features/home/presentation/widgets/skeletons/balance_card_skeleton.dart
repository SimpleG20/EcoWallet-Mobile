import 'package:flutter/material.dart';

import '../../../../../core/constants/ui_data.dart';
import '../../../../../core/presentation/widgets/shimmers/shimmer_circle.dart';
import '../../../../../core/presentation/widgets/shimmers/shimmer_text.dart';

class BalanceCardSkeleton extends StatelessWidget {
  const BalanceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(kBalanceCardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBalanceSection(),
            const SizedBox(height: 48),
            _buildSavingsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerText(width: 100, height: 20),
        const SizedBox(height: 4),
        ShimmerText(width: 150, height: 32),
      ],
    );
  }

  Widget _buildSavingsSection() {
    return Row(
      children: [
        ShimmerCircle(size: 32),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerText(width: 150, height: 16),
            const SizedBox(height: 4),
            ShimmerText(width: 100, height: 20),
          ],
        ),
        const Spacer(),
        ShimmerCircle(size: 32),
      ],
    );
  }
}
