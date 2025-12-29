import 'package:flutter/material.dart';

class DropdownRow<T> extends StatelessWidget {
  final IconData icon;
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final ThemeData theme;

  const DropdownRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontSize: 15,
            ),
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            items: items,
            menuMaxHeight: 150,
            onChanged: onChanged,
            icon: Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}
