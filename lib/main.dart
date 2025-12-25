import 'package:flutter/material.dart';
import 'injection_container.dart' as di;

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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF10B981)), // Emerald Green
          useMaterial3: true,
        ),
        home:
            const Scaffold(body: Center(child: Text("EcoWallet Initialized"))));
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
