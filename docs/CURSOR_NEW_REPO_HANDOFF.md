# Bartender Game — handoff for a new repo (paste into Cursor)

Use this document as the **system/context file** when starting a **new repository** (web app, API, admin, or Airtable sync). The iOS game lives in a separate repo; game rules and catalog shape are defined here.

---

## 1. Product summary

**Bartender Game** is an iOS SwiftUI bartending sim. The player:

- Picks one of **11 venues** with different menus, pay, and opening hours.
- Serves **customers** who order drinks from that venue’s menu.
- Builds drinks in a **preparation flow**: glassware, ice, method (build/stir/shake/etc.), recipe ingredients, garnishes.
- Earns **sales + tips** on success; **wastage** (ingredient cost) on failure.
- Completes **shifts** with minimum hours and **minimum bar take** targets; **daily transition** applies living/transport costs and consolidates pay.

**Goal for the new repo:** backend and/or web client that uses the **same rules** as iOS, with **Airtable** as the content CMS (drinks, venues, menus, ingredients).

---

## 2. Source-of-truth repos & artifacts

| Item | Location |
|------|----------|
| iOS app (SwiftUI) | `https://github.com/hansguntersson/BartenderGame` |
| Ported game logic (TypeScript) | Same repo: `packages/bartender-core` (`@bartender-game/core`) |
| Swift → JSON extract script | Same repo: `scripts/extract-swift-data.mjs` |
| Generated catalog snapshot | Same repo: `packages/bartender-core/data/catalog.json` |
| Draft PR for JS port | `https://github.com/hansguntersson/BartenderGame/pull/1` |

**Recommended:** publish `@bartender-game/core` to npm or git-submodule it into the new repo. Until then, copy `packages/bartender-core` or depend on the GitHub path.

---

## 3. TypeScript package (`@bartender-game/core`)

### Install / develop (from monorepo path)

```bash
cd packages/bartender-core
npm install
npm test      # runs extract-swift-data + vitest
npm run build
```

### Public API (import from `@bartender-game/core`)

**Catalog**

- `loadBundledCatalog()` — reads `data/catalog.json`
- `loadCatalogFromObject(catalog)` — from in-memory / DB JSON
- `GameCatalogService` — `getDrink(name)`, `getVenue(name)`, `getDrinkPrice(venue, drink)`, `getVenueMenu(venue)`
- `fetchAirtableCatalog({ apiKey, baseId })` — live Airtable
- `mapAirtableToCatalog(bundle)` — map fetched rows without network

**Gameplay logic (must match iOS)**

- `checkDrink(drink, selection)` — full prep validation
- `getTipMultiplier(drink, selection, gameConfig)`
- `calculateTipForSuccessfulDrink(price, mood, tipMultiplier, random)`
- `calculateDrinkCostByName(drinkName, catalog)` — wastage
- `calculateShiftPay({ venue, sales, tips, wastage, hoursWorked, config })`
- `processDailyTransition(...)` — end-of-day money
- `generateCustomerWave`, `generateNewCustomer`, `generateMoodInfluencedByVenue`
- `openingHoursForDay`, `shiftLengthHoursForDay`, `calculateShiftLengthHours`
- `indefiniteArticle`, `formatOrderPhrase`

**Types:** `GameCatalog`, `DrinkRecord`, `VenueRecord`, `PreparationSelection`, `CustomerState`, `ShiftMetrics`, `GameConfig` — see `src/types/catalog.ts`.

### Preparation selection shape

```ts
interface PreparationSelection {
  glasswareName: string | null;
  ice: string;           // None | Cubed | Crushed | Sphere | Cracked | Dry
  method: string;        // Build | Stir | Shake | Blend | Roll | Layer
  ingredientNames: string[];  // must match recipe count; names only (amounts not validated in iOS checkDrink)
  garnishNames: string[];
}
```

### Tip multipliers (glass + garnish)

- Ideal: **1.0**, Acceptable: **0.8**, Wrong: **0.2**
- Combined tip multiplier = **average** of glass and garnish multipliers (rounded to 2 dp), same as `PreparationView.getTipMultiplier`.

### Mood tips (on successful drink)

Percent of **venue menu price** × tip multiplier; random ranges per mood 1–5 (see `domain/tips.ts`). Mood 3/2/1 include probability of **zero tip**.

### Shift pay

- Base pay = `basePayPerHour × hoursWorked` only if `hoursWorked >= minimumHoursPerShift`.
- Total = base pay + tips − wastage.
- If `sales < minimumBarTake`: subtract **10% of base pay** from total.
- If `sales >= 1.5 × minimumBarTake`: add **15% of base pay** bonus.

### Game config defaults (`catalog.gameConfig`)

```json
{
  "customerPatienceBaseSeconds": 300,
  "customerPatienceVariationSeconds": 30,
  "maxActiveCustomers": 8,
  "customersPerWave": 5,
  "initialCustomerCount": 1,
  "customerGenerationBaseSeconds": 60,
  "customerGenerationVariationSeconds": 30,
  "returningCustomerChance": 0.3,
  "tipMultiplierIdeal": 1,
  "tipMultiplierAcceptable": 0.8,
  "tipMultiplierWrong": 0.2,
  "belowMinimumBarTakeWagePenalty": 0.1,
  "aboveMinimumBarTakeBonusThreshold": 1.5,
  "aboveMinimumBarTakeBonus": 0.15
}
```

---

## 4. Airtable base schema (content CMS)

Create base **“Bartender Game”**. Currency: **GBP**. Recipe amounts: **oz**.

### Core tables

1. **Ingredients** — Name (unique), Slug, Short Name, Category, Subcategory, Cost Per Oz, Active  
2. **Garnishes** — Name, Slug, Short Name, Category, Cost, Active  
3. **Glassware** — Name, Slug, Short Name, Category, Active  
4. **Drinks** — Name, Slug, Description, Category (`Cocktail`|`Regular`), Style, Family, Required Ice, Required Method, Garnish Required (checkbox), Minimum Glass (link, optional), Active  
5. **Drink Recipe Lines** — Drink (link), Ingredient (link), Amount Oz, Sort Order  
6. **Drink Glass Options** — Drink, Glassware, Role (`Ideal`|`Acceptable`)  
7. **Drink Garnish Options** — Drink, Garnish, Role (`Ideal`|`Acceptable`)  
8. **Venues** — Name, Slug, Description, Location, Capacity, Base Pay Per Hour, Minimum Hours Per Shift, Minimum Bar Take, Active  
9. **Venue Hours** — Venue, Weekday, Open, Start Time, End Time (format `11AM`, `1AM`; blank if closed)  
10. **Venue Menu Items** — Venue, Drink, Price, Is Signature, Active  

### Optional tables

- **Order Phrases** — Template with `%@` placeholder  
- **Living Situations** / **Transport Options** — economy (see iOS `PlayerProfileView`)  
- **Game Config** — key/value tuning  

### Import order

Ingredients, Garnishes, Glassware → Drinks → Recipe/Glass/Garnish options → Venues → Venue Hours → Venue Menu Items.

### JS mapping

`mapAirtableToCatalog()` expects Airtable **field names** as listed above (see `packages/bartender-core/src/airtable/mapAirtableToCatalog.ts`).

---

## 5. Suggested architecture for the **new repo**

Pick one or combine:

```
Airtable (CMS)
    ↓ fetch / webhook / scheduled sync
Catalog cache (JSON on disk, Redis, or DB)
    ↓
@bartender-game/core (GameCatalogService + domain/*)
    ↓
REST or tRPC API  ←→  Web admin / play prototype / future iOS loader
```

**Player state** (money, shifts, UserDefaults keys on iOS) can stay client-side initially or move to your API:

- `playerMoney`, `playerLivingSituation`, `playerTransport`
- Per-venue: `gameSales_*`, `gameTips_*`, `gameWastage_*`, `customerScreenTime_*_YYYY-MM-DD`
- Global: `startedShifts`, `lastProcessedDate`

**Do not duplicate** prep validation in the new repo — always call `checkDrink` / `getTipMultiplier` from core.

---

## 6. Venue list (for seed data / tests)

1. The Bear & Badger  
2. Mackenzie's  
3. Paradise Cove  
4. The Mourning Star  
5. The Golden Lounge  
6. Penthouse  
7. The Secret Society  
8. The Hop House  
9. The Dram Library  
10. The Grape Escape  
11. Modern Alchemy  

Menus and prices are venue-specific (`Venue Menu Items` / `venueMenus` in catalog JSON).

---

## 7. Tasks Cursor should prioritize in the new repo

1. **Scaffold** Node 20+ TS project (Fastify or Express), env: `AIRTABLE_API_KEY`, `AIRTABLE_BASE_ID`.  
2. **GET /catalog** — return `GameCatalog` JSON (from Airtable via `fetchAirtableCatalog`, with optional fallback to bundled JSON).  
3. **POST /validate-drink** — body: `{ drinkName, selection }` → `{ correct, tipMultiplier }` using core.  
4. **POST /complete-order** (optional) — `{ venueName, drinkName, selection, customerMood }` → `{ correct, sale, tip, wastage }`.  
5. **Sync job** — cron or manual `npm run sync-catalog` writing `data/catalog.json` for offline/dev.  
6. **Tests** — golden tests: Negroni, Cosmopolitan tip multiplier, Bear & Badger shift penalty (see `packages/bartender-core/tests/game-logic.test.ts`).

---

## 8. Constraints & conventions

- Drink/venue matching in iOS is by **exact display name** (e.g. `"The Bear & Badger"`, `"Dark 'n' Stormy"`). Keep Airtable names identical.  
- Slugs are for future-proof APIs; not used in Swift today.  
- Regenerate JSON when Swift changes: from BartenderGame repo run `node scripts/extract-swift-data.mjs`.  
- iOS UI code is **not** required in the new repo — only logic + catalog + your chosen frontend.

---

## 9. Example prompt for Cursor in the new repo

> Read `CURSOR_NEW_REPO_HANDOFF.md` (this file). Create a TypeScript API that loads the game catalog from Airtable using the field names in section 4, depends on `@bartender-game/core` for all game rules, exposes `/catalog` and `/validate-drink`, includes vitest tests aligned with section 7, and documents env vars in README.

---

## 10. File checklist to copy into new repo

Minimum:

- [ ] This handoff file (rename to `CURSOR_NEW_REPO_HANDOFF.md` or `.cursor/rules/bartender-game.md`)  
- [ ] `packages/bartender-core` **or** npm dependency once published  
- [ ] Optional: `catalog.json` snapshot for offline dev  

Do **not** copy the whole Xcode project unless building a native companion app.

---

*Generated from BartenderGame monorepo context. Update section 2 links if the core package moves to its own repository.*
