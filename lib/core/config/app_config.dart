import 'dart:io';
import 'package:flutter/foundation.dart';

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
  bool get isDesktop => !isWeb && (isWindows || isLinux || isMacOS); // Helpers abaixo usam dart:io com segurança

  // Helpers seguros para dart:io (evita crash na web)
  bool get isWindows => !isWeb && Platform.isWindows;
  bool get isLinux => !isWeb && Platform.isLinux;
  bool get isMacOS => !isWeb && Platform.isMacOS;
}
