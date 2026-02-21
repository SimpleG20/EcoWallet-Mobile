import 'package:eco_wallet/features/settings/presentation/widgets/settings_confirm_edition_btn.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';

class SettingsSubPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final double height;
  final SettingsConfirmEditionBtn? confirmEditionBtn;
  final Widget Function(ThemeData, AppLocalizations)? complement;

  const SettingsSubPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.complement,
    this.height = 180,
    this.confirmEditionBtn,
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
                          confirmEditionBtn == null
                              ? context.pop()
                              : confirmEditionBtn!.pendingChanges
                                  ? showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        final loc = AppLocalizations.of(ctx)!;
                                        return AlertDialog(
                                          title: Text(loc.unsavedChangesTitle),
                                          content: Text(loc.msgUnsavedChanges),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text(loc.btnCancel),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context); // Close dialog
                                                context.pop(); // Navigate back
                                              },
                                              child: Text(loc.btnDiscardChanges),
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  : context.pop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
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
