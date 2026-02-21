# 💰 EcoWallet - Professional Flutter Portfolio Project

A comprehensive Financial Management App built with Flutter, demonstrating **Clean Architecture**, **BLoC pattern**, and **Offline-First** capabilities. This project showcases mid-to-senior level Flutter development practices suitable for portfolio and professional use.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 🎯 Module Purpose & Overview

EcoWallet is a feature-rich financial management application that helps users track income and expenses with a clean, intuitive interface. The primary objective is to deliver a scalable, testable, and robust local-first application while following Solid and Clean Architecture principles.

The project emphasizes:
- **Feature-First Clean Architecture** for maintainability and scalability
- **BLoC Pattern** for predictable, reactive state management
- **Offline-First** approach using SQLite/Drift
- **Functional Error Handling** with `fpdart`
- **Dependency Injection** with `get_it` and `injectable`
- **Declarative Navigation** with `go_router`
- **Data Protection** and automatic encrypted backups

## ✨ Features

- 📊 **Transaction Management**: Add, view, and delete income/expense/reservation transactions
- 💵 **Balance & Wallet Tracking**: Real-time balance calculation and multi-wallet UI concepts
- 🗂️ **Dashboard & Charts**: Visual data representation using `fl_chart`
- ⚙️ **Settings & Preferences**: Customizable UI scaling, Color Blind Mode, Dark/Light Themes
- 🌙 **Localization**: Fully localized in English and Portuguese
- 💾 **Automated Backups**: Local database backups triggered automatically based on state changes
- 🎨 **Modern UI**: Clean, intuitive interface with Material Design 3

## 🏗️ Architecture

This project follows a **Feature-First Clean Architecture** approach. Instead of grouping by layer globally, the application is divided by functional features, and each feature is subdivided into standard architecture layers:

### Feature Layers
1. **Domain Layer (Business Logic)**
   - **Entities**: Core business objects
   - **Repositories**: Abstract interfaces for data operations
   - **Use Cases**: Business logic encapsulation, returning `Either` from `fpdart`
   - **Enums/Types**: Domain-specific states

2. **Data Layer**
   - **Models**: Data transfer objects with Equatable/JsonSerializable
   - **Repositories**: Concrete implementations mapping Database to Domain
   - **Data Sources**: Local database definitions (Drift/SQLite)

3. **Presentation Layer**
   - **BLoC**: State management reacting to events and yielding states
   - **Screens**: UI views driven by BlocBuilder/BlocListener
   - **Widgets**: Reusable presentational components

### Directory Structure
```
lib/
├── core/
│   ├── config/        # App configuration & environment
│   ├── constants/     # Global constants and styles
│   ├── database/      # Core Drift DB setup
│   ├── errors/        # Failure and Exception classes
│   ├── presentation/  # Core UI widgets & layouts
│   ├── router/        # GoRouter configuration
│   ├── services/      # Global services (Notifications, Backups)
│   ├── theme/         # Material 3 Theme configurations
│   └── usecases/      # Base UseCase definitions
├── features/
│   ├── auth/          # Global authentication state
│   ├── home/          # Main dashboard & navigation
│   ├── login/         # Login presentation
│   ├── register/      # Registration presentation
│   ├── settings/      # App preferences & theming
│   ├── transactions/  # Transaction CRUD operations
│   ├── user/          # User profile management
│   └── wallet/        # Wallet balances and accounts
├── l10n/              # ARB files for localization
├── injection_container.dart # GetIt & Injectable setup
└── main.dart          # Entry point
```

## 🛠️ Tech Stack & Dependencies

- **Framework**: [Flutter](https://flutter.dev/) (Material 3)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Navigation**: [go_router](https://pub.dev/packages/go_router)
- **Database**: [sqflite](https://pub.dev/packages/sqflite) & [drift](https://pub.dev/packages/drift)
- **Functional Programming**: [fpdart](https://pub.dev/packages/fpdart)
- **Dependency Injection**: [get_it](https://pub.dev/packages/get_it) & [injectable](https://pub.dev/packages/injectable)
- **Code Generation**: [drift_dev](https://pub.dev/packages/drift_dev)
- **UI/UX**: [fl_chart](https://pub.dev/packages/fl_chart) & [google_fonts](https://pub.dev/packages/google_fonts)

## 🚀 Getting Started (Usage Examples)

### Prerequisites
- Flutter SDK (≥ 3.2.0 < 4.0.0)
- Android Studio / VS Code with Flutter extensions
- Android/iOS Emulator or physical device

### Installation & Build

1. **Clone the repository**
   ```bash
   git clone https://github.com/SimpleG20/EcoWallet-Mobile.git
   cd EcoWallet-Mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run Code Generation** (Important for DI and Drift)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
   *(During active development, run: `dart run build_runner watch --delete-conflicting-outputs`)*

4. **Run the App**
   ```bash
   flutter run
   ```

### 🧪 Testing
The architecture enforces Test-Driven Development (TDD) principles. Run unit and widget tests using:
```bash
flutter test
flutter test --coverage
```

## � Scaling/Extension Guide

As the application grows, adhere to the following principles to maintain a robust and scalable architecture:

1. **Adding a New Feature**:
   - Create a new folder under `lib/features/`.
   - Scaffold the structure: `domain`, `data`, `presentation`.
   - Start by defining the `Entities` and `UseCases` in testing before wiring up the `Data` and `Presentation` layers.
   - Run `build_runner` to register new `@Injectable` dependencies or Drift adjustments.

2. **Adding Third-Party or System Integration (e.g., Cloud Sync)**:
   - Encapsulate the external library behind an interface located in a specific feature's `domain/repositories` or `core/services`.
   - Implement the concrete class in the `data/` layer.
   - This ensures the UI and UseCases remain entirely decoupled from specific network or database vendor packages.

3. **Global State changes**:
   - Define global states (like settings or user session) as feature Blocs and mount them high in the widget tree (in `main.dart`'s `MultiBlocProvider`).
   - Listen to them downstream using standard `BlocBuilder` without directly fetching from local storage.

## 🤝 Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author
**SimpleG20**
- GitHub: [@SimpleG20](https://github.com/SimpleG20)

---
⭐ If you found this project helpful, please give it a star!
