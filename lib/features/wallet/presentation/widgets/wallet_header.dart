import 'package:flutter/material.dart';

/// Header widget displaying welcome message and title.
/// 
/// Used in the wallet page to greet the user.
class WalletHeader extends StatelessWidget {
  const WalletHeader({
    super.key,
    required this.welcomeText,
    required this.titleText,
  });

  final String welcomeText;
  final String titleText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          welcomeText,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          titleText,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}
