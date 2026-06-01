# Cartalyst

**Tagline:** Your smart shopping analyst.

Cartalyst is a local-first grocery intelligence mobile app. It helps people manage multiple shopping lists, track multiple inventories, compare options by unit price, and make smarter shopping decisions.

This repository currently contains foundational product and architecture documentation for the first delivery phase.

## Run Mobile App

The Flutter foundation lives in `mobile/`.

```bash
cd mobile
flutter pub get
flutter run
```

Optional quality checks:

```bash
cd mobile
flutter analyze
flutter test
```

## Mobile Build Script

Use the helper script to validate the mobile project and then build artifacts.

```bash
./scripts/build-mobile.sh android
./scripts/build-mobile.sh android --debug-only
./scripts/build-mobile.sh android --release-only
./scripts/build-mobile.sh ios
./scripts/build-mobile.sh ios --debug-only
./scripts/build-mobile.sh ios --release-only
./scripts/build-mobile.sh android --skip-tests
./scripts/build-mobile.sh android --skip-format
./scripts/build-mobile.sh android --apply-fixes
./scripts/build-mobile.sh --help
```

Platform is required. If you run the script without a platform, it fails with:

`Please specify a platform: android or ios.`

Default build mode behavior:
- `android` builds both debug and release APKs.
- `ios` builds both debug and release artifacts.
- Use `--debug-only` or `--release-only` to limit build mode.

The script runs these validation steps before any build:
- `flutter --version`
- `flutter pub get`
- `dart run build_runner build --delete-conflicting-outputs`
- `dart format lib test` (unless `--skip-format` is passed)
- `dart fix --apply` (only when `--apply-fixes` is passed)
- `flutter analyze`
- `flutter test` (unless `--skip-tests` is passed)

If `dart format` changes files, the script continues and prints:

`Formatting may have modified files. Review git diff before committing.`

iOS builds require macOS and Xcode.
- On Linux/Windows, `android` is supported.
- On Linux/Windows, `ios` fails clearly.

## Product Vision

Build a smart, reliable, and polished shopping companion that works fast in real grocery conditions, including low-connectivity environments.

## Product Personality

Cartalyst should feel:
- Analytical
- Organized
- Smart
- Shopping-focused

## V1.1 Scope

- Multiple shopping lists
- Two shopping list types:
	- Simple list
	- Organized list
- Multiple inventories
- Inventories with categories
- Pantry is no longer a fixed app section; pantry is an inventory name users may create
- Optional list-to-inventory linking
- Routing modes for purchased items:
	- `none` (simple list)
	- `inventory_categories` (single inventory with category routing)
	- `category_as_inventory` (category maps directly to inventory)
- Home is clean and list-focused
- Bottom navigation: Home, Lists, Inventories, Compare, Settings
- Quick product add and suggestions
- Price comparison with up to 5 options
- Local persistence
- Gesture-based list review with reversible actions
- Safe full-list editing with draft and apply/discard behavior
- Polished mobile UX

## V1.1 Delivery Phases

1. Foundation
	- Multiple lists and multiple inventories as first-class entities
	- Home simplification and bottom navigation restructure
2. Structured Shopping
	- Optional list-to-inventory linking
	- Improved gesture and undo review flows
3. Safe Editing and Compare
	- Draft editing for full-list changes
	- Price compare expansion from 2 fixed options to 2-5 options
4. Polish and Regression
	- Empty-state quality, layout safety, and full regression validation

## V1.1 Data Model Impact

- `shopping_lists` remains first-class and supports many concurrent lists
- `shopping_lists` supports list type (`simple` or `organized`) and routing mode (`none`, `inventory_categories`, `category_as_inventory`)
- `inventories` is first-class and user-defined; no hardcoded pantry section behavior
- `inventories` supports user-defined categories (for example: Fruits, Vegetables, Beef, Chicken, Fish, Seafood, Cleaning, Baby, Uncategorized)
- `shopping_lists.inventory_id` is optional to support standalone or inventory-linked lists
- Uncategorized handling is required for items that cannot be mapped to a known category
- Category choices made by users should be remembered for future suggestions
- Draft editing for list detail is persisted locally in a dedicated draft record structure
- Price compare supports multi-option input and ranked normalized results (2-5 options)

## Shopping List Types

- Simple list
	- Preserves current legacy behavior
	- No category routing
	- Users add and check items normally
- Organized list
	- Groups items by categories
	- Categories can route purchased items into inventories

## Routing Modes

- `none`
	- Used by simple lists
- `inventory_categories`
	- One shopping list routes purchased items to one inventory
	- Items are grouped by that inventory's categories
	- Example: Groceries list -> Pantry inventory -> Fruits/Vegetables/Meat
- `category_as_inventory`
	- Each shopping list category maps to an inventory
	- Example categories: Pantry, Fridge, Baby, Cleaning
	- Purchased items are routed to the inventory represented by the category

## UX Principles

- Keep screens minimal
- Do not place large forms directly on main screens
- Use plus buttons, bottom sheets, dialogs, or separate screens for create/edit flows
- Main list and inventory screens should prioritize content and quick actions
- Avoid nested scroll containers
- Full pages with forms must be keyboard-safe and scroll as a whole

## V1.1 Out Of Scope

- Real authentication
- Backend sync
- Receipt OCR
- AI and AI predictions
- Geofencing
- Push notifications
- Retailer integrations
- Multi-user collaboration
- Automatic online price lookup

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

## Mobile Stack

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

## Documentation Index

- [Product Blueprint](docs/product/product-blueprint.md)
- [V1.1 Scope](docs/product/v1.1-scope.md)
- [V1 Definition of Done](docs/product/v1-definition-of-done.md)
- [Mobile Architecture](docs/architecture/mobile-architecture.md)
- [Local-First Strategy](docs/architecture/local-first-strategy.md)
- [Coding Standards](docs/architecture/coding-standards.md)
- [Testing Strategy](docs/architecture/testing-strategy.md)
- [ADR 0001 - Use Flutter](docs/adr/0001-use-flutter.md)
- [ADR 0002 - Local-First Architecture](docs/adr/0002-local-first-architecture.md)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution workflow, V1 scope guardrails, and quality checks.
