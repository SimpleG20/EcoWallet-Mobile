import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecowallet/core/constants/app_theme.dart';
import 'package:ecowallet/core/di/injection_container.dart';
import 'package:ecowallet/presentation/blocs/transaction/transaction_bloc.dart';
import 'package:ecowallet/presentation/blocs/theme/theme_bloc.dart';
import 'package:ecowallet/presentation/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await initializeDependencies();
  
  runApp(const EcoWalletApp());
}

/// Root application widget
class EcoWalletApp extends StatelessWidget {
  const EcoWalletApp({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<ThemeBloc>()),
          BlocProvider(create: (_) => sl<TransactionBloc>()),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) => MaterialApp(
            title: 'EcoWallet',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
            home: const HomeScreen(),
          ),
        ),
      );
}
