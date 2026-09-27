# @bartender-game/core

JavaScript/TypeScript port of **BartenderGame** Swift logic: drink validation, tips, shift pay, customers, venues, and catalog loading (JSON or Airtable).

## Setup

```bash
cd packages/bartender-core
npm install
npm run build   # extracts Swift data → data/catalog.json, compiles TS
npm test
```

## Data source

- **Default:** `npm run extract-data` reads `BartenderGame/*.swift` and writes `data/catalog.json` (stay in sync with the iOS app until Airtable is live).
- **Airtable:** use `fetchAirtableCatalog({ apiKey, baseId })` or `mapAirtableToCatalog(bundle)` with records from your base.

## Example

```ts
import {
  loadBundledCatalog,
  checkDrink,
  getTipMultiplier,
  calculateTipForSuccessfulDrink,
  defaultRandom,
} from '@bartender-game/core';

const catalog = loadBundledCatalog();
const drink = catalog.getDrink('Negroni')!;
const selection = {
  glasswareName: 'Old Fashioned Glass',
  ice: 'Cubed',
  method: 'Stir',
  ingredientNames: ['Gin', 'Campari', 'Sweet Vermouth'],
  garnishNames: ['Orange Twist'],
};

if (checkDrink(drink, selection)) {
  const price = catalog.getDrinkPrice("The Golden Lounge", drink.name);
  const tipMultiplier = getTipMultiplier(drink, selection, catalog.catalog.gameConfig);
  const tip = calculateTipForSuccessfulDrink(price, 4, tipMultiplier, defaultRandom);
}
```

## Module map (Swift → JS)

| Swift | JS module |
|-------|-----------|
| `PreparationView.checkDrink` / `getTipMultiplier` | `domain/preparation.ts` |
| `GlassRequirement` / `GarnishRequirement` | `domain/requirements.ts` |
| `ContentView.calculateDrinkCost` | `domain/pricing.ts` |
| `Venue.calculateShiftLength` | `domain/venue.ts` |
| `DailyTransitionManager` pay rules | `domain/shift.ts`, `domain/dailyTransition.ts` |
| `Customer` / `ContentView` customer spawn | `domain/customers.ts` |
| Mood tips in `ContentView` | `domain/tips.ts` |
| `String.article` | `utils/strings.ts` |
