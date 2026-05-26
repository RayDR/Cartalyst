# Mobile Architecture: Cartalyst

## Goals

Define a production-quality mobile architecture that supports fast iteration in V1, strong testability, and smooth evolution toward sync and AI-assisted capabilities.

## Technology Stack

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

## Architecture Principles

- Feature-first
- Local-first
- Sync-ready
- Testable domain logic
- No business logic in widgets
- No persistence implementation leaking into UI

## Architectural Style

Cartalyst follows a feature-first modular structure with clear boundaries between presentation, domain, and data concerns.

### Proposed High-Level Layers

- Presentation layer
  - Screens, view models/state notifiers, UI state mapping
  - Navigation via go_router
- Domain layer
  - Entities, value objects, use cases, domain services
  - Pure business rules and orchestration
- Data layer
  - Local repositories, Drift DAOs, mappers, cache policies
  - Serialization and persistence details

## Feature-First Organization

Each feature should be self-contained and include:
- Presentation components
- Domain logic and use cases
- Data access and mappings
- Feature-focused tests

Shared modules should remain minimal and hold only reusable cross-feature contracts or UI foundations.

## State Management

Riverpod is the default state management and dependency injection mechanism.

Guidelines:
- Keep providers close to feature boundaries.
- Keep domain logic inside use cases or domain services.
- UI should consume prepared state, not execute business logic.

## Routing

go_router is used for declarative routing.

Guidelines:
- Keep route declarations centralized.
- Use typed route arguments where appropriate.
- Avoid route side-effects; keep logic in feature use cases.

## Persistence

Drift + SQLite provides local persistence for V1.

Guidelines:
- Repositories expose domain-friendly contracts.
- DAOs and table schemas stay inside data layer.
- UI and domain layers remain database-agnostic.

## Testing Strategy

- Domain layer: unit tests with flutter_test and mocktail
- Data layer: repository and mapper tests
- Presentation layer: widget tests for critical flows

Priority test targets in V1:
- Product add flow
- Unit price comparator accuracy
- Pantry quantity updates

## Theming And UX Foundation

Use Material 3 custom theme with semantic design tokens.

Design goals:
- Friendly and polished UI
- Fast visual feedback
- One-handed accessibility for core actions
