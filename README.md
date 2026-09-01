# ResQ

ResQ is a Flutter application designed to provide rescue and emergency response features. This project uses modern Flutter architecture and includes modular features such as authentication, home dashboard, and user profile management.

## 🚀 Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### 📋 Prerequisites

Before you begin, ensure you have the following installed on your machine:
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (Ensure you are on the `stable` channel)
* [Dart SDK](https://dart.dev/get-dart)
* IDE of your choice ([VS Code](https://code.visualstudio.com/), [Android Studio](https://developer.android.com/studio), or IntelliJ) with Flutter & Dart plugins installed.
* An emulator (Android/iOS) or a physical device connected with USB debugging enabled.

### 🛠️ Installation & Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/gpgovindapromod/ResQ.git
   cd ResQ
   ```

2. **Install dependencies**
   Fetch the necessary packages by running:
   ```bash
   flutter pub get
   ```

3. **Run the App**
   Connect your device or start your emulator, then run:
   ```bash
   flutter run
   ```
   If you have multiple devices connected, you can choose one by running `flutter run -d <device_id>`.

## 📁 Project Structure

This project follows a feature-based architecture to maintain clean code and easy scalability:
- `lib/features/`: Contains all the app's features (Auth, Home, Profile, Splash).
- `lib/core/`: Contains core configurations like routing (`app_router.dart`) and themes (`app_theme.dart`).
- `lib/shared/`: Contains shared, reusable UI widgets.

## 📦 Building for Production

To build a release APK for Android:
```bash
flutter build apk --release
```

To build a release app for iOS:
```bash
flutter build ios --release
```

## 🤝 Contribution Guidelines

1. Make sure to fetch the latest changes from the `main` branch before starting your work.
2. Create a new feature branch (`git checkout -b feature/your-feature-name`).
3. Commit your changes with descriptive commit messages.
4. Push to your branch and create a Pull Request against the `main` branch.

---
*For further help with Flutter, refer to the [online documentation](https://docs.flutter.dev/).*
