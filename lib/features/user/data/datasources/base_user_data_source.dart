import '../model/user_model.dart';
import '../../domain/entities/user.dart';

abstract class BaseUserDataSource {
  Future<User> getUser(String id);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String id);
}
