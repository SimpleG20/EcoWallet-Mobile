import 'package:eco_wallet/core/presentation/widgets/dropdown_row.dart';
import 'package:eco_wallet/features/settings/presentation/widgets/settings_section_list.dart';
import 'package:eco_wallet/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/switch_row.dart';
import '../widgets/settings_sub_page_header.dart';
import '../../../../l10n/app_localizations.dart';

enum EBackupFrequency { none, daily, weekly, monthly }

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
            child: _buildDataOptions(context, theme, loc),
          ),
        ),
      ],
    );
  }

  Widget _buildDataOptions(BuildContext context, ThemeData theme, AppLocalizations loc) {
    final sections = [_buildDataSection(context, theme, loc), _buildBackupSection(context, theme, loc)];

    return SettingsSectionList(sections: sections, theme: theme);
  }

  Widget _buildDataSection(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        SettingsSectionTitle(title: loc.sectionDataManagement),
        const SizedBox(height: 16),
        _buildExportData(context, theme, loc),
        const SizedBox(height: 16),
        _buildImportData(context, theme, loc),
        const SizedBox(height: 16),
        _buildDeleteData(context, theme, loc),
      ],
    );
  }

  Widget _buildExportData(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOptionTitle(context, theme, loc.lbExport),
            const SizedBox(height: 4),
            Text(
              loc.exportDataDescription,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            // Shows a popup to choose if it is encrypted or not
            // Implement export data functionality
          },
          child: Icon(
            Icons.upload,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildImportData(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOptionTitle(context, theme, loc.lbImport),
            const SizedBox(height: 8),
            Text(
              loc.importDataDescription,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            // Show a popup asking if the user want to substitute or merge data
            // Implement import data functionality
          },
          child: Icon(
            Icons.download,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteData(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOptionTitle(context, theme, loc.lbDelete, color: theme.colorScheme.error),
            const SizedBox(height: 8),
            Text(
              loc.deleteDataDescription,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        const Spacer(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
          ),
          onPressed: () {
            // Implement delete data functionality
          },
          child: Icon(Icons.delete, size: 24),
        ),
      ],
    );
  }

  Widget _buildBackupSection(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(title: loc.sectionBackup),
        const SizedBox(height: 16),
        SwitchRow(
          icon: Icons.cloud_upload,
          label: loc.lbEnableCloud,
          value: true, // Replace with actual state
          onChanged: (bool newValue) {
            // Handle toggle
          },
          theme: theme,
        ),
        const SizedBox(height: 8),
        SwitchRow(
          icon: Icons.lock,
          label: loc.lbEncrypted,
          value: false, // Replace with actual state
          onChanged: (bool newValue) {
            // Handle toggle
          },
          theme: theme,
        ),
        const SizedBox(height: 8),
        DropdownRow<EBackupFrequency>(
            icon: Icons.schedule,
            label: loc.lbFrequency,
            value: EBackupFrequency.daily,
            items: [
              DropdownMenuItem(value: EBackupFrequency.none, child: Text(loc.frequencyNone)),
              DropdownMenuItem(value: EBackupFrequency.daily, child: Text(loc.frequencyDaily)),
              DropdownMenuItem(value: EBackupFrequency.weekly, child: Text(loc.frequencyWeekly)),
              DropdownMenuItem(value: EBackupFrequency.monthly, child: Text(loc.frequencyMonthly)),
            ],
            onChanged: (EBackupFrequency? newValue) {
              // Handle dropdown change
            },
            theme: theme)
      ],
    );
  }

  Widget _buildOptionTitle(BuildContext context, ThemeData theme, String title, {Color? color}) {
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        color: color ?? theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
