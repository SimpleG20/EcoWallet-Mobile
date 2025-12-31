import '../model/user_model.dart';
import '../../domain/entities/user.dart';

abstract class BaseUserDataSource {
  Future<User> getUser();
  Future<void> updateUser(UserModel user);
}
