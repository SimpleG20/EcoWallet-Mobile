import 'package:sqflite/sqflite.dart';

import 'package:eco_wallet/core/database/db_helper.dart';
import 'package:eco_wallet/core/errors/exceptions.dart';
import 'package:eco_wallet/features/user/data/datasources/base_user_data_source.dart';
import 'package:eco_wallet/features/user/data/model/user_model.dart';
import 'package:eco_wallet/features/user/domain/entities/user.dart';

class UserLocalDataSource implements BaseUserDataSource {
  final DbHelper dbHelper;

  UserLocalDataSource({required this.dbHelper});

  @override
  Future<User> getUser(String id) async {
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        final userMap = maps.first;
        final user = UserModel.fromJson(userMap);
        return user;
      } else {
        throw CacheException('No user data found');
      }
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('Failed to fetch user from db');
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      final db = await dbHelper.database;

      await db.insert(
        'users',
        user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      final db = await dbHelper.database;
      await db.delete('users', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
