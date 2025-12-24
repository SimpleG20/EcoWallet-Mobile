import 'package:flutter/material.dart';
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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF10B981)), // Emerald Green
          useMaterial3: true,
        ),
        home:
            const Scaffold(body: Center(child: Text("EcoWallet Initialized"))));
  }
}
