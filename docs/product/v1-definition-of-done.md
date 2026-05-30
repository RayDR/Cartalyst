# Cartalyst V1 Definition of Done

A feature is done for V1 when all items below are satisfied.

## Product Fit

- Solves a clear V1 user task in shopping list, inventories, or price compare.
- Does not add V2/V3 capabilities.

## Architecture

- Domain/application logic is outside widgets.
- Presentation does not use Drift directly.
- Data access is through repository interfaces.
- Mapping between DB and domain models is explicit.

## UX

- Uses Cartalyst design-system components and tokens.
- Provides clear empty states where data may be absent.
- Supports quick scanning and simple actions on mobile.
- Keeps primary actions visible above bottom navigation constraints.
- Keeps destructive/status-changing list review actions reversible where specified.

## Data and Reliability

- Changes persist locally when applicable.
- Error states are handled with user-friendly feedback.
- No misleading AI claims or fabricated insights.
- Full-list edit drafts are isolated from committed list data until apply.

## Quality

- `flutter analyze` passes.
- `flutter test` passes.
- New core behavior has focused tests.
- README/docs are updated if behavior or architecture changed.
