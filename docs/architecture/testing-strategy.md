# Testing Strategy

Cartalyst uses a pragmatic, layered testing strategy focused on V1 stability.

## Goals

- Catch regressions in core shopping flows quickly.
- Validate deterministic domain logic.
- Keep tests fast and reliable in local development and CI.

## Test Layers

## 1) Domain and Service Tests

Validate pure logic with deterministic inputs.

Examples:
- Product suggestion ranking and parsing
- Unit conversion and package comparison
- Value object behavior

## 2) Application/Controller Tests

Validate state transitions and repository interactions using test doubles.

Examples:
- Shopping list item lifecycle
- Pantry status changes and inventory event creation

## 3) Data Mapping/Repository Tests

Validate conversion correctness between DB rows and domain entities.

Examples:
- Product and shopping list mappers

## 4) Widget Smoke Tests

Keep a minimal set of widget tests to ensure app shell and route wiring remain stable.

## What We Avoid in V1

- Heavy end-to-end test suites for every screen
- Complex snapshot testing workflows
- Flaky time-dependent async tests without strict control

## Local Commands

```bash
cd mobile
flutter analyze
flutter test
```

## Coverage Priorities

When adding features, prioritize tests for:
- Domain rules
- State transitions
- Error paths
- Local persistence side effects when business-critical
