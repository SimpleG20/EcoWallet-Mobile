# EcoWallet Architecture Documentation

## Overview

EcoWallet follows **Clean Architecture** principles, ensuring separation of concerns, testability, and maintainability. The architecture consists of three main layers, with dependencies flowing inward (Presentation → Domain ← Data).

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                   Presentation Layer                     │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────┐ │
│  │    Screens   │  │    BLoCs     │  │    Widgets    │ │
│  └──────────────┘  └──────────────┘  └───────────────┘ │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│                      Domain Layer                        │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────┐ │
│  │   Entities   │  │  Use Cases   │  │ Repositories  │ │
│  │              │  │              │  │ (Interfaces)  │ │
│  └──────────────┘  └──────────────┘  └───────────────┘ │
└─────────────────────────────────────────────────────────┘
                          ↑
┌─────────────────────────────────────────────────────────┐
│                       Data Layer                         │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────┐ │
│  │    Models    │  │ Repositories │  │ Data Sources  │ │
│  │              │  │     (Impl)   │  │   (Drift)     │ │
│  └──────────────┘  └──────────────┘  └───────────────┘ │
└─────────────────────────────────────────────────────────┘
```

## Layer Descriptions

### 1. Domain Layer (Core Business Logic)

**Purpose**: Contains the core business logic and rules, independent of any framework or external dependencies.

**Components**:

#### Entities
- `Transaction`: Core business entity representing a financial transaction
- Contains business rules and domain logic
- Framework-agnostic, pure Dart classes

```dart
class Transaction extends Equatable {
  final String id;
  final double amount;
  final String description;
  final String category;
  final TransactionType type;
  final DateTime date;
  // ...
}
```

#### Repository Interfaces
- `TransactionRepository`: Abstract interface defining data operations
- Defines what operations are available, not how they're implemented
- Allows for easy mocking in tests

```dart
abstract class TransactionRepository {
  Future<Either<Failure, Transaction>> addTransaction(Transaction transaction);
  Future<Either<Failure, List<Transaction>>> getAllTransactions();
  // ...
}
```

#### Use Cases
- Single responsibility business logic operations
- Each use case performs one specific task
- Examples:
  - `AddTransaction`: Adds a new transaction
  - `GetAllTransactions`: Retrieves all transactions
  - `DeleteTransaction`: Removes a transaction
  - `GetBalance`: Calculates current balance

```dart
class AddTransaction implements UseCase<Transaction, AddTransactionParams> {
  final TransactionRepository repository;
  
  @override
  Future<Either<Failure, Transaction>> call(AddTransactionParams params) =>
      repository.addTransaction(params.transaction);
}
```

**Benefits**:
- Easy to test (no external dependencies)
- Reusable across different platforms
- Clear business rules
- Independent of UI and database

### 2. Data Layer (Data Management)

**Purpose**: Handles data retrieval, storage, and transformation. Implements the repository interfaces defined in the domain layer.

**Components**:

#### Data Sources
- **Local Data Source**: Drift/SQLite database
- Handles all database operations
- Type-safe SQL queries

```dart
@DriftDatabase(tables: [Transactions])
class AppDatabase extends _$AppDatabase {
  Future<List<Transaction>> getAllTransactions() => 
      select(transactions).get();
  // ...
}
```

#### Models
- Data Transfer Objects (DTOs)
- Map between database representation and domain entities
- Handle serialization/deserialization

```dart
extension TransactionModelMapper on db.Transaction {
  Transaction toDomain() => Transaction(
    id: id,
    amount: amount,
    // ... mapping logic
  );
}
```

#### Repository Implementations
- Concrete implementations of domain repository interfaces
- Coordinates data sources
- Error handling and data transformation

```dart
class TransactionRepositoryImpl implements TransactionRepository {
  final AppDatabase _database;
  
  @override
  Future<Either<Failure, Transaction>> addTransaction(
    Transaction transaction,
  ) async {
    try {
      await _database.insertTransaction(transaction.toCompanion());
      return Right(transaction);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
```

**Benefits**:
- Encapsulates data access logic
- Easy to swap data sources
- Handles data persistence details
- Provides clean error handling

### 3. Presentation Layer (UI & State Management)

**Purpose**: Handles user interface and state management using the BLoC pattern.

**Components**:

#### BLoCs (Business Logic Components)
- Manage application state
- React to user events
- Emit new states based on business logic
- Examples:
  - `TransactionBloc`: Manages transaction state
  - `ThemeBloc`: Handles theme switching

```dart
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final AddTransaction addTransaction;
  final GetAllTransactions getAllTransactions;
  
  TransactionBloc({
    required this.addTransaction,
    required this.getAllTransactions,
    // ...
  }) : super(const TransactionState()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransactionEvent>(_onAddTransaction);
    // ...
  }
}
```

#### Screens
- Main application pages
- Examples:
  - `HomeScreen`: Displays transactions and balance
  - `AddTransactionScreen`: Form for adding transactions

#### Widgets
- Reusable UI components
- Stateless when possible
- Focused on single responsibility

**Benefits**:
- Predictable state management
- Easy to test business logic
- Clear separation of UI and logic
- Reactive UI updates

## Key Design Patterns

### 1. Clean Architecture
- **Dependency Rule**: Dependencies point inward
- Outer layers depend on inner layers, never the reverse
- Domain layer has no dependencies on other layers

### 2. Repository Pattern
- Abstracts data sources
- Provides a clean API for data access
- Easy to mock for testing

### 3. BLoC Pattern
- Separates business logic from UI
- Events → BLoC → States
- Predictable state changes
- Easy to test

### 4. Dependency Injection
- Using `get_it` for service locator
- Loose coupling between components
- Easy to swap implementations

### 5. Functional Error Handling
- Using `fpdart` for `Either<Failure, Success>` type
- Explicit error handling
- Type-safe error propagation
- No exceptions for business logic errors

## Data Flow

### Example: Adding a Transaction

1. **User Action**: User fills form and taps "Save"
2. **UI Layer**: Screen collects data, creates Transaction entity
3. **Event**: Dispatches `AddTransactionEvent` to BLoC
4. **BLoC**: Receives event, calls `AddTransaction` use case
5. **Use Case**: Validates and forwards to repository
6. **Repository**: Converts entity to model, calls data source
7. **Data Source**: Saves to SQLite database
8. **Return Path**: Success/Failure propagates back up
9. **State Update**: BLoC emits new state with updated data
10. **UI Update**: Screen rebuilds with new state

```
User Input → AddTransactionEvent 
  → TransactionBloc 
  → AddTransaction UseCase 
  → TransactionRepository 
  → AppDatabase 
  → SQLite
    ↓
Success/Failure ← States ← BLoC ← Repository ← Database
    ↓
UI Update
```

## State Management Flow

```
┌─────────────┐
│   Events    │  User Actions / System Events
└──────┬──────┘
       │
       ↓
┌─────────────┐
│    BLoC     │  Business Logic Processing
└──────┬──────┘
       │
       ↓
┌─────────────┐
│  Use Cases  │  Domain Logic Execution
└──────┬──────┘
       │
       ↓
┌─────────────┐
│ Repository  │  Data Access
└──────┬──────┘
       │
       ↓
┌─────────────┐
│    State    │  New State Emission
└──────┬──────┘
       │
       ↓
┌─────────────┐
│   Widget    │  UI Rebuild
└─────────────┘
```

## Testing Strategy

### Unit Tests
- **Domain Layer**: Test use cases with mocked repositories
- **Data Layer**: Test repository implementations with mocked data sources
- **Presentation Layer**: Test BLoCs with mocked use cases

### Widget Tests
- Test individual widgets in isolation
- Mock BLoCs for controlled state

### Integration Tests
- Test complete flows
- Real database interactions (in-memory)

## Error Handling

### Failure Types
```dart
abstract class Failure {
  final String? message;
}

class DatabaseFailure extends Failure {}
class ValidationFailure extends Failure {}
class NetworkFailure extends Failure {}  // For future API integration
```

### Error Flow
1. Error occurs in data layer
2. Wrapped in `Left(Failure)` of `Either` type
3. Propagated through repository
4. Use case receives failure
5. BLoC handles failure
6. Emits error state
7. UI displays error to user

## Offline-First Architecture

### Database Design
- SQLite with Drift ORM
- Type-safe queries
- Automatic schema migrations
- Strongly-typed table definitions

### Benefits
- Works without network
- Fast data access
- No API latency
- Privacy-first approach

## Scalability Considerations

### Adding New Features
1. Create entity in domain layer
2. Define repository interface
3. Create use cases
4. Implement repository in data layer
5. Add BLoC in presentation layer
6. Build UI screens

### Future Enhancements
- **API Integration**: Add remote data source alongside local
- **Sync Logic**: Implement synchronization between local and remote
- **Caching**: Add cache layer between repository and remote data source
- **Analytics**: Inject analytics service at presentation layer

## Code Quality

### Linting
- Strict linting rules in `analysis_options.yaml`
- Enforces best practices
- Consistent code style

### Type Safety
- Strong typing throughout
- No dynamic types where avoidable
- Compile-time error detection

### Documentation
- Comprehensive inline documentation
- Architecture documentation
- Development guides

## Dependencies

### Core Dependencies
- `flutter_bloc`: State management
- `drift`: Database ORM
- `fpdart`: Functional programming
- `get_it`: Dependency injection
- `equatable`: Value equality

### Reasoning
- Each dependency serves a specific architectural need
- Minimal dependencies to reduce complexity
- Well-maintained and popular packages
- Type-safe alternatives preferred

## Best Practices Followed

1. **SOLID Principles**
   - Single Responsibility
   - Open/Closed
   - Liskov Substitution
   - Interface Segregation
   - Dependency Inversion

2. **DRY (Don't Repeat Yourself)**
   - Reusable components
   - Shared utilities
   - Common constants

3. **KISS (Keep It Simple, Stupid)**
   - Clear, readable code
   - Avoid over-engineering
   - Simple solutions preferred

4. **YAGNI (You Aren't Gonna Need It)**
   - Implement features when needed
   - No premature optimization
   - Focus on current requirements

## Conclusion

EcoWallet's architecture provides a solid foundation for:
- Scalable application growth
- Easy maintenance and updates
- Comprehensive testing
- Team collaboration
- Professional-grade code quality

The separation of concerns ensures that changes in one layer don't affect others, making the codebase resilient to change and easy to understand for new developers.
