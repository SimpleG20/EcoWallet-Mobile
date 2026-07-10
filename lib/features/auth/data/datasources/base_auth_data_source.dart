import 'package:eco_wallet/features/user/data/model/user_model.dart';

abstract class BaseAuthDataSource {
  /// Authenticates a user with email and password.
  Future<UserModel> authenticate(String email, String password);

  /// Registers a new user.
  Future<UserModel> registerUser(UserModel user);

  /// Recover current logged-in user.
  /// Throws [CacheException] if no user is logged in.
  Future<UserModel> getLoggedUser();

  /// Saves the user session (after Login or Signup).
  Future<void> saveSession(UserModel user);

  /// Ends the session (Logout).
  Future<void> deleteSession();
}
