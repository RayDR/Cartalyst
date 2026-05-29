# Cartalyst

**Tagline:** Your smart shopping analyst.

Cartalyst is a local-first grocery intelligence mobile app. It helps people build grocery lists quickly, compare unit prices, track pantry inventory, and make smarter shopping decisions.

This repository currently contains foundational product and architecture documentation for the first delivery phase.

## Run Mobile App

The Flutter foundation lives in `mobile/`.

```bash
cd mobile
flutter pub get
flutter run
```

Optional quality checks:

```bash
cd mobile
flutter analyze
flutter test
```

## Mobile Build Script

Use the helper script to validate the mobile project and then build artifacts.

```bash
./scripts/build-mobile.sh
./scripts/build-mobile.sh android --debug
./scripts/build-mobile.sh android --release
./scripts/build-mobile.sh all --release
```

The script runs these validation steps before any build:
- `flutter pub get`
- `dart run build_runner build --delete-conflicting-outputs`
- `flutter analyze`
- `flutter test` (unless `--skip-tests` is passed)

iOS builds require macOS and Xcode. On Linux and Windows, iOS is skipped for `all` or fails clearly when explicitly requested.

## Product Vision

Build a smart, reliable, and polished shopping companion that works fast in real grocery conditions, including low-connectivity environments.

## Product Personality

Cartalyst should feel:
- Analytical
- Organized
- Smart
- Shopping-focused

## V1 Scope

- Fast grocery list
- Quick product add
- Product suggestions
- Unit price comparator
- Simple pantry inventory
- Local persistence
- Polished mobile UX

## V1 Out Of Scope

- Real authentication
- Backend sync
- Receipt OCR
- AI predictions
- Geofencing
- Push notifications
- Retailer integrations

## Future Scope

### V2

- Receipt scanning
- Spending tracking
- Product normalization
- Basic consumption learning
- Smarter suggestions

### V3

- AI assistant
- Geofencing
- Collaborative shopping
- Store recommendations
- Retailer price integrations

## Mobile Stack

- Flutter
- Dart
- go_router
- Riverpod
- Drift + SQLite
- freezed
- json_serializable
- mocktail
- flutter_test
- Material 3 custom theme

## Documentation Index

- [Product Blueprint](docs/product/product-blueprint.md)
- [V1 Definition of Done](docs/product/v1-definition-of-done.md)
- [Mobile Architecture](docs/architecture/mobile-architecture.md)
- [Local-First Strategy](docs/architecture/local-first-strategy.md)
- [Coding Standards](docs/architecture/coding-standards.md)
- [Testing Strategy](docs/architecture/testing-strategy.md)
- [ADR 0001 - Use Flutter](docs/adr/0001-use-flutter.md)
- [ADR 0002 - Local-First Architecture](docs/adr/0002-local-first-architecture.md)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution workflow, V1 scope guardrails, and quality checks.
