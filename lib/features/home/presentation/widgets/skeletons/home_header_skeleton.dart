import 'package:eco_wallet/core/presentation/widgets/shimmers/shimmer_circle.dart';
import 'package:eco_wallet/core/presentation/widgets/shimmers/shimmer_text.dart';
import 'package:flutter/material.dart';

class HomeHeaderSkeleton extends StatelessWidget {
  const HomeHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerText(width: 150, height: 20),
            const SizedBox(height: 8),
            ShimmerText(width: 100, height: 28),
          ],
        ),
        const Spacer(),
        ShimmerCircle(size: 48),
      ],
    );
  }
}
