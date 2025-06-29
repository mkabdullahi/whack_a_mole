# Whack-a-Mole

A fun, cross-platform Flutter game where you tap moles as they pop out of holes! Built with Riverpod for state management and supports Android, iOS, Web, macOS, Linux, and Windows.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x or later)
- Dart (comes with Flutter)
- Android Studio, Xcode, or VS Code (for running on devices/emulators)
- Java 11 or 17 for Android builds

### Installation
1. **Clone the repository:**
   ```bash
   git clone <your-repo-url>
   cd whack_a_mole
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run the app:**
   - On a device/emulator:
     ```bash
     flutter run
     ```
   - For web:
     ```bash
     flutter run -d chrome
     ```

---

## 🕹️ Gameplay
- Tap the moles as they appear to score points.
- Avoid tapping bombs!
- King moles give extra points.
- Track your score and compete on the leaderboard.

---

## 📁 Project Structure
- `lib/`
  - `main.dart` — App entry point
  - `logic/` — Game logic and providers
  - `screens/` — UI screens (Home, Game, Leaderboard)
  - `widgets/` — Custom widgets (e.g., MoleWidget)
- `assets/images/` — Game images (mole, king mole, bomb, hole, background)
- `assets/sounds/` — Game sounds (whack, bomb, etc.)
- `test/` — Widget and logic tests

---

## 🛠️ Customization
- **Add new moles or sounds:** Place new images in `assets/images/` and sounds in `assets/sounds/`, then update `pubspec.yaml`.
- **Change game logic:** Edit files in `lib/logic/`.

---

## 🧑‍💻 Technical Details
- **State Management:** [Riverpod](https://riverpod.dev/)
- **Audio:** [audioplayers](https://pub.dev/packages/audioplayers)
- **Animations:** Flutter's built-in animation widgets
- **Cross-platform:** Android, iOS, Web, Desktop

---

## 📝 Contributing
1. Fork the repo
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes
4. Push and open a Pull Request

---

## 📄 License
This project is licensed under the MIT License.

---

## 🙋 FAQ
- **Q: How do I add new levels or moles?**
  - A: Add new assets and update the logic in `game_provider.dart`.
- **Q: The app won’t build on Android!**
  - A: Make sure you’re using Java 11 or 17 and have the correct Android SDK installed.

---

## 📚 Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [audioplayers Documentation](https://pub.dev/packages/audioplayers)
