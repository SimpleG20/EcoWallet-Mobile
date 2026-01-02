import 'package:flutter/material.dart';

class SettingsConfirmEditionBtn extends StatelessWidget {
  final Function(BuildContext) onPressed;
  final bool pendingChanges;

  const SettingsConfirmEditionBtn({
    super.key,
    required this.onPressed,
    required this.pendingChanges,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      bottom: 24,
      right: 24,
      child: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: Colors.black.withValues(alpha: 0.3),
          elevation: 6,
        ),
        onPressed: () => onPressed(context),
        icon: Badge(
          isLabelVisible: pendingChanges,
          smallSize: 8,
          child: Icon(Icons.edit_outlined),
        ),
      ),
    );
  }
}
