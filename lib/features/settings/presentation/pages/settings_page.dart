import 'package:eco_wallet/core/constants/ui_data.dart';
import 'package:eco_wallet/features/settings/presentation/widgets/settings_option_item.dart';
import 'package:eco_wallet/features/settings/presentation/widgets/settings_container.dart';
import 'package:eco_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: _buildBody(context, loc, theme),
    );
  }

  Widget _buildBody(
      BuildContext context, AppLocalizations loc, ThemeData theme) {
    return Column(
      children: [
        _buildHeader(context, loc, theme),
        _buildSettingsOptions(context, loc, theme)
      ],
    );
  }

  Widget _buildHeader(
      BuildContext context, AppLocalizations loc, ThemeData theme) {
    return SizedBox(
      height: 180,
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
                Text(
                  loc.lbSettings,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  loc.settingsSubTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 16),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor:
                            theme.colorScheme.primary.withAlpha(50),
                        child: Icon(
                          //state.profilePictureUrl != null ? --- IGNORE ---
                          Icons.person_outline,
                          color: theme.colorScheme.primary,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Fulano", //state.name,
                            style: theme.textTheme.titleMedium,
                          ),
                          Text(
                            "example@email.com", //state.email,
                            style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOptions(
      BuildContext context, AppLocalizations loc, ThemeData theme) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              _buildAccountSection(context, loc, theme),
              const SizedBox(height: 20),
              _buildPreferencesSection(context, loc, theme),
              const SizedBox(height: 20),
              _buildSecuritySection(context, loc, theme),
              const SizedBox(height: 20),
              _buildSupportSection(context, loc, theme),
              const SizedBox(height: 20),
              _buildLogoutBtn(context, loc, theme),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection(
      BuildContext context, AppLocalizations loc, ThemeData theme) {
    return SettingsContainer(
      sectionLabel: loc.lbAccount,
      options: [
        SettingsOptionItem(
            icon: Icons.person_outline,
            title: loc.lbPersonalInfo,
            onTap: () => _openModal(
                context, Center() /* pass the widget you want to show here */)),
        SettingsOptionItem(
          icon: Icons.notifications,
          title: loc.lbBudgetInfo,
          onTap: () => _openModal(
              context, Center() /* pass the widget you want to show here */),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(
      BuildContext context, AppLocalizations loc, ThemeData theme) {
    return SettingsContainer(
      sectionLabel: loc.lbPreferences,
      options: [
        SettingsOptionItem(
          icon: Icons.notifications,
          title: loc.lbNotifications,
          onTap: () => _openModal(
              context, Center() /* pass the widget you want to show here */),
        ),
        SettingsOptionItem(
          icon: Icons.color_lens,
          title: loc.lbAppearance,
          onTap: () => _openModal(
              context, Center() /* pass the widget you want to show here */),
        ),
      ],
    );
  }

  Widget _buildSecuritySection(
      BuildContext context, AppLocalizations loc, ThemeData theme) {
    return SettingsContainer(
      sectionLabel: loc.lbSecurity,
      options: [
        SettingsOptionItem(
          icon: Icons.lock_outline,
          title: loc.lbChangePassword,
          onTap: () => _openModal(
              context, Center() /* pass the widget you want to show here */),
        ),
        SettingsOptionItem(
          icon: Icons.fingerprint,
          title: loc.lbBiometrics,
          onTap: () => _openModal(
              context, Center() /* pass the widget you want to show here */),
        ),
      ],
    );
  }

  Widget _buildSupportSection(
      BuildContext context, AppLocalizations loc, ThemeData theme) {
    return SettingsContainer(
      sectionLabel: loc.lbSupport,
      options: [
        SettingsOptionItem(
          icon: Icons.help_outline,
          title: loc.lbHelpCenter,
          onTap: () => _openModal(
              context, Center() /* pass the widget you want to show here */),
        ),
        SettingsOptionItem(
          icon: Icons.feedback_outlined,
          title: loc.lbSendFeedback,
          onTap: () => _openModal(
              context, Center() /* pass the widget you want to show here */),
        ),
      ],
    );
  }

  Widget _buildLogoutBtn(
      BuildContext context, AppLocalizations loc, ThemeData theme) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        backgroundColor: theme.colorScheme.onErrorContainer,
        foregroundColor: theme.colorScheme.error,
      ),
      onPressed: () {
        // context.read<AuthenticationBloc>().add(LogoutEvent());
      },
      child: Text(loc.lbLogout),
    );
  }

  void _openModal(BuildContext context, Widget child) {
    var mediaQuery = MediaQuery.of(context);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: mediaQuery.size.height * kModalHeightFactor,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32.0),
              topRight: Radius.circular(32.0),
            ),
          ),
          child: child,
        );
      },
    );
  }
}
