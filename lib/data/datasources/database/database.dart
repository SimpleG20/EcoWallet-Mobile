import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:ecowallet/core/constants/app_constants.dart';

// Generated file - run: flutter pub run build_runner build
part 'database.g.dart';

/// Transactions table definition
class Transactions extends Table {
  TextColumn get id => text()();
  RealColumn get amount => real()();
  TextColumn get description => text().withLength(
        max: AppConstants.maxTransactionDescriptionLength,
      )();
  TextColumn get category =>
      text().withLength(max: AppConstants.maxCategoryNameLength)();
  TextColumn get type => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Database class for Drift
@DriftDatabase(tables: [Transactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => AppConstants.dbVersion;

  // Transaction operations
  Future<List<Transaction>> getAllTransactions() => select(transactions).get();

  Future<Transaction?> getTransactionById(String id) =>
      (select(transactions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Transaction>> getTransactionsByDateRange({
    required DateTime start,
    required DateTime end,
  }) =>
      (select(transactions)
            ..where((t) => t.date.isBiggerOrEqualValue(start))
            ..where((t) => t.date.isSmallerOrEqualValue(end))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<List<Transaction>> getTransactionsByType(String type) =>
      (select(transactions)
            ..where((t) => t.type.equals(type))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<List<Transaction>> getTransactionsByCategory(String category) =>
      (select(transactions)
            ..where((t) => t.category.equals(category))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<int> insertTransaction(TransactionsCompanion entry) =>
      into(transactions).insert(entry);

  Future<bool> updateTransaction(Transaction entry) =>
      update(transactions).replace(entry);

  Future<int> deleteTransaction(String id) =>
      (delete(transactions)..where((t) => t.id.equals(id))).go();

  // Aggregation queries
  Future<double> getTotalIncome() async {
    final query = selectOnly(transactions)
      ..addColumns([transactions.amount.sum()])
      ..where(transactions.type.equals('income'));
    final result = await query.getSingle();
    return result.read(transactions.amount.sum()) ?? 0.0;
  }

  Future<double> getTotalExpense() async {
    final query = selectOnly(transactions)
      ..addColumns([transactions.amount.sum()])
      ..where(transactions.type.equals('expense'));
    final result = await query.getSingle();
    return result.read(transactions.amount.sum()) ?? 0.0;
  }

  Future<int> getTransactionsCount() async {
    final query = selectOnly(transactions)..addColumns([transactions.id.count()]);
    final result = await query.getSingle();
    return result.read(transactions.id.count()) ?? 0;
  }
}

LazyDatabase _openConnection() => LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, AppConstants.dbName));
      return NativeDatabase.createInBackground(file);
    });
