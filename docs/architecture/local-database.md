# Local Database Architecture

## Goal

Cartalyst V1 uses a local-first SQLite database through Drift to support fast and reliable in-store experiences on iOS and Android.

## Location

Database implementation is under `mobile/lib/infrastructure/local_db/`.

## Database Design

The schema is designed for:
- Fast local reads and writes
- Soft delete support where lifecycle history matters
- Future sync support
- Future conflict resolution support

## Tables

### products

Stores canonical products used by list, pantry, and pricing features.

Key fields:
- `id` UUID string
- `canonicalName`
- `brand` nullable
- `category`
- `defaultUnit`
- `defaultPackageQuantity` nullable
- `createdAt`, `updatedAt`, `deletedAt`
- `syncStatus`, `version`

### product_aliases

Stores multilingual aliases linked to canonical products.

Key fields:
- `id` UUID string
- `productId`
- `alias`
- `languageCode`
- `createdAt`, `updatedAt`

### shopping_lists

Stores user shopping lists and lifecycle state.

Key fields:
- `id` UUID string
- `listType` (`simple` or `organized`)
- `routingMode` (`none`, `inventory_categories`, `category_as_inventory`)
- `inventoryId` nullable
- `name`
- `status`
- `createdAt`, `updatedAt`, `deletedAt`
- `syncStatus`, `version`

### shopping_list_items

Stores line items for shopping lists.

Key fields:
- `id` UUID string
- `shoppingListId`
- `productId` nullable
- `rawText`
- `quantity` nullable
- `unit` nullable
- `categoryId` nullable (required in organized workflows; falls back to Uncategorized)
- `status`
- `source`
- `priorityScore`
- `createdAt`, `updatedAt`, `purchasedAt`, `deletedAt`
- `syncStatus`, `version`

### inventories

Stores user-defined inventories.

Key fields:
- `id` UUID string
- `name`
- `description` nullable
- `createdAt`, `updatedAt`, `deletedAt`
- `syncStatus`, `version`

### inventory_categories

Stores categories owned by each inventory.

Key fields:
- `id` UUID string
- `inventoryId`
- `name`
- `sortOrder`
- `isDefaultUncategorized` (exactly one per inventory)
- `createdAt`, `updatedAt`, `deletedAt`
- `syncStatus`, `version`

### inventory_items

Stores item snapshots inside inventories.

Key fields:
- `id` UUID string
- `inventoryId`
- `productId` nullable
- `rawName` nullable
- `quantityEstimated` nullable
- `unit` nullable
- `categoryId` nullable (resolved to inventory Uncategorized when unknown)
- `status`
- `confidenceScore`
- `lastConfirmedAt` nullable
- `createdAt`, `updatedAt`, `deletedAt`
- `syncStatus`, `version`

### inventory_events

Stores immutable inventory movement events.

Key fields:
- `id` UUID string
- `inventoryId` nullable
- `productId` nullable
- `inventoryItemId` nullable
- `eventType`
- `quantity` nullable
- `unit` nullable
- `source`
- `occurredAt`
- `createdAt`

### price_observations

Stores observed shelf prices for unit comparison.

Key fields:
- `id` UUID string
- `productId` nullable
- `storeName` nullable
- `packageQuantity`
- `packageUnit`
- `price`
- `unitPrice`
- `observedAt`
- `createdAt`

## Future Sync Fields

`syncStatus` is included in sync-relevant mutable entities to track the local sync lifecycle:
- `local_only`
- `pending_sync`
- `synced`
- `sync_error`

`version` is included for future conflict resolution when remote synchronization is introduced.

## Soft Delete

`deletedAt` is used on entities where recoverability and history are important:
- `products`
- `shopping_lists`
- `shopping_list_items`
- `inventories`
- `inventory_categories`
- `inventory_items`

## Categorization and Routing

- Simple lists use routing mode `none` and do not require category routing.
- Organized lists group items by category and support routing modes:
	- `inventory_categories`: one list routes to one inventory using that inventory's categories.
	- `category_as_inventory`: each list category maps to a target inventory.
- Items that cannot be categorized must route to `Uncategorized`.

## Category Memory for Suggestions

To support future suggestions from user behavior, category decisions should be persisted (for example, product/category assignment history per inventory context).

## Seed Data

The database seeds common grocery products and bilingual aliases (English and Spanish) for early suggestion and normalization support.

Seed examples include:
- eggs / huevos
- milk / leche
- bananas / plátanos
- apples / manzanas
- bread / pan
- rice / arroz
- beans / frijoles
- chicken / pollo
- toilet paper / papel de baño
- paper towels / servitoallas
- tomatoes / tomates
- onions / cebollas
- potatoes / papas
- cheese / queso
- yogurt / yogur

## Development Reset

`AppDatabase.developmentReset()` is available for development builds. It clears all local tables and reseeds baseline product data.
