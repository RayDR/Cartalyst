# Coding Standards: Cartalyst

## Purpose

Establish clear engineering standards for readable, testable, and maintainable code across the Cartalyst mobile application.

## Core Standards

- English-only code and comments
- No unnecessary comments
- No AI-generated comments
- Meaningful names
- Small testable functions
- Semantic design tokens

## Naming

- Prefer descriptive names that reveal intent.
- Avoid abbreviations unless they are standard and obvious.
- Keep names consistent across feature boundaries.

## Comments

- Write comments only when they add context that code cannot express clearly.
- Do not narrate obvious operations.
- Avoid generated-style explanatory blocks.

## Function Design

- Keep functions focused on one responsibility.
- Limit branching depth where practical.
- Extract pure logic into domain-level units to improve testability.

## Widget And UI Rules

- No business logic in widgets.
- UI should orchestrate presentation only.
- Use semantic design tokens in theming and component styling.

## Data And Domain Boundaries

- Do not leak persistence implementation into UI.
- Keep repository interfaces domain-friendly.
- Map data models to domain models explicitly.

## Testing Expectations

- Add unit tests for domain logic and use cases.
- Add targeted widget tests for critical user journeys.
- Use mocktail for mocking boundaries where needed.

## Language And Communication

All source code, comments, pull request descriptions, and technical documentation should remain in English for consistency and collaboration quality.
