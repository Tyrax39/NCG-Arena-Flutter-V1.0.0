# Contributing

This repository is the Flutter mobile client for NCG Arena / Neoncave Arena. It follows the same release discipline as the web repository, but keeps mobile code, build metadata, and release history in its own git history.

## Branching

- `main`: production-ready mobile branch.
- `staging`: pre-production validation branch.
- `test`: integration and QA branch.
- `feature/*`: scoped feature work.
- `hotfix/*`: urgent fixes against production behavior.

## Versioning

- `pubspec.yaml` is the app build source of truth and should use Flutter's `x.y.z+build` format.
- `VERSION` is append-only and mirrors the build progression for repository history.
- Every release-impacting commit should append the next line to `VERSION` instead of rewriting old entries.
- Recommended git tag format for this repo: `ncg-v<pubspec-version>`.

## Documentation

- The shared canonical documentation engine lives in the peer web repository: `NCG-Arena-web-v1.2/Documentation-Knowledgebase`.
- This mobile repo keeps append-only local notes in `docs/knowledgebase/` so repo-specific bootstrap and release records remain visible here too.
- If a mobile release changes shared behavior or feature parity, update the shared engine from the web repo as part of the same release cycle.

## Local-only Files

Do not commit local environment or signing artifacts.

Ignored by default:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `android/key.properties`
- keystores, provisioning files, build output, IDE state, and local logs

## Validation Before Push

Run these commands from the repo root:

```bash
flutter pub get
flutter analyze --no-fatal-warnings --no-fatal-infos
flutter test
```

## Commit Footer

Use the shared NCG footer when a commit changes releasable code or release metadata:

```text
[NCG-VERSION]
semver: patch|minor|major
internal-iteration: +1
docs: appended /docs/knowledgebase/index-modern.html
```

## Pull Requests

- Target `staging` unless the change is a production hotfix.
- Include a concise summary, validation commands, version impact, and docs impact.
- Call out backend/API dependency changes explicitly.
- Confirm that no local-only config files were staged.
