import 'package:flutter/material.dart';

class SettingsSectionList extends StatelessWidget {
  final List<Widget> sections;
  final ThemeData theme;

  const SettingsSectionList({
    super.key,
    required this.sections,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: sections.length,
      separatorBuilder: (context, index) => Divider(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: sections[index],
        );
      },
    );
  }
}
