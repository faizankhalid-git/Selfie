# PoseCoach

PoseCoach is a local-first Flutter camera assistant that helps a person align with a reference pose before taking a photo.

## Phase 1

This foundation targets iOS 17+ and Android API 29+ with shared Flutter UI and domain contracts. The live preview is native: AVFoundation on iOS and CameraX on Android. Camera frames are intentionally not sent through Flutter; later pose inference will run next to the native camera pipeline and emit normalized pose data.

Current screens:

- Pose library with bundled placeholder poses
- Camera permission flow and native preview surface
- Camera lens switching contract
- Settings placeholder

## Structure

```text
lib/
  app/                 app shell, theme, routes
  core/                configuration, providers, coordinate utilities
  models/              shared pose domain models
  features/            pose library, camera, settings UI
  services/            camera, pose engine, matching, storage contracts
ios/Runner/             Swift camera bridge and AVFoundation preview
android/app/            Kotlin CameraX bridge and preview
test/                   Flutter smoke tests
```

## Run

```bash
flutter pub get
flutter run --flavor development --dart-define=APP_ENV=development
flutter test
flutter analyze
```

For production configuration, use `APP_ENV=production` and the `production` Android flavor. The shared application ID is `com.company.posecoach`; development and staging Android variants add `.dev` and `.staging` suffixes.

## Architecture direction

The Flutter layer owns navigation, presentation, local metadata, matching contracts, and future alignment state. Native layers own camera lifecycle, platform permissions, preview rendering, and future frame/inference work. MediaPipe, segmentation, temporal smoothing, and automatic capture are intentionally deferred to the next phases.
