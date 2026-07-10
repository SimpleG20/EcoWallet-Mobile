import 'package:flutter/material.dart';

import 'package:eco_wallet/features/settings/presentation/widgets/settings_sub_page_header.dart';
import 'package:eco_wallet/l10n/app_localizations.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SettingsSubPageHeader(
            title: loc.lbPrivacyPolicy,
            subtitle: loc.policySubTitle,
            complement: null,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
              clipBehavior: Clip.hardEdge,
              child: _buildPolicyContent(context, theme, loc),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyContent(BuildContext context, ThemeData theme, AppLocalizations loc) {
    final sections = [
      _PolicySection(
        icon: Icons.info_outline,
        title: loc.policyIntroTitle,
        content: loc.policyIntroContent,
      ),
      _PolicySection(
        icon: Icons.storage_outlined,
        title: loc.policyDataCollectionTitle,
        content: loc.policyDataCollectionContent,
      ),
      _PolicySection(
        icon: Icons.analytics_outlined,
        title: loc.policyDataUsageTitle,
        content: loc.policyDataUsageContent,
      ),
      _PolicySection(
        icon: Icons.security_outlined,
        title: loc.policySecurityTitle,
        content: loc.policySecurityContent,
      ),
      _PolicySection(
        icon: Icons.verified_user_outlined,
        title: loc.policyRightsTitle,
        content: loc.policyRightsContent,
      ),
      _PolicySection(
        icon: Icons.contact_mail_outlined,
        title: loc.policyContactTitle,
        content: loc.policyContactContent,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildLastUpdatedBanner(theme, loc),
        const SizedBox(height: 16),
        ...sections.map((section) => _buildSectionCard(section, theme)),
      ],
    );
  }

  Widget _buildLastUpdatedBanner(ThemeData theme, AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.update,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              loc.policyLastUpdated('December 29, 2024'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(_PolicySection section, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  section.icon,
                  size: 20,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            section.content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicySection {
  final IconData icon;
  final String title;
  final String content;

  _PolicySection({
    required this.icon,
    required this.title,
    required this.content,
  });
}
