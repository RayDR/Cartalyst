# ADR 0002: Adopt Local-First Architecture

- **Status:** Accepted
- **Date:** 2026-05-26

## Context

Cartalyst is designed for real shopping environments where connectivity is inconsistent. Core use cases such as list editing and product checks must remain fast and dependable in stores.

A cloud-dependent architecture would add latency, reduce reliability offline, and degrade user trust.

## Decision

Adopt a local-first architecture where device storage is the primary source of truth in V1.

## Rationale

Local-first is selected because:

- Grocery lists must work inside stores
- Fast user experience is required for shopping flow
- Offline support is essential for reliability
- Future sync can be introduced through outbox/events

## Consequences

### Positive

- Reliable operation regardless of network quality
- Immediate read/write performance for key actions
- Clear path to incremental backend sync in future versions

### Trade-Offs

- Additional planning for data migration and eventual sync semantics
- Need clear conflict strategies when remote sync is introduced

## Forward Plan

When backend capabilities are added, sync should be implemented with:

1. Local write first
2. Event generation per domain mutation
3. Outbox queue and retry strategy
4. Conflict resolution policy by entity type

This preserves offline-first behavior while enabling cloud-linked features over time.
