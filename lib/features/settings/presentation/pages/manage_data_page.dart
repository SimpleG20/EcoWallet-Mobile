import 'dart:io';

import 'package:eco_wallet/core/presentation/widgets/icon_button_field.dart';
import 'package:eco_wallet/core/utils/transaction_parsing.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/settings_bloc.dart';
import '../widgets/export_dialog.dart';
import '../widgets/import_dialog.dart';
import '../widgets/settings_widgets.dart';
import '../../domain/usecases/import_data.dart';
import '../../domain/enums/backup_frequency.dart';
import '../../domain/entities/data_preferences.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../wallet/data/models/transaction_model.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/services/backup_service.dart';
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
        IconButtonField(
          icon: Icons.upload_file_outlined,
          title: loc.lbExportData,
          subtitle: loc.exportDataDescription,
          onPressed: () => _showExportDialog(context, loc),
        ),
        const SizedBox(height: 16),
        IconButtonField(
          icon: Icons.download_outlined,
          title: loc.lbImport,
          subtitle: loc.importDataDescription,
          onPressed: () => _showImportFlow(context, loc),
        ),
        const SizedBox(height: 16),
        IconButtonField(
          icon: Icons.delete_forever_outlined,
          title: loc.lbDelete,
          subtitle: loc.deleteDataDescription,
          onPressed: () => _deleteAction(context, theme, loc),
          color: theme.colorScheme.error,
        ),
      ],
    );
  }

  void _deleteAction(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
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
                final userId = (userBloc.state as UserLoadedState).user.id;
                walletBloc.add(DeleteAllTransactionsEvent(userId));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.msgTransactionDeleted)),
                );
              },
              child: Text(
                loc.lbDelete,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          ],
        );
      },
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

  Future<void> _showExportDialog(
      BuildContext context, AppLocalizations loc) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => ExportDialog(
        defaultEncrypted: _currentPreferences.encryptedBackup,
      ),
    );

    if (result == null) {
      _showSnackBar(context, loc.exportCancelled);
      return;
    }

    final encrypted = result['encrypted'] as bool;
    final password = result['password'] as String?;

    // Get user ID
    final userBloc = context.read<UserBloc>();
    if (userBloc.state is! UserLoadedState) return;
    final userId = (userBloc.state as UserLoadedState).user.id;

    // Get transactions from wallet bloc
    final walletState = context.read<WalletBloc>().state;
    if (walletState is! WalletLoaded) return;

    // Convert transactions to JSON format
    final transactions = walletState.transactions
        .map((t) => TransactionModel.fromEntity(t).toJson())
        .toList();

    // Create backup
    final backupService = BackupService();
    final backupJson = backupService.exportToJson(
      userId: userId,
      transactions: transactions,
      password: encrypted ? password : null,
    );

    // Let user choose save location
    final extension = encrypted ? 'ewb' : 'json';
    final timestamp =
        DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
    final fileName = 'ecowallet_backup_$timestamp.$extension';

    final savePath = await FilePicker.platform.saveFile(
      dialogTitle: loc.lbExport,
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: [extension],
    );

    if (savePath == null) {
      _showSnackBar(context, loc.exportCancelled);
      return;
    }

    // Write file
    final file = File(savePath);
    await file.writeAsString(backupJson);

    _showSnackBar(context, loc.exportSuccess);
  }

  Future<void> _showImportFlow(
      BuildContext context, AppLocalizations loc) async {
    // First, pick file
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: loc.lbImport,
      type: FileType.custom,
      allowedExtensions: ['json', 'ewb'],
    );

    if (result == null || result.files.isEmpty) {
      _showSnackBar(context, loc.importCancelled);
      return;
    }

    final filePath = result.files.first.path;
    if (filePath == null) return;

    // Read file content to check if encrypted
    final file = File(filePath);
    final content = await file.readAsString();
    final backupService = BackupService();
    final isEncrypted = backupService.isEncrypted(content);

    // Show import options dialog
    final options = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => ImportDialog(isEncrypted: isEncrypted),
    );

    if (options == null) {
      _showSnackBar(context, loc.importCancelled);
      return;
    }

    final mode = options['mode'] as ImportMode;
    final password = options['password'] as String?;

    final userBloc = context.read<UserBloc>();
    if (userBloc.state is! UserLoadedState) return;
    final userId = (userBloc.state as UserLoadedState).user.id;

    try {
      final backupData =
          backupService.importFromJson(content, password: password);

      if (!backupService.validateBackup(backupData)) {
        _showSnackBar(context, loc.importError);
        return;
      }

      final walletBloc = context.read<WalletBloc>();

      if (mode == ImportMode.replace) {
        walletBloc.add(DeleteAllTransactionsEvent(userId));
        await Future.delayed(const Duration(milliseconds: 500));
      }

      int importedCount = 0;
      for (final txJson in backupData.transactions) {
        try {
          final transaction =
              TransactionParsingUtils.parseTransactionFromJson(txJson, userId);
          walletBloc.add(AddTransactionEvent(1, transaction));
          importedCount++;
        } catch (_) {}
      }

      _showSnackBar(context, loc.importSuccess(importedCount));

      walletBloc.add(LoadWalletDataEvent());
    } catch (e) {
      _showSnackBar(context, loc.importError);
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _submitChanges(BuildContext context) {
    if (!_pendingChanges) return;

    final settingsState = context.read<SettingsBloc>().state;
    if (settingsState is! SettingsLoadedState) return;

    final newPreferences = settingsState.preferences
        .copyWith(dataPreferences: _currentPreferences);
    _pendingChanges = false;

    context
        .read<SettingsBloc>()
        .add(UpdateUserPreferencesEvent(userPreferences: newPreferences));
  }
}
