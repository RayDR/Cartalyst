# Local-First Strategy: Cartalyst

## Why Local-First

Cartalyst is designed for in-store usage where connectivity can be weak or inconsistent. Core grocery workflows must remain dependable under these conditions.

Local-first ensures:
- Grocery lists always work inside stores
- Fast user experience
- Offline support
- A practical path to future sync through outbox/events

## Product Requirements Supported By Local-First

- Instant list editing
- Immediate product add and updates
- Reliable pantry checks while shopping
- Responsive unit price comparisons

## Data Ownership Model

In V1, the device is the source of truth.

- Primary writes happen locally.
- Reads are served from local storage.
- No backend dependency is required for core workflows.

## Local Persistence Foundation

- Storage engine: SQLite through Drift
- Domain-facing repositories isolate persistence details
- Migrations handled in data layer with clear versioning

## Sync-Ready Design Without Backend In V1

Even without backend sync in V1, architecture should preserve future sync compatibility.

### Sync-Readiness Guidelines

- Use stable local identifiers for entities
- Record write operations as domain events when useful
- Keep mutation intent explicit in use cases
- Avoid coupling UI to transport assumptions

## Outbox/Event Direction For Future Sync

Future versions should introduce an outbox/event pipeline:

1. Domain action executed locally
2. Local state updated immediately
3. Event queued in outbox
4. Sync worker publishes events when connectivity is available
5. Conflict policy applied when remote data differs

This allows preserving offline-first behavior while adding cloud capabilities safely.

## Performance Principles

- Reads should be local and indexed for common queries
- Writes should complete quickly for in-store interactions
- UI updates should happen immediately after successful local commits

## Failure Handling Principles

- Never block core shopping actions on network availability
- Show clear status for deferred operations in future sync-enabled versions
- Keep user trust by preferring deterministic local outcomes
