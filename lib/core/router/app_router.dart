import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:eco_wallet/features/settings/presentation/pages/help_page.dart';
import 'package:eco_wallet/features/settings/presentation/pages/terms_page.dart';
import 'package:eco_wallet/features/settings/presentation/pages/policy_page.dart';
import 'package:eco_wallet/features/settings/presentation/pages/personal_page.dart';
import 'package:eco_wallet/features/settings/presentation/pages/feedback_page.dart';
import 'package:eco_wallet/features/settings/presentation/pages/appearance_page.dart';
import 'package:eco_wallet/features/settings/presentation/pages/budget_info_page.dart';
import 'package:eco_wallet/features/settings/presentation/pages/manage_data_page.dart';
import 'package:eco_wallet/features/settings/presentation/pages/notifications_page.dart';
import 'package:eco_wallet/features/settings/presentation/pages/password_change_page.dart';

import 'package:eco_wallet/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:eco_wallet/features/home/presentation/pages/main_page.dart';
import 'package:eco_wallet/features/login/presentation/pages/login_page.dart';
import 'package:eco_wallet/features/register/presentation/pages/register_page.dart';
import 'package:eco_wallet/features/transactions/presentation/pages/transactions_page.dart';

import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  final AuthBloc authBloc;
  late final GoRouter router;

  AppRouter({required this.authBloc}) {
    router = GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: _guardRoute,
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const MainPage(),
        ),
        GoRoute(
          path: AppRoutes.wallet,
          builder: (context, state) => const TransactionWalletPage(),
        ),
        GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) {
            return const Scaffold(
              body: Center(
                child: Text('Settings Page - To be implemented'),
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.settingsProfile,
          builder: (context, state) => const PersonalPage(),
        ),
        GoRoute(
          path: AppRoutes.settingsBudget,
          builder: (context, state) => const BudgetInfoPage(),
        ),
        GoRoute(
          path: AppRoutes.settingsData,
          builder: (context, state) => const ManageDataPage(),
        ),
        GoRoute(
          path: AppRoutes.settingsNotifications,
          builder: (context, state) => const NotificationsPage(),
        ),
        GoRoute(
          path: AppRoutes.settingsAppearance,
          builder: (context, state) => const AppearancePage(),
        ),
        GoRoute(
          path: AppRoutes.settingsPassword,
          builder: (context, state) => const PasswordChangePage(),
        ),
        GoRoute(
          path: AppRoutes.settingsHelper,
          builder: (context, state) => const HelpPage(),
        ),
        GoRoute(
          path: AppRoutes.settingsFeedback,
          builder: (context, state) => const FeedbackPage(),
        ),
        GoRoute(
          path: AppRoutes.settingsTerms,
          builder: (context, state) => const TermsPage(),
        ),
        GoRoute(
          path: AppRoutes.settingsPrivacy,
          builder: (context, state) => const PolicyPage(),
        ),
      ],
    );
  }

  String? _guardRoute(BuildContext context, GoRouterState state) {
    final authState = authBloc.state;
    final isOnSplash = state.matchedLocation == AppRoutes.splash;
    final isAuthRoute = state.matchedLocation == AppRoutes.login || state.matchedLocation == AppRoutes.register;

    // Loading or Initial state → stay on splash
    if (authState is AuthLoadingState || authState is AuthInitialState) {
      return isOnSplash ? null : AppRoutes.splash;
    }

    // Error state → redirect to login
    if (authState is AuthErrorState && !isAuthRoute) {
      return AppRoutes.login;
    }

    // Not authenticated → redirect to login
    if (authState is AuthUnauthenticatedState && !isAuthRoute) {
      return AppRoutes.login;
    }

    // Authenticated but on auth page or splash → redirect to home
    if (authState is AuthAuthenticatedState && (isAuthRoute || isOnSplash)) {
      return AppRoutes.home;
    }

    return null; // No redirect
  }
}
