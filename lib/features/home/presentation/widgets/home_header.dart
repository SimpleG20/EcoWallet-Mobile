import 'package:eco_wallet/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Header widget displaying welcome message and title.
///
/// Used in the wallet page to greet the user.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.welcomeText,
    required this.titleText,
  });

  final String welcomeText;
  final String titleText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Column(
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
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            context.read<AuthBloc>().add(LogOutEvent());
          },
          icon: Icon(
            Icons.logout,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        )
      ],
    );
  }
}
