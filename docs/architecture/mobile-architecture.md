# Mobile Architecture: Cartalyst

## Goals

Define a production-quality mobile architecture that supports fast iteration in V1.1, strong testability, and smooth evolution toward future sync capabilities.

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

## V1.1 Product-Driven Constraints

- Multiple shopping lists are first-class and independently editable.
- Multiple inventories are first-class and user-defined.
- Pantry is modeled as an inventory name, not a dedicated hardcoded domain concept.
- Shopping lists can optionally link to an inventory.
- Home is simplified to list creation and recently modified lists.
- Bottom navigation structure is: Home, Lists, Inventories, Compare, Settings.
- Price comparison supports up to 5 options in a single comparison flow.
- List editing supports draft state and undo-friendly operations.

## V1.1 Architecture Phases

1. Foundation
  - Multi-list and multi-inventory domain boundaries
  - Route topology aligned to Home, Lists, Inventories, Compare, Settings
2. Structured Relationships
  - Optional list-to-inventory linking through nullable references and repository contracts
3. Safe Editing
  - Draft persistence and explicit apply/discard transitions in application/domain flows
  - Reversible interaction pathways for list review actions
4. Compare Expansion
  - Comparison services generalized from pairwise to ranked multi-option evaluation

## Data Model Impact (V1.1)

- `shopping_lists` remains the list aggregate root and supports many active lists
- `inventories` replaces fixed pantry assumptions with user-defined inventory records
- `shopping_lists.inventory_id` remains optional, enforcing link flexibility at domain boundaries
- Draft state for full-list editing is persisted in the data layer and mapped to domain/application models
- Price comparison result model supports ranked outputs across 2-5 options, including tie handling and normalized unit price reporting

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
- For list editing, keep draft state isolated from committed state and expose explicit commit or discard transitions.
- For undo support, controllers should emit reversible actions where applicable.
- For comparison workflows, keep validation and ranking logic in pure Dart services, not widgets.

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
- Multi-list creation and modification flows
- Inventory creation and list-to-inventory linking flows
- Unit price comparator accuracy across up to 5 options
- Draft and undo list-edit behavior

## Theming And UX Foundation

Use Material 3 custom theme with semantic design tokens.

Design goals:
- Friendly and polished UI
- Fast visual feedback
- One-handed accessibility for core actions
