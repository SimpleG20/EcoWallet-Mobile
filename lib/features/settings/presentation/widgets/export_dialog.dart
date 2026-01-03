import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Dialog for export options.
/// Returns a map with 'encrypted' (bool) and 'password' (String?) if user confirms,
/// or null if cancelled.
class ExportDialog extends StatefulWidget {
  final bool defaultEncrypted;

  const ExportDialog({
    super.key,
    this.defaultEncrypted = false,
  });

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  late bool _encrypted;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _encrypted = widget.defaultEncrypted;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(loc.lbExport),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.exportDialogDescription,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(loc.lbEncrypted),
              subtitle: Text(loc.hintEncryptedBackup),
              value: _encrypted,
              onChanged: (value) {
                setState(() {
                  _encrypted = value;
                  _errorText = null;
                });
              },
            ),
            if (_encrypted) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: loc.lbPassword,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  errorText: _errorText,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: loc.lbConfirmPassword,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                loc.passwordWarning,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
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
          onPressed: _onExport,
          child: Text(loc.lbExport),
        ),
      ],
    );
  }

  void _onExport() {
    final loc = AppLocalizations.of(context)!;

    if (_encrypted) {
      if (_passwordController.text.isEmpty) {
        setState(() => _errorText = loc.errorEmpty);
        return;
      }
      if (_passwordController.text.length < 6) {
        setState(() => _errorText = loc.errorPasswordTooShort);
        return;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() => _errorText = loc.errorPasswordMismatch);
        return;
      }
    }

    Navigator.of(context).pop({
      'encrypted': _encrypted,
      'password': _encrypted ? _passwordController.text : null,
    });
  }
}
