import 'package:eco_wallet/core/presentation/widgets/shimmers/shimmer_container.dart';
import 'package:flutter/material.dart';

/// A convenience widget for creating circular shimmer placeholders.
///
/// Useful for avatar or icon placeholders.
class ShimmerCircle extends StatelessWidget {
  /// The diameter of the circle.
  final double size;
  const ShimmerCircle({
    super.key,
    required this.size,
  });
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: ShimmerContainer(
        width: size,
        height: size,
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }
}
