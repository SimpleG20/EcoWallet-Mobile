import 'package:get_it/get_it.dart';

import 'package:eco_wallet/core/database/db_helper.dart';
import 'package:eco_wallet/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:eco_wallet/features/wallet/domain/repositories/base_wallet_repository.dart';
import 'package:eco_wallet/features/wallet/domain/usecases/get_transaction.dart';
import 'package:eco_wallet/features/wallet/domain/usecases/get_transactions.dart';

import 'features/wallet/data/datasources/base_wallet_local_data_source.dart';
import 'features/wallet/data/datasources/wallet_local_data_source_impl.dart';
import 'features/wallet/domain/usecases/add_transaction.dart';
import 'features/wallet/domain/usecases/delete_transaction.dart';
import 'features/wallet/domain/usecases/update_transaction.dart';
import 'features/wallet/presentation/bloc/wallet_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => WalletBloc(
      getTransactions: sl(),
      addTransaction: sl(),
      deleteTransaction: sl(),
      updateTransaction: sl(),
      getTransactionById: sl()));

  sl.registerLazySingleton(() => GetTransactions(sl()));
  sl.registerLazySingleton(() => AddTransaction(sl()));
  sl.registerLazySingleton(() => DeleteTransaction(sl()));
  sl.registerLazySingleton(() => UpdateTransaction(sl()));
  sl.registerLazySingleton(() => GetTransaction(sl()));

  sl.registerLazySingleton<BaseWalletRepository>(
      () => WalletRepositoryImpl(localDataSource: sl()));

  sl.registerLazySingleton<BaseWalletLocalDataSource>(
      () => WalletLocalDataSourceImpl(dbHelper: sl()));

  sl.registerLazySingleton(() => DbHelper());
}
