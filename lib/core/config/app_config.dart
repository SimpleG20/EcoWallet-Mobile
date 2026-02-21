import 'dart:io';
import 'package:flutter/foundation.dart';

enum Environment { dev, stage, prod }

class AppConfig {
  // Global Configurations
  final String appName;
  final String apiBaseUrl;
  final Environment flavor;

  // Platform (Detected automatically or overridden for testing)
  final TargetPlatform _platform;

  AppConfig({
    required this.appName,
    required this.apiBaseUrl,
    required this.flavor,
    TargetPlatform? platformOverride,
  }) : _platform = platformOverride ?? defaultTargetPlatform;

  TargetPlatform get platform => _platform;

  /// Checks if the platform is Android
  bool get isAndroid => _platform == TargetPlatform.android;

  /// Checks if the platform is iOS
  bool get isIOS => _platform == TargetPlatform.iOS;

  /// Checks if the app is running on the Web (kIsWeb comes from flutter/foundation)
  bool get isWeb => kIsWeb;

  /// Checks if the platform is Desktop (Windows, Linux, macOS)
  bool get isDesktop => !isWeb && (isWindows || isLinux || isMacOS); // Helpers below use dart:io safely
  bool get isWindows => !isWeb && Platform.isWindows;
  bool get isLinux => !isWeb && Platform.isLinux;
  bool get isMacOS => !isWeb && Platform.isMacOS;
}
