import 'package:flutter/material.dart';

import '../../../../core/utils/app_validators.dart';
import '../../../../l10n/app_localizations.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.onToggleObscureText,
    this.validator,
    this.label,
    this.hintText,
    this.showRequirements = false,
  });

  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleObscureText;
  final bool showRequirements;
  final String? label;
  final String? hintText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? loc.lbPassword,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: hintText ?? loc.hintPassword,
            prefixIcon: Icon(
              Icons.lock_outline,
              color: theme.colorScheme.primary,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: theme.colorScheme.primary,
              ),
              onPressed: onToggleObscureText,
            ),
          ),
          obscureText: obscureText,
          textInputAction: TextInputAction.done,
          controller: controller,
          validator: (value) => AppValidators.isValidPassword(value, loc),
        ),
        if (showRequirements) ...[
          const SizedBox(height: 8),
          Text(
            loc.passwordRequirements,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(180),
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: [
              _buildPasswordCriteriaRow(
                context,
                loc.pwRequirementLength,
                controller.text.length >= 8,
              ),
              _buildPasswordCriteriaRow(
                context,
                loc.pwRequirementUppercase,
                RegExp(r'[A-Z]').hasMatch(controller.text),
              ),
              _buildPasswordCriteriaRow(
                context,
                loc.pwRequirementNumber,
                RegExp(r'[0-9]').hasMatch(controller.text),
              ),
              _buildPasswordCriteriaRow(
                context,
                loc.pwRequirementSpecial,
                RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(controller.text),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPasswordCriteriaRow(BuildContext context, String criteria, bool isMet) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isMet ? theme.colorScheme.primary : theme.colorScheme.onSurface.withAlpha(150),
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          criteria,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isMet ? theme.colorScheme.primary : theme.colorScheme.onSurface.withAlpha(180),
          ),
        ),
      ],
    );
  }
}
