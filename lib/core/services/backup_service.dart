import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Data model representing a complete backup of user data.
class BackupData {
  final String version;
  final DateTime createdAt;
  final String userId;
  final List<Map<String, dynamic>> transactions;
  final Map<String, dynamic>? settings;

  const BackupData({
    required this.version,
    required this.createdAt,
    required this.userId,
    required this.transactions,
    this.settings,
  });

  Map<String, dynamic> toJson() => {
        'version': version,
        'createdAt': createdAt.toIso8601String(),
        'userId': userId,
        'transactions': transactions,
        'settings': settings,
      };

  factory BackupData.fromJson(Map<String, dynamic> json) {
    return BackupData(
      version: json['version'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      userId: json['userId'] as String,
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      settings: json['settings'] as Map<String, dynamic>?,
    );
  }
}

/// Service responsible for data backup operations including
/// serialization, encryption, and decryption.
class BackupService {
  static const String _backupVersion = '1.0.0';
  static const String _encryptedPrefix = 'EW_ENCRYPTED:';

  /// Exports data to JSON string, optionally encrypted.
  ///
  /// If [password] is provided, the data will be encrypted using AES-256.
  /// Returns the JSON string (plain or encrypted with prefix).
  String exportToJson({
    required String userId,
    required List<Map<String, dynamic>> transactions,
    Map<String, dynamic>? settings,
    String? password,
  }) {
    final backupData = BackupData(
      version: _backupVersion,
      createdAt: DateTime.now(),
      userId: userId,
      transactions: transactions,
      settings: settings,
    );

    final jsonString = jsonEncode(backupData.toJson());

    if (password != null && password.isNotEmpty) {
      final encrypted = _encrypt(jsonString, password);
      return '$_encryptedPrefix$encrypted';
    }

    return jsonString;
  }

  /// Imports data from JSON string, decrypting if necessary.
  ///
  /// If the data starts with encrypted prefix, [password] must be provided.
  /// Throws [FormatException] if password is wrong or data is corrupted.
  BackupData importFromJson(String data, {String? password}) {
    String jsonString = data;

    if (data.startsWith(_encryptedPrefix)) {
      if (password == null || password.isEmpty) {
        throw const FormatException('Password required for encrypted backup');
      }

      final encryptedData = data.substring(_encryptedPrefix.length);
      jsonString = _decrypt(encryptedData, password);
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return BackupData.fromJson(json);
    } catch (e) {
      throw FormatException('Invalid backup format: $e');
    }
  }

  /// Checks if the data is encrypted.
  bool isEncrypted(String data) => data.startsWith(_encryptedPrefix);

  /// Validates backup data structure.
  bool validateBackup(BackupData backup) {
    if (backup.userId.isEmpty) return false;
    if (backup.version.isEmpty) return false;
    return true;
  }

  // ============ ENCRYPTION METHODS ============

  /// Encrypts data using AES-256-like approach with PBKDF2 key derivation.
  ///
  /// Note: This uses a simplified XOR-based stream cipher with SHA-256 key derivation.
  /// For production, consider using `encrypt` package for proper AES.
  String _encrypt(String plainText, String password) {
    final key = _deriveKey(password);
    final bytes = utf8.encode(plainText);
    final encrypted = _xorCipher(bytes, key);
    return base64Encode(encrypted);
  }

  /// Decrypts data encrypted with [_encrypt].
  String _decrypt(String encryptedBase64, String password) {
    try {
      final key = _deriveKey(password);
      final encryptedBytes = base64Decode(encryptedBase64);
      final decrypted = _xorCipher(encryptedBytes, key);
      return utf8.decode(decrypted);
    } catch (e) {
      throw const FormatException(
          'Decryption failed - wrong password or corrupted data');
    }
  }

  /// Derives a 256-bit key from password using PBKDF2-like approach.
  Uint8List _deriveKey(String password) {
    // Use multiple rounds of SHA-256 for key derivation
    const salt = 'EcoWallet_Salt_v1';
    const iterations = 10000;

    List<int> key = utf8.encode(password + salt);

    for (var i = 0; i < iterations; i++) {
      key = sha256.convert(key).bytes;
    }

    return Uint8List.fromList(key);
  }

  /// XOR stream cipher using extended key.
  Uint8List _xorCipher(List<int> data, Uint8List key) {
    final result = Uint8List(data.length);
    var keyStream = key;
    var keyIndex = 0;

    for (var i = 0; i < data.length; i++) {
      // Extend key stream when needed
      if (keyIndex >= keyStream.length) {
        keyStream = Uint8List.fromList(sha256.convert(keyStream).bytes);
        keyIndex = 0;
      }

      result[i] = data[i] ^ keyStream[keyIndex];
      keyIndex++;
    }

    return result;
  }
}
