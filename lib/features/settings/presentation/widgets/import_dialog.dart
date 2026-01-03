import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/usecases/import_data.dart';

/// Dialog for import options.
/// Returns a map with 'mode' (ImportMode), 'password' (String?), and 'needsPassword' (bool),
/// or null if cancelled.
class ImportDialog extends StatefulWidget {
  final bool isEncrypted;

  const ImportDialog({
    super.key,
    required this.isEncrypted,
  });

  @override
  State<ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends State<ImportDialog> {
  ImportMode _mode = ImportMode.merge;
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(loc.lbImport),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.importDialogDescription,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              loc.importModeTitle,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            RadioListTile<ImportMode>(
              title: Text(loc.importModeMerge),
              subtitle: Text(loc.importModeMergeHint),
              value: ImportMode.merge,
              groupValue: _mode,
              onChanged: (value) => setState(() => _mode = value!),
            ),
            RadioListTile<ImportMode>(
              title: Text(loc.importModeReplace),
              subtitle: Text(loc.importModeReplaceHint),
              value: ImportMode.replace,
              groupValue: _mode,
              onChanged: (value) => setState(() => _mode = value!),
            ),
            if (_mode == ImportMode.replace) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: theme.colorScheme.onErrorContainer),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        loc.importReplaceWarning,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (widget.isEncrypted) ...[
              const SizedBox(height: 16),
              Text(
                loc.encryptedFileDetected,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: loc.lbPassword,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(loc.btnCancel),
        ),
        FilledButton(
          onPressed: _onImport,
          child: Text(loc.lbImport),
        ),
      ],
    );
  }

  void _onImport() {
    Navigator.of(context).pop({
      'mode': _mode,
      'password': widget.isEncrypted ? _passwordController.text : null,
    });
  }
}
