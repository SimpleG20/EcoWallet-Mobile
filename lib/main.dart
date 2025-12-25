import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// import 'package:eco_wallet/core/theme/app_theme.dart';
import 'package:eco_wallet/l10n/app_localizations.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  runApp(const EcoWalletApp());
}

class EcoWalletApp extends StatelessWidget {
  const EcoWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'EcoWallet',
        // theme: AppTheme.lightTheme,
        // darkTheme: AppTheme.darkTheme,
        // themeMode: ThemeMode.system,
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
        home:
            const Scaffold(body: Center(child: Text("EcoWallet Initialized"))));
  }
}
