import 'package:eco_wallet/features/user/data/model/user_model.dart';
import 'package:eco_wallet/features/user/domain/entities/user.dart';

abstract class BaseUserDataSource {
  Future<User> getUser(String id);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String id);
}
