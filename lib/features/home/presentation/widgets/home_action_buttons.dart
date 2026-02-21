import 'package:flutter/material.dart';

/// Action buttons for adding income and expense transactions.
///
/// Displays two styled buttons side by side for quick transaction entry.
class HomeActionButtons extends StatelessWidget {
  const HomeActionButtons({
    super.key,
    required this.incomeLabel,
    required this.expenseLabel,
    required this.onIncomePressed,
    required this.onExpensePressed,
  });

  final String incomeLabel;
  final String expenseLabel;
  final VoidCallback onIncomePressed;
  final VoidCallback onExpensePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ActionButton(
          label: incomeLabel,
          icon: Icons.add,
          iconBackgroundColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.surfaceBright,
          onPressed: onIncomePressed,
        ),
        _ActionButton(
          label: expenseLabel,
          icon: Icons.remove,
          iconBackgroundColor: theme.colorScheme.error,
          backgroundColor: theme.colorScheme.surfaceBright,
          onPressed: onExpensePressed,
        ),
      ],
    );
  }
}

/// Internal action button widget with customizable appearance.
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.iconBackgroundColor,
    required this.backgroundColor,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(160, 64),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: iconBackgroundColor,
            child: Icon(
              icon,
              size: 20,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
