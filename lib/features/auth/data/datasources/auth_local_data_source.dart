import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/constants/keys.dart';
import '../../../../core/database/db_helper.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/password_utils.dart';
import '../../../user/data/model/user_model.dart';
import 'base_auth_data_source.dart';

class AuthLocalDataSource implements BaseAuthDataSource {
  final DbHelper dbHelper;
  final SharedPreferences sharedPreferences;

  AuthLocalDataSource({
    required this.dbHelper,
    required this.sharedPreferences,
  });

  @override
  Future<UserModel> authenticate(String email, String password) async {
    try {
      final db = await dbHelper.database;
      // Query user by email only, then verify password hash
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (maps.isNotEmpty) {
        final userMap = maps.first;
        final storedHash = userMap['password'] as String;

        // Verify password using hash comparison
        if (PasswordUtils.verifyPassword(password, email, storedHash)) {
          return UserModel.fromJson(userMap);
        } else {
          throw AuthenticationException('Invalid email or password');
        }
      } else {
        throw AuthenticationException('Invalid email or password');
      }
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw CacheException('Database error during authentication');
    }
  }

  @override
  Future<UserModel> registerUser(UserModel user) async {
    try {
      final db = await dbHelper.database;

      // Hash the password before storing
      final hashedPassword = PasswordUtils.hashPassword(
        user.encryptedPassword,
        user.email,
      );

      // Create a new user model with hashed password
      final userWithHashedPassword = UserModel(
        id: user.id,
        fullName: user.fullName,
        email: user.email,
        encryptedPassword: hashedPassword,
        phoneNumber: user.phoneNumber,
        imageUrl: user.imageUrl,
        address: user.address,
        dateOfBirth: user.dateOfBirth,
      );

      await db.insert(
        'users',
        userWithHashedPassword.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return userWithHashedPassword;
    } catch (e) {
      throw CacheException('Database error during user registration');
    }
  }

  @override
  Future<void> saveSession(UserModel user) async {
    try {
      await sharedPreferences.setString(CACHED_USER_ID, user.id);
    } catch (e) {
      throw CacheException('Failed to save session: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteSession() async {
    await sharedPreferences.remove(CACHED_USER_ID);
  }

  @override
  Future<UserModel> getLoggedUser() async {
    try {
      final userId = sharedPreferences.getString(CACHED_USER_ID);

      if (userId == null) {
        throw AuthenticationException('No session found');
      }

      final db = await dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (maps.isNotEmpty) {
        final userMap = maps.first;
        final user = UserModel.fromJson(userMap);
        return user;
      } else {
        await deleteSession();
        throw AuthenticationException('User not found in database');
      }
    } on AuthenticationException {
      // Preserve AuthenticationException to avoid wrapping it
      rethrow;
    } catch (e) {
      throw AuthenticationException('Failed to fetch logged user: ${e.toString()}');
    }
  }
}
