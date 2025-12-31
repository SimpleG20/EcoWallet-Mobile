import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _database;
  static int get _dbVersion => 2;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'eco_wallet.db');

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            amount INTEGER NOT NULL,
            cents INTEGER NOT NULL,
            date TEXT NOT NULL,
            type TEXT NOT NULL,
            category TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE users(
            id TEXT PRIMARY KEY,
            fullName TEXT,
            email TEXT UNIQUE,
            password TEXT,
            phoneNumber TEXT,
            imageUrl TEXT,
            address TEXT,
            dateOfBirth TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await _migrateDb(db, oldVersion, newVersion);
      },
    );
  }

  Future<void> _migrateDb(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS users(
          id TEXT PRIMARY KEY,
          fullName TEXT,
          email TEXT UNIQUE,
          password TEXT,
          phoneNumber TEXT,
          imageUrl TEXT,
          address TEXT,
          dateOfBirth TEXT
        )
      ''');
    }
  }
}
