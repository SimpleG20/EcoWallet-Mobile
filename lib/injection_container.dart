import 'package:eco_wallet/features/user/domain/usecases/get_current_user.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/database/db_helper.dart';

import 'core/router/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/data/datasources/base_auth_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/domain/usecases/auth_usecases.dart';
import 'features/auth/domain/repositories/base_auth_repository.dart';

import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/data/datasources/base_settings_data_source.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/data/datasources/settings_local_data_source.dart';
import 'features/settings/domain/usecases/get_user_preferences.dart';
import 'features/settings/domain/usecases/update_user_preferences.dart';
import 'features/settings/domain/repositories/base_setting_repository.dart';

import 'features/transactions/domain/usecases/transactions_usescases.dart';
import 'features/transactions/presentation/bloc/transactions_history_bloc.dart';

import 'features/user/domain/usecases/user_usecases.dart';
import 'features/user/domain/repositories/base_user_repository.dart';
import 'features/user/data/datasources/base_user_data_source.dart';
import 'features/user/data/repositories/user_repository_impl.dart';
import 'features/user/data/datasources/user_local_data_source.dart';

import 'features/user/presentation/bloc/user_bloc.dart';
import 'features/wallet/data/datasources/base_wallet_local_data_source.dart';
import 'features/wallet/data/datasources/wallet_local_data_source_impl.dart';
import 'features/wallet/data/repositories/wallet_repository_impl.dart';

import 'features/wallet/presentation/bloc/wallet_bloc.dart';
import 'features/wallet/domain/usecases/wallet_usecases.dart';
import 'features/wallet/domain/repositories/base_wallet_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(
    () => UserBloc(
      getUser: sl(),
      updateUser: sl(),
      deleteUser: sl(),
      authBloc: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => AuthBloc(
      signIn: sl(),
      signUp: sl(),
      logOut: sl(),
      checkAuthStatus: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => SettingsBloc(
      getCurrentUser: sl(),
      getUserPreferences: sl(),
      updateUserPreferences: sl(),
    ),
  );

  sl.registerFactory(
    () => TransactionsHistoryBloc(
      getTransactions: sl(),
      filterTransactions: sl(),
      searchTransactions: sl(),
      repository: sl(),
    ),
  );

  sl.registerFactory(
    () => WalletBloc(
      getTransactions: sl(),
      addTransaction: sl(),
      deleteTransaction: sl(),
      updateTransaction: sl(),
      getTransactionById: sl(),
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(() => AppRouter(authBloc: sl()));

  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => LogOut(sl()));
  sl.registerLazySingleton(() => CheckAuthStatus(sl()));

  sl.registerLazySingleton(() => GetUser(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => UpdateUser(sl()));
  sl.registerLazySingleton(() => DeleteUser(sl()));

  sl.registerLazySingleton(() => GetUserPreferences(sl()));
  sl.registerLazySingleton(() => UpdateUserPreferences(sl()));

  sl.registerLazySingleton(() => FilterTransactions());
  sl.registerLazySingleton(() => SearchQueryTransactions());
  sl.registerLazySingleton(() => GetTransactions(sl()));
  sl.registerLazySingleton(() => AddTransaction(sl()));
  sl.registerLazySingleton(() => DeleteTransaction(sl()));
  sl.registerLazySingleton(() => UpdateTransaction(sl()));
  sl.registerLazySingleton(() => GetTransaction(sl()));

  sl.registerLazySingleton<BaseAuthRepository>(() => AuthRepositoryImpl(dataSource: sl()));
  sl.registerLazySingleton<BaseUserRepository>(() => UserRepositoryImpl(dataSource: sl(), authDataSource: sl()));
  sl.registerLazySingleton<BaseSettingRepository>(() => SettingsRepositoryImpl(dataSource: sl()));
  sl.registerLazySingleton<BaseWalletRepository>(() => WalletRepositoryImpl(dataSource: sl()));

  sl.registerLazySingleton<BaseAuthDataSource>(() => AuthLocalDataSource(dbHelper: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton<BaseUserDataSource>(() => UserLocalDataSource(dbHelper: sl()));
  sl.registerLazySingleton<BaseSettingsDataSource>(() => SettingsLocalDataSource(dbHelper: sl()));
  sl.registerLazySingleton<BaseWalletLocalDataSource>(() => WalletLocalDataSourceImpl(dbHelper: sl()));

  // External dependencies - must be initialized first
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DbHelper());
}
