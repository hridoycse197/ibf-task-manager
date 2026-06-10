# IBF Task Manager

A clean architecture Flutter task management application with responsive design, built using GetX state management.

## Features

- Create, read, update, and delete tasks
- Mark tasks as active/completed
- Filter tasks by status (All, Active, Completed)
- View detailed task information
- Responsive design that adapts to different screen sizes
- Local data persistence with Isar database
- API integration for remote data
- Clean architecture with separation of concerns
- Loading skeletons with shimmer effects
- Dark mode support

## Architecture

This app follows Clean Architecture principles with clear separation of concerns:

```
lib/
├── core/              # Core utilities and error handling
├── data/              # Data layer (repositories, data sources, models)
├── domain/            # Domain layer (entities, use cases, repositories interfaces)
├── controllers/       # Presentation layer (controllers with GetX)
├── views/             # UI layer (screens, widgets)
├── routes/            # Navigation routing
└── bindings/          # Dependency injection
```

### Layer Responsibilities

- Domain Layer: Business logic and entities (independent of frameworks)
- Data Layer: Data sources, repositories implementation, and models
- Presentation Layer: Controllers (GetX) and UI components
- Core Layer: Shared utilities, error handling, and constants

## State Management: GetX

### Why GetX?

This application uses GetX as the state management solution for several compelling reasons:

#### 1. Simplicity and Boilerplate Reduction

- Minimal code required compared to Provider or Bloc
- No need for Boilerplate code like ChangeNotifier, BlocProvider, etc.
- Simple reactive programming with .obs (observable variables)

#### 2. Performance

- Smart state management with automatic dependency injection
- Only rebuilds widgets that actually need to update
- Efficient memory management with automatic disposal

#### 3. Navigation and Routing

- Built-in powerful routing system
- Named routes with easy navigation (Get.toNamed())
- No context needed for navigation (solves common Flutter issues)

#### 4. Dependency Injection

- Built-in DI container with Get.put() and Get.lazyPut()
- Automatic lifecycle management
- Easy testing with mock implementations

#### 5. Reactive Programming

- Simple reactive variables with .obs
- Obx() widget for automatic UI updates
- Works seamlessly with GetView for controller access

#### 6. Developer Experience

- Less code to write and maintain
- Easy to learn and use
- Great documentation and community support

### GetX in This App

```dart
// Controller with reactive state
class TaskController extends GetxController {
  final tasks = <TaskEntity>[].obs;      // Observable list
  final isLoading = false.obs;            // Observable boolean

  void loadTasks() {
    isLoading.value = true;                // Update state
    // ... fetch logic
    isLoading.value = false;
  }
}

// UI with automatic updates
Obx(() => Text(controller.tasks.length.toString()))
```

## How to Run the App

### Prerequisites

- Flutter SDK (3.11.5 or higher)
- Dart SDK (included with Flutter)
- Android Studio / Xcode (for mobile development)
- Code editor (VS Code, Android Studio, or IntelliJ IDEA)

### Installation Steps

1. Clone the repository

   ```bash
   git clone https://github.com/hridoycse197/ibf-task-manager.git
   cd ibf_task_manager
   ```

2. Install dependencies

   ```bash
   flutter pub get
   ```

3. Run the app

   ```bash
   # Run on connected device/emulator
   flutter run

   # Run on specific device
   flutter run -d <device-id>

   # Run on all connected devices
   flutter run -d all
   ```

### Development Mode

For hot reload during development:

```bash
flutter run --hot
```

### Build for Production

Android APK:

```bash
flutter build apk --release
```

Android App Bundle:

```bash
flutter build appbundle --release
```

iOS:

```bash
flutter build ios --release
```

### Available Scripts

```bash
# Analyze code for issues
flutter analyze

# Run tests
flutter test

# Format code
dart format .

# Clean build artifacts
flutter clean
```

## Responsive Design

The app uses flutter_screenutil for responsive design:

- Base Design Size: iPhone 14 Pro (390x844)
- Scaling Method: Automatic proportional scaling
- Extension Methods: .w (width), .h (height), .sp (font size), .r (radius)

### Responsive Patterns

```dart
// Instead of hardcoded values:
padding: EdgeInsets.all(16)
// Use responsive extensions:
padding: EdgeInsets.all(16.w)

// Font sizes
fontSize: 14.sp

// Icon sizes
size: 24.r

// Spacing
SizedBox(height: 16.h)
```

## Known Limitations

### 1. API Integration

- Status: Basic structure implemented but not fully tested with production APIs
- Current Implementation: Has TaskApi and seed data functionality
- Limitation: Error handling for network failures may need refinement
- Future Work: Add retry logic, request queuing, and better error messages

### 2. Data Synchronization

- Status: Local-first architecture with basic API sync
- Limitation: No automatic background synchronization
- Current Behavior: Manual refresh required to fetch latest data
- Future Work: Implement periodic sync and push notifications

### 3. Offline Capabilities

- Status: Works offline with local storage
- Limitation: Changes made offline are not queued for sync when online
- Current Behavior: Local changes persist but don't sync automatically
- Future Work: Implement operation queue for offline-to-online sync

### 4. Search and Filtering

- Status: Basic status filtering (All/Active/Completed)
- Limitation: No full-text search or advanced filtering
- Current Behavior: Can only filter by completion status
- Future Work: Add search by title, date range filtering, priority levels

### 5. User Interface

- Status: Functional and responsive
- Limitation: No tablet-specific layouts yet
- Current Behavior: Phone layout scales to tablets
- Future Work: Design tablet-optimized layouts with master-detail views

### 6. Data Persistence

- Status: Uses Isar database (fast, reliable)
- Limitation: No data export/backup functionality
- Current Behavior: Data persists locally only
- Future Work: Add data export to JSON, cloud backup options

### 7. Accessibility

- Status: Basic accessibility support
- Limitation: Screen reader optimization not fully tested
- Current Behavior: Semantic widgets used but not extensively tested
- Future Work: Full accessibility audit and improvements

### 8. Localization

- Status: English only
- Limitation: No internationalization (i18n) implemented
- Current Behavior: Hard-coded English strings
- Future Work: Add localization support for multiple languages

### 9. Testing

- Status: Basic project structure
- Limitation: Limited test coverage
- Current Behavior: No automated tests implemented
- Future Work: Add unit tests, widget tests, and integration tests

### 10. Error Handling

- Status: Basic error handling implemented
- Limitation: Generic error messages in some cases
- Current Behavior: Shows error but may not provide actionable guidance
- Future Work: Improve error messages with specific guidance

## Technology Stack

- Framework: Flutter 3.x
- Language: Dart 3.11.5+
- State Management: GetX
- Local Database: Isar
- HTTP Client: Dio
- Responsive Design: flutter_screenutil
- Functional Programming: Dartz (Either pattern for error handling)
- Date Formatting: intl
- UI Effects: shimmer

## Contributing

This is a learning project demonstrating clean architecture and best practices in Flutter development.

## License

This project is for educational purposes.

## Resources

- [GetX Documentation](https://pub.dev/packages/get)
- [Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture/)
- [Isar Database](https://isar.dev/)
- [flutter_screenutil](https://pub.dev/packages/flutter_screenutil)
