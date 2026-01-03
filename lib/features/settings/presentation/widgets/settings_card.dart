import 'package:flutter/material.dart';

/// A reusable card container for settings pages.
///
/// This widget encapsulates the common decoration pattern used across
/// all settings sub-pages, eliminating code duplication.
class SettingsCard extends StatelessWidget {
  /// The content to display inside the card.
  final Widget child;

  /// Optional margin around the card.
  /// Defaults to `EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0)`.
  final EdgeInsetsGeometry margin;

  /// Whether to clip the content at the card boundaries.
  final Clip clipBehavior;

  const SettingsCard({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    this.clipBehavior = Clip.hardEdge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
          ),
        ],
      ),
      margin: margin,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}
