# Flutter Repo Bootstrap - 2026-04-21

This note records the first proper repository bootstrap for the NCG Arena Flutter client at `D:\ncg flutter v1.0.0`.

## What Was Added

- git ignore rules for Flutter build output, IDE state, local Firebase service files, signing files, and local logs
- append-only `VERSION` tracking aligned to the Flutter build number
- updated repo-facing documentation (`README.md`, `CONFIGURATION_GUIDE.md`, `SETUP_CHECKLIST.md`, `CONTRIBUTING.md`)
- local knowledgebase archive scaffold under `docs/knowledgebase/`
- GitHub Actions workflow for `flutter pub get`, `flutter analyze --no-fatal-infos`, and `flutter test`
- pull request template for validation, docs, and config hygiene

## Repo Standards

- default production branch: `main`
- supporting long-lived branches: `staging`, `test`
- feature branches: `feature/*`
- hotfix branches: `hotfix/*`
- git tag format: `ncg-v<pubspec-version>`

## Local-only Files

The following are intentionally ignored and should remain local to each developer or CI environment:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `android/key.properties`
- keystores, provisioning files, IDE state, build output, and local logs

## Shared Documentation Relationship

The mobile repo is separate, but shared release and parity notes still belong in the canonical docs engine hosted in the web repository:

- `https://github.com/Tyrax39/NCG-Arena-web-v1.2/tree/staging/Documentation-Knowledgebase`

Use this local archive for mobile-repo-specific bootstrap and release breadcrumbs, and update the shared engine whenever mobile work changes shared platform behavior.

## Bootstrap Follow-Up

- repaired the missing Flutter service methods for `update-channel` and `update-organization` so `flutter analyze` no longer fails on undefined mobile API calls
- aligned CI and local bootstrap docs to use `flutter analyze --no-fatal-warnings --no-fatal-infos` while the inherited warning/info lint backlog is reduced incrementally
