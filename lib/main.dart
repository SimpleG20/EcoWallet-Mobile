import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/router/app_router.dart';
import 'core/services/notification_service.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/settings/domain/enums/color_blind_mode.dart';
import 'features/settings/domain/enums/font_size_preference.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/user/presentation/bloc/user_bloc.dart';
import 'features/wallet/presentation/bloc/wallet_bloc.dart';
import 'injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import '/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await di.init();
    await di.sl<NotificationService>().init();
    // Dispatch AppStartedEvent immediately after DI initialization
    di.sl<AuthBloc>().add(AppStartedEvent());
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: di.sl<AuthBloc>()),
        BlocProvider<UserBloc>.value(value: di.sl<UserBloc>()),
        BlocProvider<SettingsBloc>.value(value: di.sl<SettingsBloc>()),
        BlocProvider<WalletBloc>(create: (_) => di.sl<WalletBloc>()),
      ],
      child: const _AuthUserSyncWrapper(),
    );
  }
}

/// Wrapper widget that synchronizes AuthBloc and UserBloc states.
/// It checks the initial auth state and continues listening for future changes.
class _AuthUserSyncWrapper extends StatefulWidget {
  const _AuthUserSyncWrapper();

  @override
  State<_AuthUserSyncWrapper> createState() => _AuthUserSyncWrapperState();
}

class _AuthUserSyncWrapperState extends State<_AuthUserSyncWrapper> {
  @override
  void initState() {
    super.initState();
    // Check if already authenticated on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncUserFromAuthState(context.read<AuthBloc>().state);
    });
  }

  void _syncUserFromAuthState(BaseAuthState state) {
    if (state is AuthAuthenticatedState) {
      context.read<UserBloc>().add(LoadUserEvent(id: state.userId));
      context.read<SettingsBloc>().add(LoadSettingsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, BaseAuthState>(
      listener: (context, state) => _syncUserFromAuthState(state),
      child: BlocBuilder<SettingsBloc, BaseSettingsState>(
        buildWhen: (previous, current) => _conditionsToRebuild(previous, current),
        builder: (context, settingsState) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              _getTextScaleFactor(settingsState),
            ),
          ),
          child: ColorFiltered(
            colorFilter: AppTheme.getColorFilter(
              settingsState is SettingsLoadedState
                  ? settingsState.preferences.appearancePreferences.colorBlindMode
                  : ColorBlindMode.none,
            ),
            child: MaterialApp.router(
              title: 'EcoWallet',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: settingsState is SettingsLoadedState
                  ? settingsState.preferences.appearancePreferences.flutterThemeMode
                  : ThemeMode.system,
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
              routerConfig: di.sl<AppRouter>().router,
            ),
          ),
        ),
      ),
    );
  }

  double _getTextScaleFactor(BaseSettingsState state) {
    if (state is SettingsLoadedState) {
      return AppTheme.getTextScaleFactor(state.preferences.appearancePreferences.fontSize);
    }
    return AppTheme.getTextScaleFactor(FontSizePreference.medium);
  }

  bool _conditionsToRebuild(BaseSettingsState previous, BaseSettingsState current) {
    if (previous != current) return true;

    if (previous is SettingsLoadedState && current is SettingsLoadedState) {
      if (previous.preferences != current.preferences) {
        return true;
      }
    }

    return false;
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
