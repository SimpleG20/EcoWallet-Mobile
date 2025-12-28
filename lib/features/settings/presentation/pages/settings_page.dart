import 'package:eco_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../widgets/settings_container.dart';
import '../widgets/settings_option_item.dart';
import 'help_page.dart';
import 'terms_page.dart';
import 'policy_page.dart';
import 'feedback_page.dart';
import 'personal_page.dart';
import 'apperance_page.dart';
import 'budget_info_page.dart';
import 'manage_data_page.dart';
import 'notifications_page.dart';
import 'password_change_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Widget? _page;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: _page ?? _buildBody(context, loc, theme),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations loc, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context, loc, theme),
        _buildSettingsOptions(context, loc, theme),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations loc, ThemeData theme) {
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
                        backgroundColor: theme.colorScheme.primary.withAlpha(50),
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
                            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
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

  Widget _buildSettingsOptions(BuildContext context, AppLocalizations loc, ThemeData theme) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
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
              _buildLegalSection(context, loc, theme),
              const SizedBox(height: 40),
              _buildLogoutBtn(context, loc, theme),
              const SizedBox(height: 20),
              _buildDeleteAccountBtn(context, loc, theme),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context, AppLocalizations loc, ThemeData theme) {
    return SettingsContainer(
      sectionLabel: loc.lbAccount,
      options: [
        SettingsOptionItem(
          icon: Icons.person_outline,
          title: loc.lbPersonalInfo,
          onTap: () => _showScreen(context, PersonalPage()),
        ),
        const SizedBox(height: 8),
        SettingsOptionItem(
          icon: Icons.analytics_outlined,
          title: loc.lbBudgetInfo,
          onTap: () => _showScreen(context, BudgetInfoPage()),
        ),
        const SizedBox(height: 8),
        SettingsOptionItem(
          icon: Icons.data_object_outlined,
          title: loc.lbManageData,
          onTap: () => _showScreen(context, ManageDataPage()),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(BuildContext context, AppLocalizations loc, ThemeData theme) {
    return SettingsContainer(
      sectionLabel: loc.lbPreferences,
      options: [
        SettingsOptionItem(
          icon: Icons.notifications,
          title: loc.lbNotifications,
          onTap: () => _showScreen(context, NotificationsPage()),
        ),
        const SizedBox(height: 8),
        SettingsOptionItem(
          icon: Icons.color_lens,
          title: loc.lbAppearance,
          onTap: () => _showScreen(context, ApperancePage()),
        ),
      ],
    );
  }

  Widget _buildSecuritySection(BuildContext context, AppLocalizations loc, ThemeData theme) {
    return SettingsContainer(
      sectionLabel: loc.lbSecurity,
      options: [
        SettingsOptionItem(
          icon: Icons.lock_outline,
          title: loc.lbChangePassword,
          onTap: () => _showScreen(context, PasswordChangePage()),
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context, AppLocalizations loc, ThemeData theme) {
    return SettingsContainer(
      sectionLabel: loc.lbSupport,
      options: [
        SettingsOptionItem(
          icon: Icons.help_outline,
          title: loc.lbHelpCenter,
          onTap: () => _showScreen(context, HelpPage()),
        ),
        const SizedBox(height: 8),
        SettingsOptionItem(
          icon: Icons.feedback_outlined,
          title: loc.lbSendFeedback,
          onTap: () => _showScreen(context, FeedbackPage()),
        ),
      ],
    );
  }

  Widget _buildLegalSection(BuildContext context, AppLocalizations loc, ThemeData theme) {
    return SettingsContainer(
      sectionLabel: loc.lbAboutLegal,
      options: [
        SettingsOptionItem(
          icon: Icons.description_outlined,
          title: loc.lbTermsOfService,
          onTap: () => _showScreen(context, TermsPage()),
        ),
        const SizedBox(height: 8),
        SettingsOptionItem(
          icon: Icons.privacy_tip_outlined,
          title: loc.lbPrivacyPolicy,
          onTap: () => _showScreen(context, PolicyPage()),
        ),
      ],
    );
  }

  Widget _buildLogoutBtn(BuildContext context, AppLocalizations loc, ThemeData theme) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.secondaryContainer,
        foregroundColor: theme.colorScheme.onSecondaryContainer,
      ),
      onPressed: () {
        // context.read<AuthenticationBloc>().add(LogoutEvent());
      },
      child: Text(loc.lbLogout),
    );
  }

  Widget _buildDeleteAccountBtn(BuildContext context, AppLocalizations loc, ThemeData theme) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.errorContainer,
        foregroundColor: theme.colorScheme.onErrorContainer,
      ),
      child: Text(loc.deleteAccount),
      onPressed: () {
        // Add your delete account logic here
      },
    );
  }

  void _showScreen(BuildContext context, Widget child) {
    setState(() {
      _page = child;
    });
  }
}
