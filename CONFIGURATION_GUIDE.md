# NCG Arena Configuration Guide

This guide covers the environment-specific configuration required to run the NCG Arena Flutter mobile client against local, staging, or production backends.

## Application Identifiers

- Android namespace / application ID: `com.sadacode.neoncavearena`
- iOS bundle ID: `com.sadacode.neoncavearena`
- Flutter package: `neoncave_arena`

If you fork or white-label the app, update these identifiers together across Android, iOS, Firebase, and social-auth providers.

## Firebase

### Local-only files

These files are intentionally gitignored and must be provided locally:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart`

### Current repo state

- Android and iOS initialization rely on the local native Firebase service files above.
- `lib/firebase_options.dart` is intentionally not tracked in this mobile-only repo so raw Firebase API keys are not published.
- If you provision web or desktop Firebase support later, generate `lib/firebase_options.dart` locally with FlutterFire CLI and keep it untracked.

### Recommended Firebase services

- Authentication
- Cloud Messaging
- Cloud Firestore
- Storage
- Analytics (optional but recommended)

## Backend URLs

The app reads its backend URLs from `lib/constant/app_environment.dart`.

Defaults:

- Android emulator: `http://10.0.2.2/neoncave-v1.2/public/api/v1`
- iOS simulator / desktop / web host: `http://127.0.0.1/neoncave-v1.2/public/api/v1`

Recommended overrides:

```bash
flutter run --dart-define=NEONCAVE_API_BASE_URL=http://10.0.2.2/neoncave-v1.2/public/api/v1
```

If you also need to override the public web URL used for brackets and in-app web links:

```bash
flutter run \
  --dart-define=NEONCAVE_API_BASE_URL=https://api.example.com/api/v1 \
  --dart-define=NEONCAVE_WEB_BASE_URL=https://app.example.com
```

Legacy fallback environment names `BRACTIX_API_BASE_URL` and `BRACTIX_WEB_BASE_URL` still exist in code for compatibility, but new environments should use the `NEONCAVE_*` names.

## Social Authentication

### Facebook

- Android app values live in `android/app/src/main/res/values/strings.xml`
- iOS values live in `ios/Runner/Info.plist`

The repo currently ships placeholders for the Facebook client token string. Replace them with environment-appropriate values before release builds.

### Google and Apple Sign-In

- Google sign-in depends on Firebase project setup and matching OAuth client configuration.
- Apple sign-in requires the iOS bundle ID and Apple Developer configuration to match.

## Payments and Streaming

- Stripe publishable settings are fetched from the Laravel backend at runtime.
- Agora App ID / token generation is also backend-driven.
- Do not hardcode production Stripe or Agora secrets in the Flutter repo.

## Android Release Signing

Create a local `android/key.properties` file and keep it out of git.

Example:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=upload-keystore.jks
```

Also keep your keystore file local-only.

## Branding Assets

The repo includes scripts under `tooling/` to keep branding consistent:

- `copy_logos.ps1` to sync approved logos from the web app uploads
- `regenerate_launcher_icons.ps1` to rebuild launcher assets

Use those scripts instead of ad hoc asset copying when the design team updates branding.

## Validation

After configuration changes:

```bash
flutter pub get
flutter analyze --no-fatal-warnings --no-fatal-infos
flutter test
flutter run
```

