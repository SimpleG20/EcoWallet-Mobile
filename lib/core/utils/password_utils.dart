import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Utility class for password hashing and verification.
///
/// Uses SHA-256 with salt for secure password storage.
/// Note: For production apps, consider using bcrypt or Argon2 via flutter_bcrypt or argon2.
class PasswordUtils {
  /// Generates a SHA-256 hash of the password with the email as salt.
  ///
  /// Using email as salt provides unique hashes for same passwords across users.
  static String hashPassword(String password, String email) {
    final saltedPassword = '$email:$password';
    final bytes = utf8.encode(saltedPassword);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verifies if the provided password matches the stored hash.
  static bool verifyPassword(String password, String email, String storedHash) {
    final computedHash = hashPassword(password, email);
    return computedHash == storedHash;
  }
}
