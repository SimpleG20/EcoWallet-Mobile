import 'package:eco_wallet/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:eco_wallet/features/home/presentation/pages/main_page.dart';
import 'package:eco_wallet/features/login/presentation/pages/login_page.dart';
import 'package:eco_wallet/features/register/presentation/pages/register_page.dart';
import 'package:eco_wallet/features/transactions/presentation/pages/transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          path: AppRoutes.home,
          builder: (context, state) => const MainPage(),
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
