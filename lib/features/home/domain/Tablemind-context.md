Here is a **comprehensive, highly detailed `README.md`** file for your **Tablemind** project.

I have structured it to give **any developer (or your future self)** full context of the architecture, UI flow, state management, and exact implementation details we have built so far.

You can save this directly as `README.md` in the root of your Flutter project.

---

````markdown
# Tablemind - AI Restaurant Menu Assistant

Tablemind is a minimalist, premium mobile application that uses Conversational AI to summarize, analyze, and suggest dishes from restaurant menus. Users can upload menus via Camera, File (PDF/JPEG/PNG), Links, or QR Scanners, and chat with an AI about the food.

---

## 🚀 Tech Stack & Architecture

- **Language:** Dart (Flutter 3.x)
- **State Management:** Flutter Riverpod (StateNotifierProvider)
- **Navigation:** GoRouter
- **Architecture Pattern:** MVVM (Model-View-ViewModel) with Clean Architecture
- **Design System:** Custom, Minimalist Black & White

---

## 📂 Project Structure

The project follows a **Feature-First** modular architecture combined with Clean Architecture principles (Presentation, Domain, Data).

```text
lib/
├── app/                           # App-wide configurations
│   ├── app.dart                   # Root MaterialApp.router
│   ├── router.dart                # GoRouter setup & Provider
│   ├── routes.dart                # Route string constants
│   └── theme.dart                 # Global ThemeData
│
├── core/                          # Core utilities shared across all features
│   ├── animations/                # Custom loading/pulse animations
│   ├── constants/                 # App strings, colors, assets
│   ├── enums/                     # Global Enums (e.g., UploadSource)
│   ├── extensions/                # Custom extension methods
│   ├── services/                  # Native services (Camera, FilePicker, Scanner)
│   ├── storage/                   # Local storage (Hive/SharedPreferences)
│   ├── utils/                     # Helper functions
│   └── widgets/                   # Globally reusable UI components
│       └── split_action_button.dart # Main customizable button widget
│
├── features/                      # All feature modules
│   ├── auth/                      # (Future) User authentication
│   ├── home/                      # Home Screen + Upload logic
│   │   ├── presentation/          # UI Layer (HomeScreen)
│   │   ├── domain/                # Business Logic (HomeViewModel, UseCase)
│   │   └── data/                  # Data Layer (HomeRepository)
│   ├── search/                    # Google Business search integration
│   ├── scanner/                   # QR & Link handling
│   ├── upload/                    # File/Image upload handlers
│   ├── processing/                # AI loading / Menu Scan screen
│   ├── chat/                      # AI Conversational interface
│   ├── history/                   # Recent restaurant records
│   └── profile/                   # (Future) User profile
│
├── shared/                        # Shared domain logic across features
│   ├── entities/                  # Core domain models (e.g., Menu, Restaurant)
│   ├── models/                    # DTOs / JSON models
│   ├── repositories/              # Shared repositories (e.g., AI API calls)
│   └── widgets/                   # Shared UI (RecentBar, LinkBottomSheet)
│
└── main.dart                      # Entry point with ProviderScope
```
````

---

## 🧠 State Management (Riverpod + MVVM)

We strictly follow the **MVVM pattern**. The UI is entirely decoupled from business logic.

### 1. The ViewModel (`home_view_model.dart`)

- Extends `StateNotifier`.
- Holds business logic and handles user interactions (e.g., `onCameraTap()`).
- Coordinates with `UseCase` and `GoRouter` to trigger navigation or native device services.

### 2. The UseCase (`home_usecase.dart`)

- Acts as a single entry point for business rules.
- Calls the Repository.

### 3. The Repository (`home_repository.dart`)

- The **only** place where native device calls happen.
- Uses packages like `image_picker` and `file_picker` to return file paths to the ViewModel.

### 4. The Provider (`router.dart` & `home_view_model.dart`)

- Global providers (`Provider` & `StateNotifierProvider`) are defined to inject dependencies automatically.

---

## 🎨 UI & Interaction Highlights

### 1. Split Action Button (`SplitActionButton`)

A reusable `StatefulWidget` built exactly to Figma specs (70/30 split).

- **Behavior:** On tap, the background and text colors instantly swap (Black ↔ White) providing a tactile "flash" effect.
- **Separate Interactions:** The Left 70% and Right 30% act as independent buttons with their own `onTapDown`, `onTapCancel`, and `onTap` callbacks for independent splash animations.

### 2. Home Screen Navigation Flow

- **Camera & Upload:** Main button opens native Camera; Right icon opens native File Picker.
- **Link & Scanner:** Main button opens a custom Dialog (`LinkMenuBottomSheet`); Right icon opens QR Scanner.
- **Search Restaurant:** Pushes to `SearchScreen` (Google Places API).

### 3. Recent Drawer (History)

- **Native Stack Implementation:** To avoid the jagged "patchy" feeling of `showModalBottomSheet`, we built a custom `Stack` + `AnimationController` layout.
- **Synced Movement:** The `RecentBar` (collapsed state) and the `RecentBottomSheet` (expanded state) are physically the same widget. When the user taps the bar or drags the handle, **both slide up and down in perfect sync** via a `SlideTransition`.

### 4. Processing / AI Loading

- A dedicated UI with a status progress bar and checklist animations ("Detecting menu structure...", "Parsing items...") to simulate AI processing time.

---

## 📱 User Flow Walkthrough

1. **Splash Screen:** Auto-transitions to Home after 2.5s.
2. **Home Screen:**
   - User selects an input method (Camera, File, Link, Search).
   - **Camera/File:** Returns a file path → Navigates to **Processing Screen**.
   - **Link/QR:** Returns a URL → Navigates to **Processing Screen**.
   - **Search:** User searches via Google Places → Selects a restaurant → Navigates to **Processing Screen**.
3. **Processing Screen:** Displays AI scanning animation. After 3-5 seconds, auto-transitions to **Preview Screen**.
4. **Preview Screen:** Shows a structured list of the parsed menu with prices.
5. **Chat Screen:** User taps "Chat with AI". Minimalist UI with text bubbles and an Audio button that triggers a **waveform visualizer** on press.

---

## 🔌 External Services & Dependencies

| Dependency                              | Purpose                                   |
| :-------------------------------------- | :---------------------------------------- |
| `flutter_riverpod`                      | State management                          |
| `go_router`                             | Advanced routing & deep linking           |
| `image_picker`                          | Access Native Camera & Gallery            |
| `file_picker`                           | Select PDF, JPEG, PNG from device storage |
| `bounce`                                | Subtle tactile button animations          |
| `google_maps_flutter` / `google_places` | (Future) Fetching Restaurant data         |

---

## 🏗️ Getting Started (Development Setup)

### Prerequisites

- Flutter SDK (>=3.0.0)
- Android Studio / VS Code
- iOS Simulator or Android Emulator

### Installation

1. Clone the repository.
   ```bash
   git clone <your-repo-url>
   ```
2. Navigate to the project directory.
   ```bash
   cd tablemind
   ```
3. Fetch dependencies.
   ```bash
   flutter pub get
   ```
4. Run the app.
   ```bash
   flutter run
   ```

---

## 🔄 Key Design Decisions & Why We Made Them

1. **No `showModalBottomSheet` for History:**
   - _Why?_ The built-in `showModalBottomSheet` exists on a completely different layer than the main screen. We switched to a `Stack` layout so the "Recent" bar can physically move _upwards_ with the sheet, creating a unified, native-feeling drawer.

2. **Separate State for Button Sides:**
   - _Why?_ The UI required the left and right sides of the button to have independent "ink splash" color inversions. Using `onTapDown` and `onTapCancel` local states achieves a premium "flash" effect without corrupting global app state.

3. **MVVM Data Flow:**
   - _Why?_ By forcing the UI (`HomeScreen`) to call the ViewModel, and the ViewModel to call the UseCase/Repository, we ensure that **device permissions and Native APIs are never accessed directly inside the Widget tree**. This makes unit testing and future feature expansion significantly easier.

---

## 📌 Current Status & Next Features

✅ **Phase 1 Completed:**

- Splash Screen
- Home Screen UI with Split Buttons
- Camera & File Picker integration
- Custom Smooth Recent Drawer
- Link Menu Bottom Sheet modal

⬜ **Phase 2 (In Progress):**

- Google Places Search integration
- QR Code Scanner integration
- Menu Processing / Loading UI
- Menu Preview Screen

⬜ **Phase 3 (Future):**

- AI Chat Interface (Text & Audio)
- Database / Local Storage for History
- Profile & Settings

---

## 📝 Contribution / Guidelines

- **Formatting:** Use `dart format` before committing.
- **Naming:** Features must follow the `presentation/domain/data` folder structure strictly.
- **Riverpod:** Never pass a `BuildContext` to a ViewModel. Use `GoRouter` via Dependency Injection instead.

---

## 🧑‍💻 Developer Notes

- **Navigation Context:** All navigation is handled in the ViewModels using `ref.read(routerProvider).push()`. This keeps the UI completely clean.
- **Dependency Injection:** Use `ref.watch()` for UI updates, and `ref.read()` for one-time actions inside the ViewModels.
- **Animation:** Use `CurvedAnimation(parent: controller, curve: Curves.easeOut)` for all drawer animations to maintain a premium feel.

```

### 💡 What to do with this file:
1. Create a file named `README.md` in the absolute root of your Flutter project folder.
2. Paste all the text above into it.
3. Save it.
4. Now, when you (or anyone else) opens your project in VS Code, GitHub, or any IDE, **they will have the full architectural blueprint** right at their fingertips.
```
