import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eco_wallet/core/utils/password_utils.dart';
import 'package:eco_wallet/core/utils/app_validators.dart';

import '../bloc/settings_bloc.dart';
import '../widgets/settings_widgets.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../../l10n/app_localizations.dart';

enum EPasswordStates {
  changePasswords,
  waitingForConfirmation,
  newPasswordSet,
}

class PasswordChangePage extends StatefulWidget {
  const PasswordChangePage({super.key});

  @override
  State<PasswordChangePage> createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  bool _showCurrentPassword = false;
  bool _showNewsPassword = false;

  EPasswordStates _passwordState = EPasswordStates.changePasswords;

  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _currentPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
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
          return Center(child: Text(state.message ?? loc.errorUnknown));
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              SettingsSubPageHeader(
                title: loc.lbChangePassword,
                subtitle: loc.passwordSubTitle,
                complement: null,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SettingsCard(
                  child: SingleChildScrollView(
                    child: _buildPasswordState(context, theme, loc),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPasswordState(BuildContext context, ThemeData theme, AppLocalizations loc) {
    switch (_passwordState) {
      case EPasswordStates.changePasswords:
        return _buildChangePasswordOptions(context, theme, loc);
      case EPasswordStates.waitingForConfirmation:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _passwordState = EPasswordStates.changePasswords;
                  });
                },
                icon: Icon(Icons.arrow_back)),
            Expanded(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        );
      case EPasswordStates.newPasswordSet:
        return Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildChangePasswordOptions(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCurrentPasswordField(theme, loc),
            const Divider(),
            const SizedBox(height: 12),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildNewPasswordField(theme, loc),
                  const SizedBox(height: 24),

                  _buildConfirmPasswordField(theme, loc),
                  const SizedBox(height: 32),
                  // Submit Button
                  ElevatedButton(
                    onPressed: () => _submitChangePassword(context, loc),
                    child: Text(loc.btnApply),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPasswordField(ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.lbCurrentPassword, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline, color: theme.colorScheme.primary),
            suffixIcon: IconButton(
              icon: Icon(_showCurrentPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: theme.colorScheme.primary),
              onPressed: () {
                setState(() {
                  _showCurrentPassword = !_showCurrentPassword;
                });
              },
            ),
          ),
          obscureText: !_showCurrentPassword,
          controller: _currentPasswordController,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 3),
                    content: Text(loc.msgFeatureComingSoon),
                  ),
                );
                // setState(() {
                //   _newPasswordController.clear();
                //   _currentPasswordController.clear();
                //   _confirmNewPasswordController.clear();
                //   _passwordState = EPasswordStates.waitingForConfirmation;
                // });
              },
              child: Text(
                loc.askForgotPassword,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNewPasswordField(ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.lbNewPassword, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(_showNewsPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: theme.colorScheme.primary),
              onPressed: () {
                setState(() {
                  _showNewsPassword = !_showNewsPassword;
                });
              },
            ),
          ),
          obscureText: !_showNewsPassword,
          controller: _newPasswordController,
          validator: (value) {
            return AppValidators.isValidPassword(loc, value);
          },
        ),
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
              loc.pwRequirementLength,
              _newPasswordController.text.length >= 8,
            ),
            _buildPasswordCriteriaRow(
              loc.pwRequirementUppercase,
              RegExp(r'[A-Z]').hasMatch(_newPasswordController.text),
            ),
            _buildPasswordCriteriaRow(
              loc.pwRequirementNumber,
              RegExp(r'[0-9]').hasMatch(_newPasswordController.text),
            ),
            _buildPasswordCriteriaRow(
              loc.pwRequirementSpecial,
              RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_newPasswordController.text),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField(ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.lbConfirmNewPassword, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(_showNewsPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: theme.colorScheme.primary),
              onPressed: () {
                setState(() {
                  _showNewsPassword = !_showNewsPassword;
                });
              },
            ),
          ),
          obscureText: !_showNewsPassword,
          controller: _confirmNewPasswordController,
          validator: (value) {
            var passwordValidation = AppValidators.isValidPassword(loc, value);
            if (passwordValidation != null) {
              return passwordValidation;
            }
            if (value != _newPasswordController.text) {
              return loc.errorPasswordMismatch;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordCriteriaRow(String criteria, bool isMet) {
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

  void _submitChangePassword(BuildContext context, AppLocalizations loc) {
    if (!_formKey.currentState!.validate()) return;

    if (_currentPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.errorEnterCurrentPassword),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (_currentPasswordController.text == _newPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.errorSameAsCurrentPassword),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final bloc = context.read<UserBloc>();
    final userState = bloc.state;
    if (userState is! UserLoadedState) return;

    final newUserConfig = userState.user.copyWith(
      password: PasswordUtils.hashPassword(_newPasswordController.text, userState.user.email),
    );

    bloc.add(UpdateUserEvent(user: newUserConfig));

    _newPasswordController.clear();
    _currentPasswordController.clear();
    _confirmNewPasswordController.clear();
  }
}
