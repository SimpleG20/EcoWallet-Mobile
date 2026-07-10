import 'package:flutter/material.dart';

import 'package:eco_wallet/features/settings/presentation/widgets/settings_sub_page_header.dart';
import 'package:eco_wallet/features/settings/presentation/widgets/settings_section_list.dart';
import 'package:eco_wallet/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:eco_wallet/l10n/app_localizations.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final _searchController = TextEditingController();
  final Set<int> _expandedItems = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            title: loc.lbHelpCenter,
            subtitle: loc.helpSubTitle,
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
              child: _buildHelpContent(context, theme, loc),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpContent(BuildContext context, ThemeData theme, AppLocalizations loc) {
    final sections = [
      _buildSearchSection(theme, loc),
      _buildFaqSection(theme, loc),
      _buildContactSection(theme, loc),
      _buildVersionSection(theme, loc),
    ];

    return SettingsSectionList(sections: sections, theme: theme);
  }

  Widget _buildSearchSection(ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: loc.helpSearchHint,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildFaqSection(ThemeData theme, AppLocalizations loc) {
    final faqItems = [
      _FaqItem(
        question: loc.helpFaqAddTransaction,
        answer: loc.helpFaqAddTransactionAnswer,
        icon: Icons.add_circle_outline,
      ),
      _FaqItem(
        question: loc.helpFaqEditDelete,
        answer: loc.helpFaqEditDeleteAnswer,
        icon: Icons.edit_outlined,
      ),
      _FaqItem(
        question: loc.helpFaqCategories,
        answer: loc.helpFaqCategoriesAnswer,
        icon: Icons.category_outlined,
      ),
      _FaqItem(
        question: loc.helpFaqBackup,
        answer: loc.helpFaqBackupAnswer,
        icon: Icons.cloud_upload_outlined,
      ),
      _FaqItem(
        question: loc.helpFaqLanguage,
        answer: loc.helpFaqLanguageAnswer,
        icon: Icons.language_outlined,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(title: loc.helpFaqTitle),
        const SizedBox(height: 12),
        ...faqItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return _buildFaqTile(index, item, theme);
        }),
      ],
    );
  }

  Widget _buildFaqTile(int index, _FaqItem item, ThemeData theme) {
    final isExpanded = _expandedItems.contains(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded ? theme.colorScheme.primary.withValues(alpha: 0.5) : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedItems.remove(index);
                } else {
                  _expandedItems.add(index);
                }
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      item.icon,
                      size: 20,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.question,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: isExpanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.answer,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(title: loc.helpContactTitle),
        const SizedBox(height: 8),
        Text(
          loc.helpContactDescription,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        _buildContactButton(
          theme,
          Icons.email_outlined,
          loc.helpContactEmail,
          () {
            // TODO: Implement email support
          },
        ),
        const SizedBox(height: 8),
        _buildContactButton(
          theme,
          Icons.chat_outlined,
          loc.helpContactChat,
          () {
            // TODO: Implement live chat
          },
        ),
      ],
    );
  }

  Widget _buildContactButton(ThemeData theme, IconData icon, String label, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: FittedBox(child: Text(label)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildVersionSection(ThemeData theme, AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            '${loc.helpVersion}: 1.0.0',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;
  final IconData icon;

  _FaqItem({
    required this.question,
    required this.answer,
    required this.icon,
  });
}
