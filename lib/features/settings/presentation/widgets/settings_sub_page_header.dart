import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class SettingsSubPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget Function(ThemeData, AppLocalizations)? complement;
  final double height;

  const SettingsSubPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.complement,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: complement != null ? height : 120,
      child: Stack(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(16.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.onPrimaryContainer.withAlpha(30),
                      child: IconButton(
                        onPressed: () {
                          // TODO: implement navigation back
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FittedBox(
                  alignment: Alignment.topLeft,
                  child: Text(
                    subtitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer.withAlpha(220),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (complement != null)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: complement != null ? complement!(theme, AppLocalizations.of(context)!) : null,
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
