import 'package:eco_wallet/features/settings/presentation/pages/budget_info_page.dart';
import 'package:eco_wallet/features/settings/presentation/pages/notifications_page.dart';
import 'package:eco_wallet/features/settings/presentation/pages/password_change_page.dart';
import 'package:eco_wallet/features/settings/presentation/pages/terms_page.dart';
import 'package:eco_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart' as di;
import '../bloc/settings_bloc.dart';
import '../widgets/settings_container.dart';
import '../widgets/settings_option_item.dart';
import 'appearance_page.dart';
import 'feedback_page.dart';
import 'help_page.dart';
import 'manage_data_page.dart';
import 'personal_page.dart';
import 'policy_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => di.sl<SettingsBloc>()..add(LoadSettingsEvent()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primaryContainer,
        ),
        body: BlocBuilder<SettingsBloc, BaseSettingsState>(
          builder: (context, state) {
            if (state is SettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SettingsError) {
              return Center(
                child: Text(
                  state.message ?? "Unknown error", //loc.errorUnknown,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              );
            }

            if (state is SettingsLoaded) {
              return _buildBody(context, loc, theme);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
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
          onTap: () => _navigateToPage(PersonalPage()),
        ),
        const SizedBox(height: 8),
        SettingsOptionItem(
          icon: Icons.analytics_outlined,
          title: loc.lbBudgetInfo,
          onTap: () => _navigateToPage(BudgetInfoPage()),
        ),
        const SizedBox(height: 8),
        SettingsOptionItem(
          icon: Icons.data_object_outlined,
          title: loc.lbManageData,
          onTap: () => _navigateToPage(ManageDataPage()),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(BuildContext context, AppLocalizations loc, ThemeData theme) {
    return SettingsContainer(
      sectionLabel: loc.lbPreferences,
      options: [
        SettingsOptionItem(
          icon: Icons.notifications_outlined,
          title: loc.lbNotifications,
          onTap: () => _navigateToPage(NotificationsPage()),
        ),
        const SizedBox(height: 8),
        SettingsOptionItem(
          icon: Icons.color_lens_outlined,
          title: loc.lbAppearance,
          onTap: () => _navigateToPage(AppearancePage()),
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
          onTap: () => _navigateToPage(PasswordChangePage()),
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
          onTap: () => _navigateToPage(HelpPage()),
        ),
        const SizedBox(height: 8),
        SettingsOptionItem(
          icon: Icons.feedback_outlined,
          title: loc.lbSendFeedback,
          onTap: () => _navigateToPage(FeedbackPage()),
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
          onTap: () => _navigateToPage(TermsPage()),
        ),
        const SizedBox(height: 8),
        SettingsOptionItem(
          icon: Icons.privacy_tip_outlined,
          title: loc.lbPrivacyPolicy,
          onTap: () => _navigateToPage(PolicyPage()),
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
      child: Text(loc.lbLogout),
      onPressed: () {},
    );
  }

  Widget _buildDeleteAccountBtn(BuildContext context, AppLocalizations loc, ThemeData theme) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.errorContainer,
        foregroundColor: theme.colorScheme.onErrorContainer,
      ),
      child: Text(loc.deleteAccount),
      onPressed: () {},
    );
  }

  void _navigateToPage(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
