import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../../domain/entities/data_preferences.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/settings_widgets.dart';
import '../../domain/enums/backup_frequency.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/presentation/widgets/core_widgets.dart';

class ManageDataPage extends StatefulWidget {
  const ManageDataPage({super.key});

  @override
  State<ManageDataPage> createState() => _ManageDataPageState();
}

class _ManageDataPageState extends State<ManageDataPage> {
  DataPreferences _currentPreferences = DataPreferences();
  DataPreferences _initialPreferences = DataPreferences();

  bool _pendingChanges = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final settingsState = context.read<SettingsBloc>().state;
    if (settingsState is SettingsLoadedState) {
      final settings = settingsState.preferences.dataPreferences;
      _currentPreferences = settings.copyWith();
      _initialPreferences = settings.copyWith();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsBloc, BaseSettingsState>(
      builder: (context, state) {
        if (state is SettingsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SettingsErrorState) {
          return Center(
            child: Text(
              state.message ?? loc.errorUnknown,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          );
        }

        if (state is SettingsLoadedState) {
          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
              ),
              body: Stack(
                children: [
                  Column(
                    children: [
                      SettingsSubPageHeader(
                        title: loc.lbManageData,
                        subtitle: loc.manageDataSubTitle,
                        complement: null,
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: SettingsCard(
                          child: _buildDataOptions(context, theme, loc),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                  SettingsConfirmEditionBtn(
                    onPressed: (ctx) => _submitChanges(ctx),
                    pendingChanges: _pendingChanges,
                  ),
                ],
              ));
        }

        return SizedBox.shrink();
      },
    );
  }

  Widget _buildDataOptions(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    final sections = [
      _buildDataSection(context, theme, loc),
      _buildBackupSection(context, theme, loc),
    ];

    return SettingsSectionList(sections: sections, theme: theme);
  }

  Widget _buildDataSection(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
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

  Widget _buildExportData(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
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

  Widget _buildImportData(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
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

  Widget _buildDeleteData(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOptionTitle(context, theme, loc.lbDelete,
                  color: theme.colorScheme.error),
              const SizedBox(height: 8),
              Text(
                loc.deleteDataDescription,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const Spacer(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
          ),
          onPressed: () {
            final userBloc = context.read<UserBloc>();
            final walletBloc = context.read<WalletBloc>();

            showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: Text(loc.confirmDeleteDataTitle),
                    content: Text(loc.askConfirmDeleteData),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text(loc.btnCancel),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          final userId =
                              (userBloc.state as UserLoadedState).user.id;
                          walletBloc.add(DeleteAllTransactionsEvent(userId));
                        },
                        child: Text(
                          loc.lbDelete,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ),
                    ],
                  );
                });
          },
          child: Icon(Icons.delete, size: 24),
        ),
      ],
    );
  }

  Widget _buildBackupSection(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(title: loc.sectionBackup),
        // TODO: Re-enable cloud backup when implemented
        // const SizedBox(height: 16),
        // SwitchRow(
        //   icon: Icons.cloud_upload,
        //   label: loc.lbEnableCloud,
        //   value: isCloudBackupEnabled, // Replace with actual state
        //   onChanged: (bool newValue) {
        //     setState(() {
        //       isCloudBackupEnabled = newValue;
        //     });
        //   },
        //   theme: theme,
        // ),
        const SizedBox(height: 8),
        SwitchRow(
          icon: Icons.lock,
          label: loc.lbEncrypted,
          value:
              _currentPreferences.encryptedBackup, // Replace with actual state
          onChanged: (bool newValue) {
            setState(() {
              _currentPreferences = _currentPreferences.copyWith(
                encryptedBackup: newValue,
              );
              _pendingChanges = _currentPreferences != _initialPreferences;
            });
          },
          theme: theme,
        ),
        const SizedBox(height: 8),
        DropdownRow<BackupFrequency>(
          icon: Icons.schedule,
          label: loc.lbFrequency,
          value: _currentPreferences.backupFrequency,
          items: [
            DropdownMenuItem(
                value: BackupFrequency.none, child: Text(loc.frequencyNone)),
            DropdownMenuItem(
                value: BackupFrequency.daily, child: Text(loc.frequencyDaily)),
            DropdownMenuItem(
                value: BackupFrequency.weekly,
                child: Text(loc.frequencyWeekly)),
            DropdownMenuItem(
                value: BackupFrequency.monthly,
                child: Text(loc.frequencyMonthly)),
          ],
          onChanged: (BackupFrequency? newValue) {
            setState(() {
              _currentPreferences = _currentPreferences.copyWith(
                backupFrequency: newValue ?? BackupFrequency.none,
              );
              _pendingChanges = _currentPreferences != _initialPreferences;
            });
          },
          theme: theme,
        )
      ],
    );
  }

  Widget _buildOptionTitle(BuildContext context, ThemeData theme, String title,
      {Color? color}) {
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        color: color ?? theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void _submitChanges(BuildContext context) {
    if (!_pendingChanges) return;

    final settingsState = context.read<SettingsBloc>().state;
    if (settingsState is! SettingsLoadedState) return;

    final newPreferences = settingsState.preferences
        .copyWith(dataPreferences: _currentPreferences);

    context
        .read<SettingsBloc>()
        .add(UpdateUserPreferencesEvent(userPreferences: newPreferences));
  }
}
