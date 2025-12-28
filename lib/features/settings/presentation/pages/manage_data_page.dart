import 'package:eco_wallet/features/settings/presentation/widgets/settings_sub_page_header.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class ManageDataPage extends StatelessWidget {
  const ManageDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Column(
      children: [
        SettingsSubPageHeader(
          title: loc.lbManageData,
          subtitle: loc.manageDataSubTitle,
          complement: null,
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
            clipBehavior: Clip.hardEdge,
            child: const Center(
              child: Text("Manage Data Content Goes Here"),
            ),
          ),
        ),
      ],
    );
  }
}

// SettingsOptionItem(
//           icon: Icons.backup_outlined,
//           title: loc.lbBackupData,
//           onTap: () => _showScreen(context, Center() /* pass the widget you want to show here */),
//         ),
//         const SizedBox(height: 8),
//         SettingsOptionItem(
//           icon: Icons.delete_outline,
//           title: loc.lbDeleteData,
//           onTap: () => _showScreen(context, Center() /* pass the widget you want to show here */),
//         ),
