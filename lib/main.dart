import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/home/presentation/pages/main_page.dart';
import 'features/login/presentation/pages/login_page.dart';
import 'injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import '/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await di.init();
    runApp(const EcoWalletApp());
  } catch (e) {
    // Log the error for debugging
    debugPrint('Failed to initialize app: $e');
    runApp(const ErrorApp());
  }
}

class EcoWalletApp extends StatelessWidget {
  const EcoWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoWallet',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('pt'),
      ],
      home: BlocProvider<AuthBloc>(
        create: (context) => di.sl<AuthBloc>()..add(AppStartedEvent()),
        child: BlocBuilder<AuthBloc, BaseAuthState>(
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return const Scaffold(
                body: Center(
                  // TODO: Splash screen
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is AuthAuthenticatedState) {
              return const MainPage();
            }

            if (state is AuthUnauthenticatedState) {
              // TODO: Check if is first time user to show onboarding
              return const LoginPage();
            }

            if (state is AuthErrorState) {
              return Scaffold(
                body: Center(
                  child: Text('Error: ${state.message ?? "Unknown error"}'),
                ),
              );
            }

            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoWallet - Error',
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Failed to initialize app',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please restart the app. If the problem persists, contact support.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
