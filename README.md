# 💰 EcoWallet - Professional Flutter Portfolio Project

A comprehensive Financial Management App built with Flutter, demonstrating **Clean Architecture**, **BLoC pattern**, and **Offline-First** capabilities. This project showcases mid-to-senior level Flutter development practices suitable for portfolio and professional use.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 🎯 Project Overview

EcoWallet is a feature-rich financial management application that helps users track income and expenses with a clean, intuitive interface. The project emphasizes:

- **Clean Architecture** for maintainability and testability
- **BLoC Pattern** for predictable state management
- **Offline-First** approach using SQLite/Drift
- **Functional Error Handling** with fpdart
- **Dark Mode** support
- **Type-Safe** code generation with Freezed

## ✨ Features

- 📊 **Transaction Management**: Add, view, and delete income/expense transactions
- 💵 **Balance Tracking**: Real-time balance calculation and display
- 🗂️ **Category Organization**: Predefined categories for income and expenses
- 📅 **Date Filtering**: View transactions by date range
- 🌙 **Dark Mode**: Beautiful light and dark theme support
- 💾 **Offline-First**: All data stored locally with SQLite/Drift
- 🎨 **Modern UI**: Clean, intuitive interface with Material Design 3

## 🏗️ Architecture

This project follows **Clean Architecture** principles with three main layers:

### 1. Domain Layer (Business Logic)
- **Entities**: Core business objects (Transaction)
- **Repositories**: Abstract interfaces for data operations
- **Use Cases**: Business logic encapsulation

### 2. Data Layer
- **Models**: Data transfer objects with Freezed
- **Repositories**: Concrete implementations
- **Data Sources**: Local database with Drift

### 3. Presentation Layer
- **BLoC**: State management using flutter_bloc
- **Screens**: UI components
- **Widgets**: Reusable UI elements

```
lib/
├── core/
│   ├── constants/     # App-wide constants
│   ├── di/            # Dependency injection
│   ├── error/         # Error handling
│   ├── usecase/       # Base use case
│   └── utils/         # Utility functions
├── domain/
│   ├── entities/      # Business entities
│   ├── repositories/  # Repository interfaces
│   └── usecases/      # Business use cases
├── data/
│   ├── datasources/   # Local database
│   ├── models/        # Data models
│   └── repositories/  # Repository implementations
└── presentation/
    ├── blocs/         # State management
    ├── screens/       # UI screens
    └── widgets/       # Reusable widgets
```

## 🛠️ Tech Stack

- **Flutter** - UI framework
- **Dart** - Programming language
- **flutter_bloc** - State management
- **Drift** - Type-safe SQLite database
- **fpdart** - Functional programming and error handling
- **get_it** - Dependency injection
- **Freezed** - Code generation for immutable classes
- **google_fonts** - Typography
- **fl_chart** - Data visualization (ready for charts)

## 📦 Dependencies

```yaml
dependencies:
  # State Management
  flutter_bloc: ^8.1.3
  
  # Functional Programming
  fpdart: ^1.1.0
  
  # Database
  drift: ^2.14.1
  sqlite3_flutter_libs: ^0.5.18
  
  # Dependency Injection
  get_it: ^7.6.4
  
  # Code Generation
  freezed_annotation: ^2.4.1
  
  # UI
  google_fonts: ^6.1.0
  fl_chart: ^0.65.0
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/SimpleG20/EcoWallet-Mobile.git
   cd EcoWallet-Mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🧪 Testing

Run tests with:
```bash
flutter test
```

Run tests with coverage:
```bash
flutter test --coverage
```

## 📝 Code Generation

This project uses code generation for:
- **Drift**: Database code generation
- **Freezed**: Immutable model generation (future)
- **Injectable**: Dependency injection (future)

To generate code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

To watch for changes:
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## 🎨 UI/UX

The app features a modern, clean design with:
- Material Design 3 components
- Smooth animations and transitions
- Responsive layouts
- Accessible color schemes
- Dark mode support

## 📱 Screenshots

## 🔜 Future Enhancements

- [ ] Budget planning and tracking
- [ ] Expense analytics with charts
- [ ] Recurring transactions
- [ ] Export data to CSV/PDF
- [ ] Cloud sync (Firebase)
- [ ] Biometric authentication
- [ ] Multi-currency support
- [ ] Receipt scanning with OCR

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**SimpleG20**

- GitHub: [@SimpleG20](https://github.com/SimpleG20)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- All open-source contributors whose packages made this possible
- Clean Architecture principles by Robert C. Martin

---

⭐ If you found this project helpful, please give it a star!
