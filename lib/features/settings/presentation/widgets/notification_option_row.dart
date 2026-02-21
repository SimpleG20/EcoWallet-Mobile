import 'package:flutter/material.dart';

/// A reusable widget for notification/setting options with switch control.
///
/// Displays an icon, title, optional description, and a switch.
/// Optionally shows a trailing widget (e.g., time picker button).
class NotificationOptionRow extends StatelessWidget {
  const NotificationOptionRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.description,
    this.trailing,
  });

  /// Leading icon for the option
  final IconData icon;

  /// Title text for the option
  final String title;

  /// Optional description text shown below the title
  final String? description;

  /// Current switch value
  final bool value;

  /// Callback when switch value changes
  final ValueChanged<bool> onChanged;

  /// Optional trailing widget (e.g., time picker button)
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (description != null)
                Text(
                  description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
        if (trailing != null) trailing!,
      ],
    );
  }
}
