# Travel Journal

A gorgeous, feature-rich Flutter mobile application designed to document journeys, record memories, explore countries of the world, and gamify travel activity.

Built with Flutter, Firebase, interactive maps, local photo storage, background location checks, and a polished Material 3 UI.

---

## Preview

<p align="center">
  <img src="docs/screenshots/Zrzut%20ekranu%202026-06-29%20o%2012.15.26%2012.18.16%281%29.png" width="30%" alt="Account and activity statistics screen" />
  <img src="docs/screenshots/Zrzut%20ekranu%202026-06-29%20o%2012.15.30%2012.18.16.png" width="30%" alt="Interactive 3D globe map screen" />
  <img src="docs/screenshots/Zrzut%20ekranu%202026-06-29%20o%2012.15.43%2012.18.16.png" width="30%" alt="Countries list screen" />
</p>

---

## Core Features

* 🌐 **Interactive 2D & 3D Maps**
  Toggle between a traditional flat map and an interactive 3D Earth globe showing visited countries and travel markers.

* 🗺️ **REST Countries Integration**
  Browse countries, view details such as capital, flag, population and region, search through the list, and display localized country data.

* 📍 **Planned Places & Background Location**
  Pin places you plan to visit on the map. Android background checks can monitor nearby planned places and trigger local notifications when you get close.

* 📸 **Global Camera Overlay**
  A floating camera button is available across the app for quick travel photos. Captured photos are stored in a dedicated local gallery.

* 📝 **Personal Trip Diary**
  Add detailed trip entries, associate them with countries, select travel dates, and attach photos to preserve memories.

* 🏆 **Gamification & Profile Stats**
  Track active days, streaks, visited countries, diary notes, added photos, activity calendar, and achievement progress.

* ☁️ **Cross-Device Sync**
  Firebase Authentication and Cloud Firestore are used to synchronize user data such as visited countries, planned places, and diary entries.

* 🌎 **Localization**
  English and Polish localization support with dynamic language switching.

* 🎨 **Polished Material 3 Theme**
  Clean Material 3 design system with custom light and dark themes based on soft slate and teal/cyan color palettes.

---

## Tech Stack

* **Flutter**
* **Dart**
* **Firebase Auth**
* **Cloud Firestore**
* **flutter_bloc / Cubit**
* **get_it dependency injection**
* **Freezed**
* **Retrofit / Dio**
* **Geolocator**
* **Shared Preferences**
* **Flutter Local Notifications**
* **Flutter Background Service**
* **flutter_map / OpenStreetMap**
* **flutter_earth_globe**

---

## Code Architecture & Project Structure

The project follows a **Feature-First** architecture combined with clean separation between presentation, business logic, and data layers.

```txt
lib/
  ├── core/
  │    ├── constants/           # Global assets and URL constants
  │    ├── data/                # Shared database and collection keys
  │    ├── di/                  # Dependency injection via get_it
  │    ├── network/             # HTTP client configuration via Dio
  │    ├── settings/            # App-wide settings logic: theme and locale
  │    └── theme/               # Material 3 light/dark style definitions
  │
  ├── features/
  │    ├── account/             # Profile, activity statistics, achievements
  │    ├── auth/                # Login, registration, Firebase Auth Gate
  │    ├── countries/           # Countries API, search, pagination, details
  │    ├── home/                # Main shell navigation layout
  │    ├── map/                 # 2D map, 3D globe, location services
  │    ├── photo_gallery/       # Local gallery and global camera overlay
  │    ├── planned_places/      # Planned places, distance checks, notifications
  │    ├── trip_diary/          # Travel diary entries and photo attachments
  │    └── visited_countries/   # Firestore-synced visited countries
  │
  └── main.dart                 # App entry point, Firebase setup and services
```

---

## Modular Components Breakdown

| Feature Module           | Path                              | Responsibilities                                                               |
| :----------------------- | :-------------------------------- | :----------------------------------------------------------------------------- |
| **Authentication**       | `lib/features/auth/`              | Sign-in, registration, session routing, Firebase Auth integration              |
| **Countries**            | `lib/features/countries/`         | REST Countries API, search, pagination, localized display models               |
| **Visited Countries**    | `lib/features/visited_countries/` | Marking countries as visited and syncing them with Firestore                   |
| **Map & Location**       | `lib/features/map/`               | 2D map, 3D globe, current location, markers, zoom and map controls             |
| **Planned Places**       | `lib/features/planned_places/`    | Planned map points, distance calculations, background checks and notifications |
| **Trip Diary**           | `lib/features/trip_diary/`        | Journal entry forms, dates, countries, descriptions and photo attachments      |
| **Photo Gallery**        | `lib/features/photo_gallery/`     | Local photo storage, previews and global camera access                         |
| **Stats & Achievements** | `lib/features/account/`           | Activity statistics, streaks, photos, notes, visited countries and heatmap     |

---

## Web Demo

The app can be deployed as a Flutter Web demo, mainly for UI preview purposes.

Some native mobile features are limited or disabled on web:

* Android foreground service
* background location behavior
* native notification behavior
* full camera/background behavior

The full feature set should be tested on a real Android device using an APK build.

---

## Getting Started

### Prerequisites

1. **Flutter SDK** installed and configured.
2. **Firebase project** with Authentication and Cloud Firestore enabled.
3. **CocoaPods** for iOS builds on macOS.
4. REST Countries API token configured in `.env`.

---

### 1. Clone the Repository

```bash
git clone <repository_url>
cd travel_journal_app
```

---

### 2. Environment Variables

Create a `.env` file in the root of the project:

```bash
cp .env.example .env
```

Add your REST Countries API token:

```env
REST_COUNTRIES_TOKEN=your_token_here
```

---

### 3. Firebase Configuration

Configure Firebase for the required platforms:

```bash
flutterfire configure
```

Alternatively, update:

```txt
lib/firebase_options.dart
```

---

### 4. Install Dependencies

```bash
flutter pub get
```

---

### 5. Run Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

### 6. Run the App

```bash
flutter run
```

---

### 7. Analyze the Project

```bash
flutter analyze
```

---

### 8. Run Tests

```bash
flutter test
```

---

## Android Build

```bash
flutter build apk --release
```

APK output:

```txt
build/app/outputs/flutter-apk/app-release.apk
```

---

## Web Build

```bash
flutter build web --release --base-href /
```

Web output:

```txt
build/web
```

---

## Project Status

This project is currently in active development.

Current focus:

* background location hardening
* planned-place notification flow
* Android real-device testing
* web demo stability
* improved map interactions
* production-ready release configuration

---

## Notes

This repository contains a Flutter mobile application. The web version is intended as a visual demo and does not fully replace Android/iOS testing.
