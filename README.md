# Travel Journal

A gorgeous, feature-rich Flutter mobile application designed to document your journeys, record memories, explore countries of the world, and gamify your travels.

## Core Features

- 🌐 **Interactive 2D & 3D Maps**: Toggle between a traditional flat map (via `flutter_map` / OpenStreetMap) and a stunning, interactive 3D Earth Globe (via `flutter_earth_globe`) showing your visited countries.
- 🗺️ **REST Countries Integration**: Browse the list of world countries, view details (capital, flag, population, region), search, and paginate through lists.
- 📍 **Geofencing & Background Tasks**: Pin places you plan to visit on the map. The background service (`flutter_background_service`) tracks your location and alerts you via local notifications when you get close (e.g. within 1000m) to capture the moment.
- 📸 **Global Camera Overlay**: A floating camera button (`GlobalCameraOverlay`) is available across the app for quick snaps. Photos are stored in a dedicated local gallery.
- 📝 **Personal Trip Diary**: Add detailed logs of your trips, associate them with specific countries, date them, and attach up to a set limit of photos.
- 🏆 **Gamification & Profile Stats**: Track your active check-in streaks, view your activity calendar, and unlock 12 unique achievements (e.g., "Citizen of the World", "Memory Collector") as you travel.
- ☁️ **Cross-Device Sync**: Multi-device synchronization of your diary, planned places, and visited countries using Firebase Authentication and Cloud Firestore.
- 🌎 **Localization**: Full multi-language support (English and Polish) out of the box, adapting dynamically to system settings or user preference.
- 🎨 **Polished Material 3 Theme**: Clean Material 3 design system with custom light and dark themes, featuring sleek slate and teal/cyan color palettes.

---

## Code Architecture & Project Structure

The project follows a **Feature-First** architecture combined with **Clean Architecture** patterns (separating presentation, business logic, and data layers).

```txt
lib/
  ├── core/                     # Shared foundation and configuration
  │    ├── constants/           # Global assets and URL constants
  │    ├── data/                # Shared database / collection keys
  │    ├── di/                  # Dependency Injection via get_it
  │    ├── network/             # HTTP Client config via Dio
  │    ├── settings/            # App-wide settings logic (Theme, Locale)
  │    └── theme/               # Material 3 light/dark style definitions
  │
  ├── features/                 # Modular, feature-focused directories
  │    ├── account/             # Profile, activity statistics, and gamified achievements
  │    ├── auth/                # Login, registration, and Auth Gate via Firebase Auth
  │    ├── countries/           # REST Countries API listing, search, pagination, and details
  │    ├── home/                # Main shell navigation layout
  │    ├── map/                 # 2D Map Page, 3D Globe, and location services
  │    ├── photo_gallery/       # Centralized media folder, previews, and global camera float
  │    ├── planned_places/      # Geolocation targets, distance checkers, and background geofencing
  │    ├── trip_diary/          # Travel log journal entries, limits, and photo attachments
  │    └── visited_countries/   # Firestore-synced list of visited countries
  │
  └── main.dart                 # Application entry point (initialization of Firebase, DB & background tasks)
```

### Modular Components Breakdown

| Feature Module | Path | Responsibilities & Pattern |
| :--- | :--- | :--- |
| **Authentication** | `lib/features/auth/` | Handles sign-in/up logic, email/password validation, and session routing via `AuthGate` & `AuthBloc`. |
| **Countries Service** | `lib/features/countries/` | Connects to REST Countries API. Manages search querying, local list pagination, and localized model mappings. |
| **Visited Countries** | `lib/features/visited_countries/` | Stores marked country IDs locally and synchronizes them with Firestore collections under the user account. |
| **Map & Location** | `lib/features/map/` | Integrates `DeviceLocationService` with interactive maps. Renders custom marker styles, zooms, and rotation buttons. |
| **Planned Places** | `lib/features/planned_places/` | Handles coordinates distance calculation and manages background tasks and background geolocator queries. |
| **Trip Diary** | `lib/features/trip_diary/` | Implements journal entry forms, photo attachment limitations, custom schemas, and database synchronization. |
| **Photo Gallery** | `lib/features/photo_gallery/` | Manages image resources and overlays a custom global camera float across pages. |
| **Stats & Achievements**| `lib/features/account/` | Calculates travel achievements (streaks, photos, diaries, visited flags) and builds activity heatmaps. |

---

## Getting Started & Running Locally

### Prerequisites

1.  **Flutter SDK**: Installed and configured (minimum version specified in `pubspec.yaml`).
2.  **Firebase CLI & Project**: A Firebase project with Authentication and Cloud Firestore enabled.
3.  **Cocoapods**: Required for building the iOS version on macOS.

### Setup Instructions

1.  **Clone the Repository**:
    ```bash
    git clone <repository_url>
    cd travel_journal_app
    ```

2.  **Environment Variables**:
    Create a `.env` file in the root of the project by copying `.env.example`:
    ```bash
    cp .env.example .env
    ```
    Add your API token for the REST Countries API inside `.env`.

3.  **Firebase Configuration**:
    Configure Firebase for Android/iOS targets by running:
    ```bash
    flutterfire configure
    ```
    *(Alternatively, replace/configure options in `lib/firebase_options.dart` directly.)*

4.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

5.  **Run Code Generation**:
    Build `freezed` and `json_serializable` generated parts:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

6.  **Run the Application**:
    Launch on an emulator, simulator, or connected device:
    ```bash
    flutter run
    ```

7.  **Run Tests**:
    Execute the test suites to ensure everything works correctly:
    ```bash
    flutter test
    ```