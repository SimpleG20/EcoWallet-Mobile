// Platform info implementation using dart:io for native platforms
import 'dart:io' show Platform;

bool get isWindows => Platform.isWindows;
bool get isLinux => Platform.isLinux;
bool get isMacOS => Platform.isMacOS;
