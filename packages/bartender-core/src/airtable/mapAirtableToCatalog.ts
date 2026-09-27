import type {
  DrinkRecord,
  GameCatalog,
  GarnishRecord,
  GlasswareRecord,
  IngredientRecord,
  VenueMenuItemRecord,
  VenueRecord,
  VenueShiftDay,
} from '../types/catalog.js';

/**
 * Maps Airtable records (field names from the spec shared earlier) into GameCatalog.
 * Pass plain objects keyed by Airtable field names.
 */
export interface AirtableIngredientRow {
  Name: string;
  Slug?: string;
  'Short Name': string;
  Category: string;
  Subcategory: string;
  'Cost Per Oz': number;
  Active?: boolean;
}

export interface AirtableDrinkRow {
  Name: string;
  Description?: string;
  Category: string;
  Style: string;
  Family: string;
  'Required Ice': string;
  'Required Method': string;
  'Garnish Required'?: boolean;
  Active?: boolean;
}

export interface AirtableVenueRow {
  Name: string;
  Description: string;
  Location: string;
  Capacity: number;
  'Base Pay Per Hour': number;
  'Minimum Hours Per Shift': number;
  'Minimum Bar Take': number;
}

export interface AirtableVenueHoursRow {
  Venue: string[];
  Weekday: string;
  Open?: boolean;
  'Start Time'?: string;
  'End Time'?: string;
}

export interface AirtableVenueMenuRow {
  Venue: string[];
  Drink: string[];
  Price: number;
  'Is Signature'?: boolean;
  Active?: boolean;
}

export interface AirtableRecipeLineRow {
  Drink: string[];
  Ingredient: string[];
  'Amount Oz': number;
  'Sort Order'?: number;
}

export interface AirtableGlassOptionRow {
  Drink: string[];
  Glassware: string[];
  Role: 'Ideal' | 'Acceptable';
}

export interface AirtableGarnishOptionRow {
  Drink: string[];
  Garnish: string[];
  Role: 'Ideal' | 'Acceptable';
}

export interface AirtableImportBundle {
  ingredients: AirtableIngredientRow[];
  garnishes: Array<{
    Name: string;
    'Short Name': string;
    Category: string;
    Cost: number;
  }>;
  glassware: Array<{
    Name: string;
    'Short Name': string;
    Category: string;
  }>;
  drinks: AirtableDrinkRow[];
  recipeLines: AirtableRecipeLineRow[];
  glassOptions: AirtableGlassOptionRow[];
  garnishOptions: AirtableGarnishOptionRow[];
  venues: AirtableVenueRow[];
  venueHours: AirtableVenueHoursRow[];
  venueMenu: AirtableVenueMenuRow[];
}

function linkedName(value: string[] | undefined): string {
  return value?.[0] ?? '';
}

export function mapAirtableToCatalog(bundle: AirtableImportBundle): GameCatalog {
  const ingredients: IngredientRecord[] = bundle.ingredients
    .filter((r) => r.Active !== false)
    .map((r) => ({
      name: r.Name,
      shortName: r['Short Name'],
      category: r.Category,
      subcategory: r.Subcategory,
      cost: r['Cost Per Oz'],
    }));

  const garnishes: GarnishRecord[] = bundle.garnishes.map((r) => ({
    name: r.Name,
    shortName: r['Short Name'],
    category: r.Category,
    cost: r.Cost,
  }));

  const glassware: GlasswareRecord[] = bundle.glassware.map((r) => ({
    name: r.Name,
    shortName: r['Short Name'],
    category: r.Category,
  }));

  const venues: VenueRecord[] = bundle.venues.map((v) => {
    const hoursForVenue = bundle.venueHours.filter(
      (h) => linkedName(h.Venue) === v.Name
    );
    const shiftPattern: VenueShiftDay[] = hoursForVenue.map((h) => ({
      day: h.Weekday,
      start: h.Open === false ? null : h['Start Time'] ?? null,
      end: h.Open === false ? null : h['End Time'] ?? null,
    }));

    return {
      name: v.Name,
      description: v.Description,
      location: v.Location,
      capacity: v.Capacity,
      shiftLengthHours: 8,
      basePayPerHour: v['Base Pay Per Hour'],
      minimumHoursPerShift: v['Minimum Hours Per Shift'],
      minimumBarTake: v['Minimum Bar Take'],
      shiftPattern,
    };
  });

  const drinks: DrinkRecord[] = bundle.drinks
    .filter((d) => d.Active !== false)
    .map((d) => {
      const drinkName = d.Name;
      const recipe = bundle.recipeLines
        .filter((line) => linkedName(line.Drink) === drinkName)
        .sort(
          (a, b) => (a['Sort Order'] ?? 0) - (b['Sort Order'] ?? 0)
        )
        .map((line) => ({
          ingredientName: linkedName(line.Ingredient),
          amountOz: line['Amount Oz'],
        }));

      const glassRequirement = {
        ideal: bundle.glassOptions
          .filter(
            (g) =>
              linkedName(g.Drink) === drinkName && g.Role === 'Ideal'
          )
          .map((g) => linkedName(g.Glassware)),
        acceptable: bundle.glassOptions
          .filter(
            (g) =>
              linkedName(g.Drink) === drinkName && g.Role === 'Acceptable'
          )
          .map((g) => linkedName(g.Glassware)),
      };

      const garnishRequirement = {
        ideal: bundle.garnishOptions
          .filter(
            (g) =>
              linkedName(g.Drink) === drinkName && g.Role === 'Ideal'
          )
          .map((g) => linkedName(g.Garnish)),
        acceptable: bundle.garnishOptions
          .filter(
            (g) =>
              linkedName(g.Drink) === drinkName && g.Role === 'Acceptable'
          )
          .map((g) => linkedName(g.Garnish)),
        required: d['Garnish Required'] !== false,
      };

      return {
        name: drinkName,
        description: d.Description ?? '',
        recipe,
        requiredIce: d['Required Ice'],
        requiredMethod: d['Required Method'],
        glassRequirement,
        garnishRequirement,
        category: d.Category,
        style: d.Style,
        family: d.Family,
      };
    });

  const venueMenus: Record<string, VenueMenuItemRecord[]> = {};
  for (const row of bundle.venueMenu) {
    if (row.Active === false) continue;
    const venueName = linkedName(row.Venue);
    const drinkName = linkedName(row.Drink);
    if (!venueMenus[venueName]) venueMenus[venueName] = [];
    venueMenus[venueName].push({
      drinkName,
      price: row.Price,
      isSignature: row['Is Signature'] ?? false,
    });
  }

  return {
    version: 1,
    extractedAt: new Date().toISOString(),
    ingredients,
    garnishes,
    glassware,
    drinks,
    venues,
    venueMenus,
    orderPhrases: [
      "I'd like %@, please!",
      "I'd like to try %@.",
      'Could I have %@?',
      "I'll take %@.",
      'Make me %@.',
    ],
    livingSituations: [],
    transportOptions: [],
    gameConfig: {
      customerPatienceBaseSeconds: 300,
      customerPatienceVariationSeconds: 30,
      maxActiveCustomers: 8,
      customersPerWave: 5,
      initialCustomerCount: 1,
      customerGenerationBaseSeconds: 60,
      customerGenerationVariationSeconds: 30,
      returningCustomerChance: 0.3,
      tipMultiplierIdeal: 1,
      tipMultiplierAcceptable: 0.8,
      tipMultiplierWrong: 0.2,
      belowMinimumBarTakeWagePenalty: 0.1,
      aboveMinimumBarTakeBonusThreshold: 1.5,
      aboveMinimumBarTakeBonus: 0.15,
    },
  };
}
