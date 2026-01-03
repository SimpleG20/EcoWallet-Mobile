import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db_seeds.dart';

class DbHelper {
  static Database? _database;
  static int get _dbVersion => 5;

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
        // Users table
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

        // Transaction types lookup table
        await db.execute('''
          CREATE TABLE transaction_types(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL UNIQUE
          )
        ''');

        // Categories lookup table
        await db.execute('''
          CREATE TABLE categories(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL UNIQUE,
            icon_name TEXT NOT NULL
          )
        ''');

        // Transactions table with foreign keys
        await db.execute('''
          CREATE TABLE transactions(
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            name TEXT NOT NULL,
            amount_cents INTEGER NOT NULL,
            date TEXT NOT NULL,
            type_id INTEGER NOT NULL,
            category_id INTEGER NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
            FOREIGN KEY (type_id) REFERENCES transaction_types(id),
            FOREIGN KEY (category_id) REFERENCES categories(id)
          )
        ''');

        // Settings table (keeps JSON approach for flexibility)
        await db.execute('''
          CREATE TABLE settings(
            id TEXT PRIMARY KEY,
            dataPreferences TEXT,
            budgetPreferences TEXT,
            appearancePreferences TEXT,
            notificationPreferences TEXT
          )
        ''');

        // Create indexes for performance
        await db.execute('CREATE INDEX idx_transactions_user ON transactions(user_id)');
        await db.execute('CREATE INDEX idx_transactions_date ON transactions(date)');
        await db.execute('CREATE INDEX idx_transactions_category ON transactions(category_id)');
        await db.execute('CREATE INDEX idx_transactions_type ON transactions(type_id)');
        await db.execute('CREATE INDEX idx_users_email ON users(email)');

        // Seed lookup tables
        await DbSeeds.seedAll(db);
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

    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS settings(
          id TEXT PRIMARY KEY,
          dataPreferences TEXT,
          budgetPreferences TEXT,
          appearancePreferences TEXT,
          notificationPreferences TEXT
        )
      ''');
    }

    if (oldVersion < 4) {
      // Migration from v3 to v4: Add relational schema

      // 1. Create lookup tables
      await db.execute('''
        CREATE TABLE IF NOT EXISTS transaction_types(
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL UNIQUE
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS categories(
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL UNIQUE,
          icon_name TEXT NOT NULL
        )
      ''');

      // 2. Seed lookup tables
      await DbSeeds.seedAll(db);

      // 3. Get the first user ID (for user_id FK, or use empty string)
      final users = await db.query('users', limit: 1);
      final defaultUserId = users.isNotEmpty ? users.first['id'] as String : '';

      // 4. Create new transactions table with proper schema
      await db.execute('''
        CREATE TABLE transactions_new(
          id TEXT PRIMARY KEY,
          user_id TEXT NOT NULL,
          name TEXT NOT NULL,
          amount_cents INTEGER NOT NULL,
          date TEXT NOT NULL,
          type_id INTEGER NOT NULL,
          category_id INTEGER NOT NULL,
          FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
          FOREIGN KEY (type_id) REFERENCES transaction_types(id),
          FOREIGN KEY (category_id) REFERENCES categories(id)
        )
      ''');

      // 5. Migrate existing data
      final oldTransactions = await db.query('transactions');
      for (final tx in oldTransactions) {
        final amount = tx['amount'] as int? ?? 0;
        final cents = tx['cents'] as int? ?? 0;
        final amountCents = amount * 100 + cents;

        final typeStr = tx['type']?.toString() ?? 'expense';
        final typeId = DbSeeds.getTypeId(typeStr);

        final categoryStr = tx['category']?.toString() ?? 'others';
        final categoryId = DbSeeds.getCategoryId(categoryStr);

        await db.insert('transactions_new', {
          'id': tx['id'],
          'user_id': defaultUserId,
          'name': tx['name'],
          'amount_cents': amountCents,
          'date': tx['date'],
          'type_id': typeId,
          'category_id': categoryId,
        });
      }

      // 6. Swap tables
      await db.execute('DROP TABLE transactions');
      await db.execute('ALTER TABLE transactions_new RENAME TO transactions');

      // 7. Create indexes
      await db.execute('CREATE INDEX IF NOT EXISTS idx_transactions_user ON transactions(user_id)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_transactions_date ON transactions(date)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_transactions_category ON transactions(category_id)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_transactions_type ON transactions(type_id)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_users_email ON users(email)');
    }

    // Migration v5: Fix transactions with empty user_id
    if (oldVersion < 5) {
      // Get the first user's ID
      final users = await db.query('users', limit: 1);
      if (users.isNotEmpty) {
        final userId = users.first['id'] as String;
        // Update all transactions with empty user_id
        await db.update(
          'transactions',
          {'user_id': userId},
          where: "user_id = '' OR user_id IS NULL",
        );
      }
    }
  }
}

