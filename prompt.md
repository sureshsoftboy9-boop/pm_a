# Photo Manager Mobile - Flutter Implementation

## License and Usage
This is an open-source project intended for personal use only. Not for commercial distribution or release on app stores. Feel free to fork, modify, and learn from the code while respecting the open-source spirit of the project.

## Project Overview
A modern Flutter-based photo management application for Android, based on the successful desktop Photo Manager. The app focuses on efficient photo organization, duplicate detection, and file management with an intuitive mobile interface. This is a self-hosted solution for users who want to maintain control over their photo management workflow without relying on cloud services or commercial applications.

## Core Features

### Photo Management & Viewing
- [x] Directory browsing with recursive option
- [x] Supported formats:
  - Standard: JPG, JPEG, PNG, GIF, BMP, WebP, TIFF
  - RAW: CR2, NEF, ARW, DNG, RAF, RW2, PEF, SRW, ORF
  - HEIF/HEIC
- [x] Thumbnail generation and strip navigation
- [x] Full-screen photo viewing with gesture support
- [x] EXIF data display and editing
- [x] Recent folders history (input and save locations)
- [x] Directory refresh functionality

### File Operations
- [x] Move/Copy with conflict resolution
- [x] Delete with undo capability
- [x] Batch operations
- [x] Progress tracking
- [x] Quick save to recent folders
- [x] Copy mode toggle (keep originals)

### Analysis & Organization
- [x] MD5-based duplicate detection
- [x] Small image flagging (< 500px or < 50KB)
- [x] Duplicate viewer features:
  - Side-by-side comparison
  - Batch selection
  - Size-based selection
  - Group operations (copy/move/delete)

### Image Processing
- [x] Rotation with EXIF preservation
- [x] JPEG conversion with quality selection
- [x] Batch conversion support
- [x] EXIF date editing (single/batch)

### Database Features
- [x] SQLite metadata storage:
  ```sql
  - File paths and names
  - Image dimensions
  - File sizes
  - Dates (taken/added)
  - MD5 hashes
  - Flag status
  ```
- [x] Indexed queries for performance
- [x] Recent folders tracking

## Mobile UI/UX Requirements

### Navigation & Layout
1. Bottom Navigation Bar
   - Browse Photos
   - Duplicates
   - Recent Folders
   - Settings

2. Main Photo Browser
   - Grid/List view toggle
   - Pull-to-refresh
   - FAB for actions
   - Folder path breadcrumb
   - Selection mode

3. Photo Viewer
   - Swipe navigation
   - Pinch zoom
   - Bottom sheet for actions
   - EXIF overlay
   - Quick actions

4. Duplicate Manager
   - Group view
   - Multi-select interface
   - Compare view
   - Batch actions

### Mobile-Specific Features
1. Permissions
   - Storage access
   - Media store integration
   - Scoped storage compliance

2. Performance
   - Lazy loading
   - Thumbnail caching
   - Background processing
   - Memory management

3. System Integration
   - Share functionality
   - Media store sync
   - File type handling

## Technical Architecture

### Flutter Implementation
```dart
// Key Components
- MaterialApp with theme support
- BLoC/Provider state management
- Repository pattern
- Clean architecture
- Async operations
- Stream-based updates
```

### Data Layer
1. Local Storage
   - SQLite database
   - Shared preferences
   - File system cache

2. Models
   - Photo metadata
   - EXIF data
   - Configuration
   - User preferences

3. Repositories
   - Photo repository
   - File operations
   - Settings management

### Business Logic
1. Use Cases
   - Photo operations
   - Duplicate detection
   - File management
   - Image processing

2. Services
   - Hash generation
   - Thumbnail creation
   - EXIF handling
   - File operations

## Development Phases

### 1. Foundation (2 weeks)
- Project setup
- Architecture implementation
- Storage permissions
- Basic navigation

### 2. Core Features (4 weeks)
- Photo browsing
- Basic file operations
- Thumbnail generation
- EXIF handling

### 3. Advanced Features (4 weeks)
- Duplicate detection
- Batch operations
- Image processing
- Undo system

### 4. Polish (2 weeks)
- UI refinement
- Performance optimization
- Testing
- Documentation

## Testing Strategy
1. Unit Tests
   - Business logic
   - Data operations
   - Utility functions

2. Widget Tests
   - UI components
   - User interactions
   - Navigation

3. Integration Tests
   - End-to-end flows
   - File operations
   - Database interactions

## Success Metrics
1. Performance
   - Smooth scrolling with 1000+ photos
   - Sub-second thumbnail loading
   - Efficient memory usage

2. Usability
   - Intuitive navigation
   - Clear feedback
   - Error handling

3. Reliability
   - Crash-free operation
   - Data integrity
   - Successful file operations

## Future Enhancements
1. Cloud backup
2. AI-based organization
3. Face recognition
4. Location clustering
5. Online duplicate detection
6. Advanced photo editing
7. Cloud storage integration

## Development Notes
1. Source code with documentation
2. Basic setup guide for personal deployment
3. API documentation for contributors
4. Test suite for reliability
5. Build instructions for personal use

## Open Source Guidelines
1. MIT License for maximum flexibility
2. Contributions welcome through pull requests
3. No tracking or analytics
4. Privacy-focused development
5. Self-hosted only - no cloud dependencies
6. Community-driven improvements welcome
7. Educational resource for Flutter developers

## CI/CD with GitHub Actions

### Automated APK Building
```yaml
name: Flutter APK Build
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:  # Manual trigger

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '11'
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
          channel: 'stable'
      
      - name: Get Dependencies
        run: flutter pub get
      
      - name: Run Tests
        run: flutter test
      
      - name: Build APK
        run: flutter build apk --release
      
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: photo-manager
          path: build/app/outputs/flutter-apk/app-release.apk
```

### Build Features
1. Automated builds on:
   - Push to main branch
   - Pull request to main
   - Manual trigger option
2. Generates release APK
3. Runs tests before building
4. Archives build artifacts
5. Available for download from Actions tab
6. Build status badge in README

### Security Notes
- No signing keys in repository
- Debug builds by default
- Release builds require manual signing
- Build artifacts accessible to repository owners only
