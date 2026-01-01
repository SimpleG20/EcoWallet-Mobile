import 'package:flutter/material.dart';

class SettingsConfirmEditionBtn extends StatelessWidget {
  final Function(BuildContext) onPressed;

  const SettingsConfirmEditionBtn({
    super.key,
    required this.onPressed,
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
        icon: Icon(Icons.edit_outlined),
      ),
    );
  }
}
