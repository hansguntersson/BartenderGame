import { describe, expect, it } from 'vitest';
import { loadCatalogFromObject } from '../src/catalog/loadCatalog.js';
import { checkDrink, getTipMultiplier } from '../src/domain/preparation.js';
import { calculateShiftPay } from '../src/domain/shift.js';
import { indefiniteArticle } from '../src/utils/strings.js';
import { calculateShiftLengthHours } from '../src/domain/venue.js';
import fs from 'node:fs';
import path from 'node:path';
import type { GameCatalog } from '../src/types/catalog.js';

const catalogPath = path.join(
  import.meta.dirname,
  '../data/catalog.json'
);
const catalogJson = JSON.parse(
  fs.readFileSync(catalogPath, 'utf8')
) as GameCatalog;
const catalog = loadCatalogFromObject(catalogJson);

describe('catalog extraction', () => {
  it('loads drinks and venues from Swift extract', () => {
    expect(catalogJson.drinks.length).toBeGreaterThan(50);
    expect(catalogJson.venues.length).toBe(11);
    expect(catalogJson.ingredients.length).toBeGreaterThan(100);
  });
});

describe('preparation', () => {
  it('validates a correct Negroni build', () => {
    const drink = catalog.getDrink('Negroni');
    expect(drink).toBeDefined();
    const ok = checkDrink(drink!, {
      glasswareName: 'Old Fashioned Glass',
      ice: 'Cubed',
      method: 'Stir',
      ingredientNames: ['Gin', 'Campari', 'Sweet Vermouth'],
      garnishNames: ['Orange Twist'],
    });
    expect(ok).toBe(true);
  });

  it('computes tip multiplier for ideal glass and garnish', () => {
    const drink = catalog.getDrink('Cosmopolitan');
    expect(drink).toBeDefined();
    const multiplier = getTipMultiplier(
      drink!,
      {
        glasswareName: 'Cosmopolitan Glass',
        ice: 'None',
        method: 'Shake',
        ingredientNames: [
          'Vodka',
          'Triple Sec',
          'Cranberry Juice',
          'Lime Juice',
        ],
        garnishNames: ['Flaming Orange Zest'],
      },
      catalogJson.gameConfig
    );
    expect(multiplier).toBe(1);
  });
});

describe('venue', () => {
  it('calculates overnight shift length like Swift', () => {
    expect(calculateShiftLengthHours('11AM - 1AM')).toBe(14);
    expect(calculateShiftLengthHours('6PM - 2AM')).toBe(8);
  });
});

describe('strings', () => {
  it('chooses a/an like Swift', () => {
    expect(indefiniteArticle('Old Fashioned')).toBe('an');
    expect(indefiniteArticle('Mojito')).toBe('a');
  });
});

describe('shift pay', () => {
  it('applies minimum bar take penalty to base pay only', () => {
    const venue = catalog.getVenue("The Bear & Badger");
    expect(venue).toBeDefined();
    const result = calculateShiftPay({
      venue: venue!,
      sales: 100,
      tips: 20,
      wastage: 5,
      hoursWorked: 8,
      config: catalogJson.gameConfig,
    });
    expect(result.basePay).toBe(72);
    expect(result.salesPenalty).toBeCloseTo(7.2);
    expect(result.totalEarnings).toBeCloseTo(79.8);
  });
});
