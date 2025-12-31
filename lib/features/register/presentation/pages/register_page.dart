import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/ui_data.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '/core/utils/app_validators.dart';
import '../../../../l10n/app_localizations.dart';

import '../../../../core/presentation/widgets/password_field.dart';
import '../../../../core/presentation/widgets/any_text_field.dart';
import '../../../../core/presentation/widgets/or_divider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true;
  bool _agreeTerms = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(theme, loc),
                  _buildFields(theme, loc),
                  const SizedBox(height: 16),
                  _buildAgreeTermsField(theme, loc),
                  const SizedBox(height: 24),
                  _buildCreateBtn(theme, loc),
                  _buildAlreadyHaveAccount(context, theme, loc)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: kTopPaddingEcoWalletLogo),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: theme.colorScheme.primaryContainer,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              height: 80,
              width: 80,
              child: Icon(
                Icons.wallet_outlined,
                color: theme.colorScheme.onPrimaryContainer,
                size: 48,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              loc.appTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              loc.loginWelcomeMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          loc.lbCreateAccount,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          loc.lbCreateAccountSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24)
      ],
    );
  }

  Widget _buildFields(ThemeData theme, AppLocalizations loc) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AnyTextField(
            label: loc.lbFullName,
            hintText: loc.hintFullName,
            controller: _nameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: (value) => AppValidators.isValidName(loc, value),
            prefixIcon: Icon(
              Icons.person_outline,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          AnyTextField(
            label: loc.lbEmail,
            hintText: loc.hintEmail,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) => AppValidators.isValidEmail(value, loc),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          PasswordField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            onToggleObscureText: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            label: loc.lbPassword,
            hintText: loc.hintPassword,
            validator: (value) => AppValidators.isValidPassword(value, loc),
            showRequirements: true,
          ),
          const SizedBox(height: 20),
          PasswordField(
            controller: _confirmPasswordController,
            obscureText: _obscurePassword,
            onToggleObscureText: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            label: loc.lbConfirmPassword,
            hintText: loc.hintConfirmPassword,
            validator: (value) {
              var result = AppValidators.isValidPassword(value, loc);
              if (result != null) {
                return result;
              }

              if (value != _passwordController.text) {
                return loc.errorPasswordMismatch;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCreateBtn(ThemeData theme, AppLocalizations loc) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: theme.colorScheme.primary,
        elevation: 4,
      ),
      onPressed: () => _submitRegister(theme, loc),
      child: Text(
        loc.lbCreateAccount,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildAlreadyHaveAccount(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      children: [
        const SizedBox(height: 24),
        const OrDivider(),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              loc.askAlreadyHaveAccount,
              style: theme.textTheme.bodyMedium,
            ),
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text(
                loc.lbSignIn,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAgreeTermsField(ThemeData theme, AppLocalizations loc) {
    return Row(
      children: [
        Checkbox(
          shape: CircleBorder(),
          value: _agreeTerms,
          onChanged: (value) {
            setState(() {
              _agreeTerms = value ?? false;
            });
          },
        ),
        Expanded(
          child: Text(
            loc.lbAgreeTerms,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  void _submitRegister(ThemeData theme, AppLocalizations loc) {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.errorAgreeTerms),
          backgroundColor: theme.colorScheme.error,
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
          SignUpEvent(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }
}
