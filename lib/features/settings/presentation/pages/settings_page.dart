import 'package:eco_wallet/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:eco_wallet/features/user/presentation/bloc/user_bloc.dart';
import 'package:eco_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/widgets/user_avatar_circle.dart';
import '../../../../core/router/app_routes.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/settings_container.dart';
import '../widgets/settings_option_item.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    // Trigger settings load when the page opens
    // SettingsBloc is provided globally via main.dart
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsBloc>().add(LoadSettingsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<SettingsBloc, BaseSettingsState>(
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
            return _buildBody(context, loc, theme, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations loc,
    ThemeData theme,
    SettingsLoadedState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context, loc, theme, state),
        _buildSettingsOptions(context, loc, theme),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations loc,
    ThemeData theme,
    SettingsLoadedState state,
  ) {
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
                      UserAvatarCircle(imageUrl: state.user.imageUrl),
                      const SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.user.fullName,
                            style: theme.textTheme.titleMedium,
                          ),
                          Text(
                            state.user.email,
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

  Widget _buildSettingsOptions(
    BuildContext context,
    AppLocalizations loc,
    ThemeData theme,
  ) {
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
          onTap: () => _navigateToPage(AppRoutes.settingsProfile),
        ),
        const SizedBox(height: 8),
        SettingsOptionItem(
          icon: Icons.analytics_outlined,
          title: loc.lbBudgetInfo,
          onTap: () => _navigateToPage(AppRoutes.settingsBudget),
        ),
        const SizedBox(height: 8),
        SettingsOptionItem(
          icon: Icons.data_object_outlined,
          title: loc.lbManageData,
          onTap: () => _navigateToPage(AppRoutes.settingsData),
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
          onTap: () => _navigateToPage(AppRoutes.settingsNotifications),
        ),
        const SizedBox(height: 8),
        SettingsOptionItem(
          icon: Icons.color_lens_outlined,
          title: loc.lbAppearance,
          onTap: () => _navigateToPage(AppRoutes.settingsAppearance),
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
          onTap: () => _navigateToPage(AppRoutes.settingsPassword),
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
          onTap: () => _navigateToPage(AppRoutes.settingsHelper),
        ),
        const SizedBox(height: 8),
        SettingsOptionItem(
          icon: Icons.feedback_outlined,
          title: loc.lbSendFeedback,
          onTap: () => _navigateToPage(AppRoutes.settingsFeedback),
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
          onTap: () => _navigateToPage(AppRoutes.settingsTerms),
        ),
        const SizedBox(height: 8),
        SettingsOptionItem(
          icon: Icons.privacy_tip_outlined,
          title: loc.lbPrivacyPolicy,
          onTap: () => _navigateToPage(AppRoutes.settingsPrivacy),
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
      onPressed: () {
        context.read<AuthBloc>().add(LogOutEvent());
      },
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
        final state = context.read<SettingsBloc>().state;
        if (state is! SettingsLoadedState) return;
        context.read<UserBloc>().add(DeleteUserEvent(id: state.user.id));
      },
    );
  }

  void _navigateToPage(String pageRoute) {
    context.push(pageRoute);
  }
}
