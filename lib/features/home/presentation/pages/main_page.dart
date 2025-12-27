import 'package:flutter/material.dart';

import 'home_page.dart';
import '/l10n/app_localizations.dart';
import '../../../transactions/presentation/pages/transactions_page.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Analytics"));
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Settings"));
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const TransactionWalletPage(),
    const AnalyticsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
        // IndexedStack builds all pages at once and keeps their state,
        // but only shows the one at the current index.
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: _buildBottomNavigation(loc, theme));
  }

  /// Builds the bottom navigation bar.
  Widget _buildBottomNavigation(AppLocalizations loc, ThemeData theme) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: theme.colorScheme.surface,
      selectedItemColor: theme.colorScheme.primary,
      showUnselectedLabels: true,
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        _navigationBarItem(
            _currentIndex, 0, loc.lbHome, Icons.home_outlined, theme, loc),
        _navigationBarItem(_currentIndex, 1, loc.lbWallet,
            Icons.account_balance_wallet_outlined, theme, loc),
        _navigationBarItem(_currentIndex, 2, loc.lbAnalytics,
            Icons.bar_chart_outlined, theme, loc),
        _navigationBarItem(_currentIndex, 3, loc.lbSettings,
            Icons.settings_outlined, theme, loc),
      ],
    );
  }

  BottomNavigationBarItem _navigationBarItem(int currentIndex, int index,
      String label, IconData icon, ThemeData theme, AppLocalizations loc) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: currentIndex == index
              ? theme.colorScheme.primary
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: currentIndex == index
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.outlineVariant,
        ),
      ),
      label: label,
    );
  }
}
