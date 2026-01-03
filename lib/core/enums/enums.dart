enum EPeriodType { daily, weekly, monthly, yearly, allTime }

enum ETransactionType { income, expense }

/// Enum representing all available transaction categories.
/// This provides type-safety and avoids magic strings throughout the codebase.
enum ETransactionCategory { food, transport, bills, health, shopping, entertainment, salary, others }
