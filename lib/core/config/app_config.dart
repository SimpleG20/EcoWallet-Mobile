import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;

// Conditional import: uses dart:io on native platforms, stub on web
import 'app_config_stub.dart'
    if (dart.library.io) 'app_config_io.dart' as platform_info;

enum Environment { dev, stage, prod }

class AppConfig {
  // Configurações Globais
  final String appName;
  final String apiBaseUrl;
  final Environment flavor;

  // Plataforma (Detectada automaticamente ou sobrescrita para testes)
  final TargetPlatform _platform;

  AppConfig({
    required this.appName,
    required this.apiBaseUrl,
    required this.flavor,
    TargetPlatform? platformOverride,
  }) : _platform = platformOverride ?? defaultTargetPlatform;

  // --- Getters Úteis para acesso rápido em todo o app ---

  /// Retorna a plataforma alvo atual (Android, iOS, etc)
  TargetPlatform get platform => _platform;

  /// Verifica se é Android
  bool get isAndroid => _platform == TargetPlatform.android;

  /// Verifica se é iOS
  bool get isIOS => _platform == TargetPlatform.iOS;

  /// Verifica se está rodando na Web (kIsWeb vem do flutter/foundation)
  bool get isWeb => kIsWeb;

  /// Verifica se é Desktop (Windows, Linux, macOS)
  bool get isDesktop =>
      _platform == TargetPlatform.windows ||
      _platform == TargetPlatform.linux ||
      _platform == TargetPlatform.macOS;

  // Helpers seguros para dart:io (evita crash na web)
  bool get isWindows => !isWeb && platform_info.isWindows;
  bool get isLinux => !isWeb && platform_info.isLinux;
  bool get isMacOS => !isWeb && platform_info.isMacOS;
}
