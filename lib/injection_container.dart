import 'package:eco_wallet/features/settings/data/datasources/base_settings_data_source.dart';
import 'package:eco_wallet/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:eco_wallet/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:eco_wallet/features/settings/domain/repositories/base_setting_repository.dart';
import 'package:eco_wallet/features/settings/domain/usecases/get_user_preferences.dart';
import 'package:eco_wallet/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/database/db_helper.dart';

import 'features/settings/domain/usecases/get_user.dart';
import 'features/transactions/domain/usecases/filter_transactions.dart';
import 'features/transactions/domain/usecases/search_query_transactions.dart';
import 'features/transactions/presentation/bloc/transactions_history_bloc.dart';

import 'features/wallet/presentation/bloc/wallet_bloc.dart';

import 'features/wallet/data/datasources/base_wallet_local_data_source.dart';
import 'features/wallet/data/datasources/wallet_local_data_source_impl.dart';
import 'features/wallet/data/repositories/wallet_repository_impl.dart';

import 'features/wallet/domain/usecases/get_transaction.dart';
import 'features/wallet/domain/usecases/get_transactions.dart';
import 'features/wallet/domain/usecases/add_transaction.dart';
import 'features/wallet/domain/usecases/delete_transaction.dart';
import 'features/wallet/domain/usecases/update_transaction.dart';
import 'features/wallet/domain/repositories/base_wallet_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
    () => SettingsBloc(
      getUser: sl(),
      getUserPreferences: sl(),
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

  sl.registerLazySingleton(() => GetUser(sl()));
  sl.registerLazySingleton(() => GetUserPreferences(sl()));

  sl.registerLazySingleton(() => GetTransactions(sl()));
  sl.registerLazySingleton(() => FilterTransactions());
  sl.registerLazySingleton(() => SearchQueryTransactions());

  sl.registerLazySingleton(() => AddTransaction(sl()));
  sl.registerLazySingleton(() => DeleteTransaction(sl()));
  sl.registerLazySingleton(() => UpdateTransaction(sl()));
  sl.registerLazySingleton(() => GetTransaction(sl()));

  sl.registerLazySingleton<BaseSettingRepository>(() => SettingsRepositoryImpl(dataSource: sl()));

  sl.registerLazySingleton<BaseWalletRepository>(() => WalletRepositoryImpl(dataSource: sl()));

  sl.registerLazySingleton<BaseSettingsDataSource>(() => SettingsLocalDataSource(dbHelper: sl()));

  sl.registerLazySingleton<BaseWalletLocalDataSource>(() => WalletLocalDataSourceImpl(dbHelper: sl()));

  sl.registerLazySingleton(() => DbHelper());
}
