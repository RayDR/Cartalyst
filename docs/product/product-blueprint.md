# Product Blueprint: Cartalyst

## Product Identity

- **Name:** Cartalyst
- **Tagline:** Your smart shopping analyst.
- **Category:** Local-first grocery intelligence app

## Product Vision

Cartalyst exists to help users shop smarter with less effort. The product should reduce shopping friction, improve price awareness, and provide reliable everyday support from list creation to inventory tracking.

## Product Personality

Cartalyst should always express the following traits:
- Analytical
- Organized
- Smart
- Shopping-focused

This personality should be visible in language, interaction design, and feature prioritization.

## Problem Statement

Most grocery workflows are fragmented. Users switch between notes, memory, and manual calculations, leading to:
- Slow list creation
- Impulse purchasing
- Poor unit-price decisions
- Forgotten inventory items

Cartalyst solves this with fast local interactions and practical grocery intelligence.

## Target Outcomes

- Users can create and manage multiple shopping lists.
- Users can compare up to 5 options by unit price confidently.
- Users can create and manage multiple inventories, including an inventory they may name "Pantry".
- Users can safely edit lists with draft and undo support.
- Users can trust the app even without connectivity.

## V1.1 Scope

- Multiple shopping lists
- Multiple inventories
- Optional shopping list to inventory linking
- Pantry is no longer a fixed app section and is represented as user-defined inventory naming
- Home focused on creating lists and showing recently modified lists
- Bottom navigation: Home, Lists, Inventories, Compare, Settings
- Price comparison with up to 5 options
- Safe editing with undo and draft behavior for list edits
- Local persistence
- Polished mobile UX

## V1.1 Out Of Scope

- Real authentication
- Backend sync
- Receipt OCR
- AI and AI predictions
- Geofencing
- Push notifications
- Retailer integrations

## Domain Language

- Inventory is the primary concept.
- Pantry is not a fixed app concept anymore.
- A pantry is simply an inventory named "Pantry" if the user creates it.

## V1.1 Delivery Phases

1. Organized Lists and Inventories
	- Multi-list and multi-inventory foundations
	- Pantry moved from fixed section to user naming
2. Focused Navigation and Home
	- Home simplification and bottom-nav restructure
3. Safe Editing and Review
	- Gesture-assisted list review with undo
	- Draft editing for full-list changes
4. Compare Expansion and Polish
	- 2-5 option price compare
	- Regression and UX polish pass

## V1.1 Data Model Impact

- `shopping_lists` supports many concurrent lists and optional inventory references
- `inventories` is fully user-defined without fixed semantic coupling
- Draft records are persisted for full-list edit sessions
- Compare output shifts to ranked multi-option result shape with normalized unit pricing

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

## UX Principles

- Users should add products in under 3 seconds.
- Support one-handed shopping mode.
- Show clear empty states.
- Maintain a friendly and polished UI.
- Provide fast feedback on every key action.
- Keep destructive or status-changing actions reversible where practical.
- Keep primary actions visible and reachable above bottom navigation constraints.

## Release Intent For First Deliverable

This first deliverable is documentation-only and establishes shared direction for product, architecture, and engineering decisions before app implementation begins.
