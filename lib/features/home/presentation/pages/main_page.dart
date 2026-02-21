import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/controllers/navigation_cubit.dart';
import 'home_page.dart';
import '/l10n/app_localizations.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../transactions/presentation/pages/transactions_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const List<Widget> _pages = [
    HomePage(),
    TransactionWalletPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider<NavigationCubit>(
      create: (_) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, state) => Scaffold(
            // IndexedStack builds all pages at once and keeps their state,
            // but only shows the one at the current index.
            body: IndexedStack(
              index: state,
              children: _pages,
            ),
            bottomNavigationBar: _buildBottomNavigation(context, loc, theme, state)),
      ),
    );
  }

  /// Builds the bottom navigation bar.
  Widget _buildBottomNavigation(BuildContext context, AppLocalizations loc, ThemeData theme, int currentIndex) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: theme.colorScheme.surface,
      selectedItemColor: theme.colorScheme.primary,
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      onTap: (index) {
        context.read<NavigationCubit>().goToIndex(index);
      },
      items: [
        _navigationBarItem(currentIndex, 0, loc.lbHome, Icons.home_outlined, theme, loc),
        _navigationBarItem(currentIndex, 1, loc.lbWallet, Icons.account_balance_wallet_outlined, theme, loc),
        _navigationBarItem(currentIndex, 2, loc.lbSettings, Icons.settings_outlined, theme, loc),
      ],
    );
  }

  BottomNavigationBarItem _navigationBarItem(
      int currentIndex, int index, String label, IconData icon, ThemeData theme, AppLocalizations loc) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: currentIndex == index ? theme.colorScheme.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: currentIndex == index ? theme.colorScheme.onPrimary : theme.colorScheme.outlineVariant,
        ),
      ),
      label: label,
    );
  }
}
