import 'package:eco_wallet/core/presentation/widgets/shimmers/shimmer_container.dart';
import 'package:flutter/material.dart';

/// A convenience widget for creating text-like shimmer placeholders.
///
/// Useful for simulating lines of text in skeleton loaders.
class ShimmerText extends StatelessWidget {
  /// The width of the text placeholder.
  final double width;

  /// The height of the text placeholder.
  /// Defaults to 16.0 (typical body text size).
  final double height;
  const ShimmerText({
    super.key,
    required this.width,
    this.height = 16.0,
  });
  @override
  Widget build(BuildContext context) {
    return ShimmerContainer(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(4.0),
    );
  }
}
