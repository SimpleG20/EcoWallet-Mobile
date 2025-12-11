import 'package:get_it/get_it.dart';
import 'package:ecowallet/data/datasources/database/database.dart';
import 'package:ecowallet/data/repositories/transaction_repository_impl.dart';
import 'package:ecowallet/domain/repositories/transaction_repository.dart';
import 'package:ecowallet/domain/usecases/add_transaction.dart';
import 'package:ecowallet/domain/usecases/get_all_transactions.dart';
import 'package:ecowallet/domain/usecases/delete_transaction.dart';
import 'package:ecowallet/domain/usecases/get_balance.dart';
import 'package:ecowallet/presentation/blocs/transaction/transaction_bloc.dart';
import 'package:ecowallet/presentation/blocs/theme/theme_bloc.dart';

final sl = GetIt.instance;

/// Initialize dependency injection
Future<void> initializeDependencies() async {
  // Database
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Repositories
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => AddTransaction(sl()));
  sl.registerLazySingleton(() => GetAllTransactions(sl()));
  sl.registerLazySingleton(() => DeleteTransaction(sl()));
  sl.registerLazySingleton(() => GetBalance(sl()));

  // BLoCs
  sl.registerFactory(
    () => TransactionBloc(
      addTransaction: sl(),
      getAllTransactions: sl(),
      deleteTransaction: sl(),
      getBalance: sl(),
    ),
  );
  
  sl.registerLazySingleton(() => ThemeBloc());
}
