import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key, this.thickness, this.height});

  final double? thickness;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
            child: Divider(
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          thickness: thickness ?? 1,
          height: height,
        )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            loc.lbOr,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ),
        Expanded(
            child: Divider(
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          thickness: thickness ?? 1,
          height: height,
        )),
      ],
    );
  }
}
