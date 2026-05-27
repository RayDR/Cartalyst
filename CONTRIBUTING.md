# Contributing to Cartalyst

Thanks for contributing to Cartalyst.

## Scope and Product Stage

Cartalyst is currently in V1.

V1 priorities:
- Fast shopping list management
- Rule-based quick add suggestions
- Price comparison by unit
- Simple pantry tracking
- Local-first persistence

Out of scope for V1:
- AI/LLM assistants
- Receipt scanning
- Geofencing
- Backend sync
- Authentication

## Development Setup

```bash
cd mobile
flutter pub get
flutter analyze
flutter test
```

## Architecture Guidelines

- Keep business logic in domain/application layers, not widgets.
- Presentation should depend on providers/controllers, not Drift.
- Data access should stay in repositories and mappers.
- Reuse design-system components from `mobile/lib/core/widgets` and design tokens from `mobile/lib/core/design`.

## Code Standards

- Use English for code and comments.
- Avoid unnecessary comments.
- Do not add hardcoded spacing, radius, or colors in feature screens.
- Keep naming consistent across domain, data, and UI layers.
- Add or update tests when behavior changes.

## Pull Request Checklist

- [ ] Scope is V1-safe and does not introduce V2/V3 features.
- [ ] `flutter analyze` passes.
- [ ] `flutter test` passes.
- [ ] New behavior has test coverage.
- [ ] Documentation is updated when architecture or behavior changes.

## Commit Style

Use clear conventional-style commit messages when possible:
- `feat(...)`
- `fix(...)`
- `test(...)`
- `docs(...)`
- `refactor(...)`
