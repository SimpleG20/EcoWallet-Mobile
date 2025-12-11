#!/bin/bash

# EcoWallet Setup Script
# This script helps set up the development environment

echo "🌿 EcoWallet Setup Script"
echo "=========================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first:"
    echo "   https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter is installed"
flutter --version
echo ""

# Get Flutter dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed"
echo ""

# Run code generation
echo "🔧 Running code generation..."
flutter pub run build_runner build --delete-conflicting-outputs

if [ $? -ne 0 ]; then
    echo "⚠️  Code generation failed. You may need to fix errors and run manually:"
    echo "   flutter pub run build_runner build --delete-conflicting-outputs"
else
    echo "✅ Code generation completed"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Run the app: flutter run"
echo "  2. Run tests: flutter test"
echo "  3. Check the DEVELOPMENT.md for more information"
echo ""
