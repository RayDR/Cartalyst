# ADR 0001: Use Flutter As Mobile Framework

- **Status:** Accepted
- **Date:** 2026-05-26

## Context

Cartalyst needs a production-quality cross-platform mobile foundation with a polished UI, strong architecture options, and long-term maintainability.

The primary alternative considered was React Native.

## Decision

Select Flutter as the mobile framework for Cartalyst.

## Rationale

Flutter is preferred over React Native for this project because it better aligns with current product and team goals:

- Learning value
  - The team gains strategic capability with Flutter and Dart for future mobile products.
- Strong cross-platform UI
  - Flutter provides consistent rendering and behavior across platforms.
- Polished UX
  - Flutter enables highly controlled, responsive, and visually polished interfaces.
- Single codebase
  - A shared codebase reduces product divergence and maintenance overhead.
- Scalable mobile architecture
  - Flutter supports clear layering, testability, and modular feature growth.

## Consequences

### Positive

- Faster iteration on cross-platform UI consistency
- Better control over motion, layout, and theme quality
- Good fit for feature-first and local-first architecture

### Trade-Offs

- Team onboarding effort in Dart and Flutter ecosystem
- Need to establish internal patterns early for consistency

## Revisit Criteria

Revisit this decision if platform constraints, team composition, or product distribution strategy significantly change.
