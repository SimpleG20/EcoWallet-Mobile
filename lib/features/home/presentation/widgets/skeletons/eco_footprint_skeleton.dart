import 'package:eco_wallet/core/presentation/widgets/shimmers/shimmer_container.dart';
import 'package:flutter/material.dart';

class EcoFootprintSkeleton extends StatelessWidget {
  const EcoFootprintSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerContainer(
      width: double.infinity,
      height: 150,
      borderRadius: BorderRadius.circular(16.0),
    );
  }
}
