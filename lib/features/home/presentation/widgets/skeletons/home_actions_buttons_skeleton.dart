import 'package:eco_wallet/core/presentation/widgets/shimmers/shimmer_container.dart';
import 'package:flutter/material.dart';

class HomeActionsButtonsSkeleton extends StatelessWidget {
  const HomeActionsButtonsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ShimmerContainer(width: 160, height: 64),
        ShimmerContainer(width: 160, height: 64),
      ],
    );
  }
}
