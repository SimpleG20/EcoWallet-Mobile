import 'package:eco_wallet/core/presentation/widgets/shimmers/shimmer_text.dart';
import 'package:flutter/material.dart';

import 'package:eco_wallet/core/presentation/widgets/shimmers/shimmer_container.dart';

class TransactionSectionSkeleton extends StatelessWidget {
  const TransactionSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          ShimmerText(
            width: 150,
            height: 20,
          ),
          ShimmerText(
            width: 80,
            height: 20,
          ),
        ]),
        const SizedBox(height: 8),
        ...List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ShimmerContainer(
              width: double.infinity,
              height: 60,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ],
    );
  }
}
