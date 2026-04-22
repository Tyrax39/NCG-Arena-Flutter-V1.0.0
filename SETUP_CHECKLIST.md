# NCG Arena Setup Checklist

Use this checklist when onboarding a new developer machine or preparing a clean CI/local environment for the Flutter mobile repo.

## Repo Bootstrap

- [ ] Git is installed
- [ ] Repo cloned to a writable path
- [ ] `main`, `staging`, and `test` branch strategy understood
- [ ] `README.md`, `CONFIGURATION_GUIDE.md`, and `CONTRIBUTING.md` reviewed

## Tooling

- [ ] Flutter stable installed with Dart SDK `3.5.3+` support available
- [ ] Android Studio installed and Android SDK available
- [ ] Xcode installed if building for iOS on macOS
- [ ] `flutter doctor` reviewed

## Dependencies

- [ ] `flutter pub get`
- [ ] `flutter clean` if switching branches or build environments

## Firebase

- [ ] `android/app/google-services.json` added locally
- [ ] `ios/Runner/GoogleService-Info.plist` added locally
- [ ] mobile Firebase platform files match the target Firebase project
- [ ] Firebase Authentication, Messaging, Firestore, and Storage enabled as needed

## Backend

- [ ] Laravel backend is reachable
- [ ] local Android emulator flow tested against `10.0.2.2` or an explicit `NEONCAVE_API_BASE_URL`
- [ ] optional `NEONCAVE_WEB_BASE_URL` override configured if public links differ from API host

## Social Auth / Payments / Streaming

- [ ] Facebook app ID and token values configured locally when needed
- [ ] Google / Apple sign-in configuration matches package and bundle IDs
- [ ] Stripe values available through backend settings
- [ ] Agora values available through backend settings

## Release Signing

- [ ] local `android/key.properties` created if building Android release artifacts
- [ ] keystore file stored locally and not staged

## Branding

- [ ] approved logos synced with `tooling/copy_logos.ps1` when branding changes
- [ ] launcher icons regenerated with `tooling/regenerate_launcher_icons.ps1` if app icon assets change

## Validation

- [ ] `flutter analyze --no-fatal-warnings --no-fatal-infos`
- [ ] `flutter test`
- [ ] `flutter run`

## Release Hygiene

- [ ] `pubspec.yaml` build number reviewed
- [ ] `VERSION` appended if the release state changed
- [ ] local-only Firebase and signing files remain untracked
- [ ] shared documentation engine in the web repo updated if the mobile change affects platform parity or release notes

