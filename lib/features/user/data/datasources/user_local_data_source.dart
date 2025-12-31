import 'package:sqflite/sqflite.dart';

import 'package:eco_wallet/core/database/db_helper.dart';
import 'package:eco_wallet/core/errors/exceptions.dart';
import 'base_user_data_source.dart';
import '../model/user_model.dart';
import '../../domain/entities/user.dart';
import '../../../../core/errors/base_failure.dart';

class UserLocalDataSource implements BaseUserDataSource {
  final DbHelper dbHelper;

  UserLocalDataSource({required this.dbHelper});

  @override
  Future<User> getUser() async {
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query('user');

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
        'user',
        user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }
}
