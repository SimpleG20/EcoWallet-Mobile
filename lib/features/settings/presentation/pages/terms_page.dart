import 'package:flutter/material.dart';

import '../widgets/settings_sub_page_header.dart';
import '../../../../l10n/app_localizations.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Column(
      children: [
        SettingsSubPageHeader(
          title: loc.lbTermsOfService,
          subtitle: loc.termsSubTitle,
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
            child: _buildTermsContent(context, theme, loc),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsContent(BuildContext context, ThemeData theme, AppLocalizations loc) {
    final sections = [
      _TermsSection(
        number: '1',
        title: loc.termsAcceptanceTitle,
        content: loc.termsAcceptanceContent,
        icon: Icons.handshake_outlined,
      ),
      _TermsSection(
        number: '2',
        title: loc.termsServiceTitle,
        content: loc.termsServiceContent,
        icon: Icons.miscellaneous_services_outlined,
      ),
      _TermsSection(
        number: '3',
        title: loc.termsAccountTitle,
        content: loc.termsAccountContent,
        icon: Icons.account_circle_outlined,
      ),
      _TermsSection(
        number: '4',
        title: loc.termsContentTitle,
        content: loc.termsContentContent,
        icon: Icons.folder_outlined,
      ),
      _TermsSection(
        number: '5',
        title: loc.termsProhibitedTitle,
        content: loc.termsProhibitedContent,
        icon: Icons.block_outlined,
      ),
      _TermsSection(
        number: '6',
        title: loc.termsLiabilityTitle,
        content: loc.termsLiabilityContent,
        icon: Icons.gavel_outlined,
      ),
      _TermsSection(
        number: '7',
        title: loc.termsChangesTitle,
        content: loc.termsChangesContent,
        icon: Icons.edit_document,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildLastUpdatedBanner(theme, loc),
        const SizedBox(height: 16),
        ...sections.map((section) => _buildSectionCard(section, theme)),
        const SizedBox(height: 16),
        _buildAcceptanceFooter(theme, loc),
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
              loc.termsLastUpdated('December 29, 2024'),
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

  Widget _buildSectionCard(_TermsSection section, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                section.number,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Row(
            children: [
              Icon(
                section.icon,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  section.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                section.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcceptanceFooter(ThemeData theme, AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.check_circle_outline,
              color: theme.colorScheme.primary,
              size: 40,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EcoWallet',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '© 2024 EcoWallet. All rights reserved.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TermsSection {
  final String number;
  final String title;
  final String content;
  final IconData icon;

  _TermsSection({
    required this.number,
    required this.title,
    required this.content,
    required this.icon,
  });
}
