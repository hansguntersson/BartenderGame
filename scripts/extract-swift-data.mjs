#!/usr/bin/env node
/**
 * Extracts game catalog JSON from Swift source (single source of truth until Airtable sync).
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.join(__dirname, '..');
const OUT = path.join(ROOT, 'packages/bartender-core/data/catalog.json');

function readSwift(relPath) {
  return fs.readFileSync(path.join(ROOT, relPath), 'utf8');
}

function parseEnumCases(source, enumName) {
  const re = new RegExp(
    `enum ${enumName}[^\\{]*\\{([\\s\\S]*?)\\n\\}`,
    'm'
  );
  const block = source.match(re)?.[1] ?? '';
  const map = {};
  for (const m of block.matchAll(/case\s+(\w+)\s*=\s*"([^"]+)"/g)) {
    map[m[1]] = m[2];
  }
  for (const m of block.matchAll(/case\s+(\w+)\s*,/g)) {
    if (!map[m[1]]) {
      const pascal = m[1].replace(/([A-Z])/g, ' $1').trim();
      map[m[1]] = pascal.charAt(0).toUpperCase() + pascal.slice(1);
    }
  }
  return map;
}

function parseIngredients(source) {
  const items = [];
  const re =
    /DrinkIngredient\(name:\s*"([^"]+)",\s*shortName:\s*"([^"]+)",\s*category:\s*\.(\w+),\s*subcategory:\s*"([^"]+)",\s*cost:\s*([\d.]+)/g;
  for (const m of source.matchAll(re)) {
    items.push({
      name: m[1],
      shortName: m[2],
      category: m[3],
      subcategory: m[4],
      cost: parseFloat(m[5]),
    });
  }
  return items;
}

function parseGarnishes(source) {
  const categoryMap = parseEnumCases(source, 'GarnishCategory');
  const items = [];
  const re =
    /Garnish\(name:\s*"([^"]+)",\s*shortName:\s*"([^"]+)",\s*category:\s*\.(\w+),\s*cost:\s*([\d.]+)/g;
  for (const m of source.matchAll(re)) {
    items.push({
      name: m[1],
      shortName: m[2],
      category: categoryMap[m[3]] ?? m[3],
      cost: parseFloat(m[4]),
    });
  }
  return items;
}

function parseGlassware(source) {
  const categoryMap = parseEnumCases(source, 'GlasswareCategory');
  const items = [];
  const re =
    /Glassware\(name:\s*"([^"]+)",\s*shortName:\s*"([^"]+)",\s*category:\s*\.(\w+)\)/g;
  for (const m of source.matchAll(re)) {
    items.push({
      name: m[1],
      shortName: m[2],
      category: categoryMap[m[3]] ?? m[3],
    });
  }
  return items;
}

function parseVenues(source) {
  const weekdayMap = parseEnumCases(
    readSwift('BartenderGame/Venue.swift'),
    'Weekday'
  );
  const venues = [];
  const venueRe =
    /Venue\(\s*name:\s*"([^"]+)",\s*description:\s*"([^"]+)",\s*location:\s*"([^"]+)",\s*capacity:\s*(\d+),\s*shiftLengthHours:\s*(\d+),[\s\S]*?basePayPerHour:\s*([\d.]+),\s*minimumHoursPerShift:\s*(\d+),\s*minimumBarTake:\s*([\d.]+),\s*shiftPattern:\s*\[([\s\S]*?)\]\s*\)/g;

  for (const m of source.matchAll(venueRe)) {
    const patternBlock = m[9];
    const shiftPattern = [];
    const dayRe =
      /\(\.(\w+),\s*(?:"([^"]*)"|nil),\s*(?:"([^"]*)"|nil)\)/g;
    for (const d of patternBlock.matchAll(dayRe)) {
      const dayKey = d[1];
      shiftPattern.push({
        day: weekdayMap[dayKey] ?? dayKey,
        start: d[2] ?? null,
        end: d[3] ?? null,
      });
    }
    venues.push({
      name: m[1],
      description: m[2],
      location: m[3],
      capacity: parseInt(m[4], 10),
      shiftLengthHours: parseInt(m[5], 10),
      basePayPerHour: parseFloat(m[6]),
      minimumHoursPerShift: parseInt(m[7], 10),
      minimumBarTake: parseFloat(m[8]),
      shiftPattern,
    });
  }
  return venues;
}

function parseVenueMenus(source) {
  const menus = {};
  const venueBlocks = source.matchAll(
    /"([^"]+)":\s*\[([\s\S]*?)\n        \]/g
  );
  for (const vb of venueBlocks) {
    const venueName = vb[1];
    const block = vb[2];
    const items = [];
    const lineRe =
      /VenueDrink\(drink:\s*Drink\.allDrinks\.first\(where:\s*\{\s*\$0\.name\s*==\s*"([^"]+)"\s*\}\)!,\s*price:\s*([\d.]+),\s*isSignature:\s*(true|false)\)/g;
    for (const m of block.matchAll(lineRe)) {
      items.push({
        drinkName: m[1],
        price: parseFloat(m[2]),
        isSignature: m[3] === 'true',
      });
    }
    menus[venueName] = items;
  }
  return menus;
}

function namesFromGlassBlock(block) {
  const names = [];
  for (const m of block.matchAll(/\$0\.name\s*==\s*"([^"]+)"/g)) {
    names.push(m[1]);
  }
  return names;
}

function parseDrinks(source, sharedSource, drinkSource) {
  const iceMap = parseEnumCases(sharedSource, 'IceType');
  const methodMap = parseEnumCases(sharedSource, 'MethodType');
  const categoryMap = parseEnumCases(drinkSource, 'DrinkCategory');
  const styleMap = parseEnumCases(drinkSource, 'DrinkStyle');
  const familyMap = parseEnumCases(drinkSource, 'DrinkFamily');

  const drinks = [];
  const chunks = source.split(/\n        Drink\(\n/);
  chunks.shift();

  for (const chunk of chunks) {
    const name = chunk.match(/name:\s*"([^"]+)"/)?.[1];
    if (!name) continue;

    const recipe = [];
    for (const m of chunk.matchAll(
      /DrinkIngredient\(name:\s*"([^"]+)",\s*amount:\s*([\d.]+)\)/g
    )) {
      recipe.push({ ingredientName: m[1], amountOz: parseFloat(m[2]) });
    }

    const description =
      chunk.match(/description:\s*"([^"]*)"/)?.[1] ?? '';

    const iceKey = chunk.match(/requiredIce:\s*\.(\w+)/)?.[1];
    const methodKey = chunk.match(/requiredMethod:\s*\.(\w+)/)?.[1];

    const glassBlock = chunk.match(
      /glassRequirement:\s*GlassRequirement\(([\s\S]*?)\),\s*\n\s*garnishRequirement/
    )?.[1];
    const garnishBlock = chunk.match(
      /garnishRequirement:\s*GarnishRequirement\(([\s\S]*?)\),\s*\n\s*category/
    )?.[1];

    let idealGlass = [];
    let acceptableGlass = [];
    if (glassBlock) {
      const idealPart = glassBlock.match(/ideal:\s*\[([\s\S]*?)\],/)?.[1] ?? '';
      const acceptablePart =
        glassBlock.match(/acceptable:\s*\[([\s\S]*?)\](?:,\s*minimum|$)/)?.[1] ??
        '';
      idealGlass = namesFromGlassBlock(idealPart);
      acceptableGlass = namesFromGlassBlock(acceptablePart);
    }

    let idealGarnish = [];
    let acceptableGarnish = [];
    let garnishRequired = true;
    if (garnishBlock) {
      const idealPart =
        garnishBlock.match(/ideal:\s*\[([\s\S]*?)\],/)?.[1] ?? '';
      const acceptablePart =
        garnishBlock.match(/acceptable:\s*\[([\s\S]*?)\]/)?.[1] ?? '';
      idealGarnish = namesFromGlassBlock(idealPart);
      acceptableGarnish = namesFromGlassBlock(acceptablePart);
      if (/required:\s*false/.test(garnishBlock)) garnishRequired = false;
    }

    const categoryKey = chunk.match(/category:\s*\.(\w+)/)?.[1];
    const styleKey = chunk.match(/style:\s*\.(\w+)/)?.[1];
    const familyKey = chunk.match(/family:\s*\.(\w+)/)?.[1];

    drinks.push({
      name,
      description,
      recipe,
      requiredIce: iceMap[iceKey] ?? iceKey,
      requiredMethod: methodMap[methodKey] ?? methodKey,
      glassRequirement: { ideal: idealGlass, acceptable: acceptableGlass },
      garnishRequirement: {
        ideal: idealGarnish,
        acceptable: acceptableGarnish,
        required: garnishRequired,
      },
      category: categoryMap[categoryKey] ?? categoryKey,
      style: styleMap[styleKey] ?? styleKey,
      family: familyMap[familyKey] ?? familyKey,
    });
  }

  return drinks;
}

function parseOrderPhrases() {
  return [
    "I'd like %@, please!",
    "I'd like to try %@.",
    'Could I have %@?',
    "I'll take %@.",
    'Make me %@.',
  ];
}

function parseLivingAndTransport() {
  return {
    livingSituations: [
      { name: 'Living with Parents', dailyCost: 0, oneOffCost: 0 },
      { name: 'Shared Flat', dailyCost: 15, oneOffCost: 100 },
      { name: 'Studio Flat', dailyCost: 25, oneOffCost: 1000 },
      { name: 'One Bedroom Flat', dailyCost: 35, oneOffCost: 1500 },
      { name: 'Two Bedroom Flat', dailyCost: 45, oneOffCost: 2000 },
      { name: 'House Share', dailyCost: 20, oneOffCost: 300 },
      { name: 'Luxury Apartment', dailyCost: 60, oneOffCost: 5000 },
    ],
    transportOptions: [
      { name: 'Walking', purchaseCost: 0, perShiftCost: 0 },
      { name: 'Bus', purchaseCost: 0, perShiftCost: 3 },
      { name: 'Bike', purchaseCost: 100, perShiftCost: 0.5 },
      { name: 'Scooter', purchaseCost: 800, perShiftCost: 1 },
      { name: 'Car', purchaseCost: 3000, perShiftCost: 5 },
      { name: 'Luxury Car', purchaseCost: 15000, perShiftCost: 8 },
    ],
  };
}

function main() {
  const ingredients = parseIngredients(readSwift('BartenderGame/Ingredients.swift'));
  const garnishes = parseGarnishes(readSwift('BartenderGame/Garnishes.swift'));
  const glassware = parseGlassware(readSwift('BartenderGame/Glassware.swift'));
  const venues = parseVenues(readSwift('BartenderGame/Venue.swift'));
  const venueMenus = parseVenueMenus(readSwift('BartenderGame/VenueDrinks.swift'));
  const shared = readSwift('BartenderGame/SharedTypes.swift');
  const drinkSwift = readSwift('BartenderGame/Drink.swift');
  const drinks = parseDrinks(drinkSwift, shared, drinkSwift);
  const { livingSituations, transportOptions } = parseLivingAndTransport();

  const catalog = {
    version: 1,
    extractedAt: new Date().toISOString(),
    ingredients,
    garnishes,
    glassware,
    drinks,
    venues,
    venueMenus,
    orderPhrases: parseOrderPhrases(),
    livingSituations,
    transportOptions,
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

  fs.mkdirSync(path.dirname(OUT), { recursive: true });
  fs.writeFileSync(OUT, JSON.stringify(catalog, null, 2));

  console.log('Wrote catalog:', OUT);
  console.log(
    `  ingredients=${ingredients.length} garnishes=${garnishes.length} glassware=${glassware.length} drinks=${drinks.length} venues=${venues.length}`
  );
}

main();
