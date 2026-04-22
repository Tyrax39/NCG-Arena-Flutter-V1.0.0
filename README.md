# NCG Arena Flutter Mobile

Flutter mobile client for NCG Arena / Neoncave Arena. This app consumes the Laravel API from the peer web repository and provides tournament, community, streaming, wallet, and subscription flows for Android and iOS.

## Current Repo Identity

- Package name: `neoncave_arena`
- Android application ID: `com.sadacode.neoncavearena`
- iOS bundle ID: `com.sadacode.neoncavearena`
- Current app version: `1.0.3+25`
- Peer backend repository: `https://github.com/Tyrax39/NCG-Arena-web-v1.2`

## What This Repo Includes

- Flutter application source under `lib/`, `android/`, `ios/`, `web/`, and `test/`
- repo bootstrap standards: `.gitignore`, `VERSION`, `CONTRIBUTING.md`, CI workflow, and PR template
- local knowledgebase archive under `docs/knowledgebase/`
- tooling scripts for logo sync, launcher icon regeneration, and Android debug cycles

## Local-Only Files

These files are intentionally ignored and must be created per developer or CI environment:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart`
- `android/key.properties`
- any keystore, provisioning profile, IDE state, build output, or local log files

## Quick Start

### 1. Prerequisites

- Flutter stable with Dart SDK `3.5.3+` support; CI currently uses Flutter `3.35.2`
- Android Studio for Android builds and emulators
- Xcode for iOS builds on macOS
- GitHub CLI if you want to manage repo metadata from the terminal

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase locally

- Add your local `android/app/google-services.json`
- Add your local `ios/Runner/GoogleService-Info.plist`
- This mobile repo does not track raw Firebase API keys in `lib/firebase_options.dart`
- Firebase initialization on Android and iOS reads the native platform files above
- If you later add web or desktop Firebase support, keep any generated `lib/firebase_options.dart` local and untracked

### 4. Configure backend access

The app resolves its backend base URL through `lib/constant/app_environment.dart`.

Default local behavior:

- Android emulator: `http://10.0.2.2/neoncave-v1.2/public/api/v1`
- iOS simulator / desktop / web local host: `http://127.0.0.1/neoncave-v1.2/public/api/v1`

Override the backend explicitly when needed:

```bash
flutter run --dart-define=NEONCAVE_API_BASE_URL=http://10.0.2.2/neoncave-v1.2/public/api/v1
```

If you also need to override the public web URL used by in-app links and bracket pages:

```bash
flutter run \
  --dart-define=NEONCAVE_API_BASE_URL=https://api.example.com/api/v1 \
  --dart-define=NEONCAVE_WEB_BASE_URL=https://app.example.com
```

### 5. Run the app

```bash
flutter run
```

## Repo Standards

- Long-lived branches: `main`, `staging`, `test`
- Working branches: `feature/*`, `hotfix/*`
- `pubspec.yaml` tracks the mobile build version; `VERSION` is append-only repo history
- shared canonical docs live in the web repo's `Documentation-Knowledgebase`
- local mobile repo notes live in `docs/knowledgebase/`

## Recommended Validation

Run before pushing:

```bash
flutter pub get
flutter analyze --no-fatal-warnings --no-fatal-infos
flutter test
```

The repository currently has legacy analyzer warnings and info-level lint debt. CI keeps analyzer errors fatal while allowing that existing non-blocking debt until it is cleaned up in follow-up work.

## Tooling Scripts

- `tooling/copy_logos.ps1`: syncs approved logo assets from the Laravel web app uploads
- `tooling/regenerate_launcher_icons.ps1`: rebuilds launcher icon assets from the source artwork
- `tooling/android_debug_cycle.ps1`: local Android debug helper

## Setup Documents

- `CONFIGURATION_GUIDE.md`: detailed service configuration guide
- `SETUP_CHECKLIST.md`: contributor and environment setup checklist
- `CONTRIBUTING.md`: branch, version, docs, and PR conventions
- `docs/knowledgebase/index-modern.html`: local archive note for repo-specific documentation

## Notes

- Firebase mobile initialization now relies on local native platform config files instead of a checked-in `lib/firebase_options.dart`.
- If the previously exposed Firebase API keys are still valid in Google Cloud or Firebase, they should be rotated or restricted outside the repo as a follow-up.
- Stripe, social auth, and Agora behavior depend on backend settings returned by the Laravel API.
- Shared release documentation should be updated in the web repository whenever mobile work changes shared platform behavior.