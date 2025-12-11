# Development Guide

## Setup Instructions

### 1. Install Flutter

Make sure you have Flutter SDK installed. Visit [flutter.dev](https://flutter.dev/docs/get-started/install) for installation instructions.

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run Code Generation

This project uses code generation for the database layer (Drift). Run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

For continuous generation during development:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 4. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
├── core/               # Core functionality
│   ├── constants/      # App constants and theme
│   ├── di/             # Dependency injection
│   ├── error/          # Error handling
│   ├── usecase/        # Base use case
│   └── utils/          # Utilities
├── data/               # Data layer
│   ├── datasources/    # Local database (Drift)
│   ├── models/         # Data models
│   └── repositories/   # Repository implementations
├── domain/             # Domain layer
│   ├── entities/       # Business entities
│   ├── repositories/   # Repository interfaces
│   └── usecases/       # Business logic
└── presentation/       # Presentation layer
    ├── blocs/          # State management (BLoC)
    ├── screens/        # UI screens
    └── widgets/        # Reusable widgets
```

## Clean Architecture Layers

### Domain Layer (innermost)
- Contains business logic and entities
- No dependencies on other layers
- Pure Dart code

### Data Layer
- Implements domain repositories
- Handles data sources (database, API)
- Data models with mappers

### Presentation Layer (outermost)
- BLoC for state management
- UI components
- Depends on domain layer only

## State Management

This project uses **BLoC (Business Logic Component)** pattern:

- **Events**: User actions or system events
- **States**: UI state representation
- **BLoC**: Business logic processing events and emitting states

Example flow:
```
User Action → Event → BLoC → Use Case → Repository → Data Source
                                ↓
                            State Update
                                ↓
                            UI Rebuild
```

## Database (Drift)

Drift is used for type-safe SQLite operations:

1. Define tables in `lib/data/datasources/database/database.dart`
2. Run code generation to create DAOs
3. Use generated code in repositories

## Testing

Run all tests:
```bash
flutter test
```

Run tests with coverage:
```bash
flutter test --coverage
```

View coverage report:
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Code Style

This project follows strict linting rules defined in `analysis_options.yaml`:

- Use `const` constructors where possible
- Prefer final variables
- Use trailing commas
- Follow Clean Code principles

Run analyzer:
```bash
flutter analyze
```

Fix auto-fixable issues:
```bash
dart fix --apply
```

## Adding New Features

### 1. Add Use Case (Domain Layer)
Create a new use case in `lib/domain/usecases/`:
```dart
class YourUseCase implements UseCase<ReturnType, Params> {
  // Implementation
}
```

### 2. Update Repository (Data Layer)
Add method to repository interface and implementation.

### 3. Create BLoC Events and States (Presentation Layer)
Define events and states for the feature.

### 4. Update BLoC
Add event handlers in the BLoC.

### 5. Create UI
Build screens and widgets for the feature.

## Common Tasks

### Add a new dependency
1. Add to `pubspec.yaml`
2. Run `flutter pub get`

### Update database schema
1. Modify table definition in `database.dart`
2. Increment `schemaVersion`
3. Add migration if needed
4. Run code generation

### Create a new screen
1. Create folder in `lib/presentation/screens/`
2. Create screen widget
3. Add navigation

## Troubleshooting

### Code generation fails
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Database errors
- Check table definitions
- Verify generated code exists
- Ensure database version is incremented for schema changes

### State not updating
- Check if event is being added to BLoC
- Verify BLoC is listening to events
- Ensure state has proper `copyWith` implementation

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Drift Documentation](https://drift.simonbinder.eu/)
- [BLoC Library](https://bloclibrary.dev/)
- [fpdart Documentation](https://pub.dev/packages/fpdart)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
