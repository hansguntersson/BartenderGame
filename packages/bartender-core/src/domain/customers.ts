import type {
  CustomerState,
  GameCatalog,
  RandomSource,
} from '../types/catalog.js';
import { formatOrderPhrase } from '../utils/strings.js';
import { randomInRange } from '../utils/math.js';
import { GameCatalogService } from '../catalog/GameCatalogService.js';

export interface CustomerGenerationContext {
  venueName: string;
  venueMood: number;
  activeCustomers: CustomerState[];
  previousCustomers: CustomerState[];
  catalog: GameCatalogService;
  random: RandomSource;
  config: GameCatalog['gameConfig'];
}

function pickOrderPhrase(catalog: GameCatalog, random: RandomSource): string {
  const phrases = catalog.orderPhrases;
  const index = random.randomInt(0, phrases.length - 1);
  return phrases[index] ?? "I'd like %@, please!";
}

function createPatienceSeconds(
  config: GameCatalog['gameConfig'],
  random: RandomSource
): number {
  const variation = randomInRange(
    -config.customerPatienceVariationSeconds,
    config.customerPatienceVariationSeconds,
    random.random
  );
  return config.customerPatienceBaseSeconds + variation;
}

/** Port of ContentView.generateMoodInfluencedByVenue() */
export function generateMoodInfluencedByVenue(
  venueMood: number,
  random: RandomSource
): number {
  let moodWeights: number[];

  switch (venueMood) {
    case 5:
      moodWeights = [0.05, 0.1, 0.2, 0.3, 0.35];
      break;
    case 4:
      moodWeights = [0.08, 0.15, 0.25, 0.3, 0.22];
      break;
    case 3:
      moodWeights = [0.15, 0.2, 0.3, 0.2, 0.15];
      break;
    case 2:
      moodWeights = [0.25, 0.3, 0.25, 0.15, 0.05];
      break;
    case 1:
      moodWeights = [0.4, 0.3, 0.2, 0.08, 0.02];
      break;
    default:
      moodWeights = [0.1, 0.1, 0.1, 0.1, 0.1];
  }

  const r = random.random();
  let cumulative = 0;
  for (let i = 0; i < moodWeights.length; i++) {
    cumulative += moodWeights[i];
    if (r <= cumulative) return i + 1;
  }
  return 3;
}

function shuffle<T>(items: T[], random: RandomSource): T[] {
  const copy = [...items];
  for (let i = copy.length - 1; i > 0; i--) {
    const j = random.randomInt(0, i);
    [copy[i], copy[j]] = [copy[j], copy[i]];
  }
  return copy;
}

function createRandomCustomer(ctx: CustomerGenerationContext): CustomerState {
  const menu = ctx.catalog.getVenueMenu(ctx.venueName);
  const availableDrinks = menu.map((m) => m.drinkName);
  if (availableDrinks.length === 0) {
    throw new Error(`No drinks found for venue: ${ctx.venueName}`);
  }

  const allAvatars = Array.from({ length: 10 }, (_, i) => i + 1);
  const usedAvatars = new Set(ctx.activeCustomers.map((c) => c.avatarNumber));
  const availableAvatars = allAvatars.filter((a) => !usedAvatars.has(a));

  const drinkName =
    availableDrinks[ctx.random.randomInt(0, availableDrinks.length - 1)] ??
    availableDrinks[0];
  const avatarNumber =
    availableAvatars[ctx.random.randomInt(0, availableAvatars.length - 1)] ??
    availableAvatars[0];

  const phraseTemplate = pickOrderPhrase(ctx.catalog.catalog, ctx.random);

  return {
    id: crypto.randomUUID(),
    drinkOrder: drinkName,
    avatarNumber,
    orderPhrase: formatOrderPhrase(phraseTemplate, drinkName),
    mood: generateMoodInfluencedByVenue(ctx.venueMood, ctx.random),
    patienceRemainingSeconds: createPatienceSeconds(ctx.config, ctx.random),
    hasLeft: false,
  };
}

/** Port of Customer.initializeActiveCustomers / generateNewCustomerSet */
export function generateCustomerWave(
  ctx: CustomerGenerationContext,
  count = ctx.config.customersPerWave
): CustomerState[] {
  const menu = ctx.catalog.getVenueMenu(ctx.venueName);
  const drinkNames = shuffle(
    menu.map((m) => m.drinkName),
    ctx.random
  ).slice(0, count);
  const avatars = shuffle(
    Array.from({ length: 10 }, (_, i) => i + 1),
    ctx.random
  ).slice(0, count);

  return drinkNames.map((drinkName, index) => {
    const phraseTemplate = pickOrderPhrase(ctx.catalog.catalog, ctx.random);
    return {
      id: crypto.randomUUID(),
      drinkOrder: drinkName,
      avatarNumber: avatars[index] ?? index + 1,
      orderPhrase: formatOrderPhrase(phraseTemplate, drinkName),
      mood: ctx.random.randomInt(1, 5),
      patienceRemainingSeconds: createPatienceSeconds(ctx.config, ctx.random),
      hasLeft: false,
    };
  });
}

/** Port of ContentView.generateNewCustomer() */
export function generateNewCustomer(
  ctx: CustomerGenerationContext
): CustomerState | null {
  if (ctx.activeCustomers.length >= ctx.config.maxActiveCustomers) {
    return null;
  }

  const useReturning =
    ctx.previousCustomers.length > 0 &&
    ctx.random.random() < ctx.config.returningCustomerChance;

  if (useReturning) {
    const available = ctx.previousCustomers.filter(
      (prev) =>
        !ctx.activeCustomers.some((c) => c.avatarNumber === prev.avatarNumber)
    );
    const returning = available[ctx.random.randomInt(0, available.length - 1)];
    if (returning) {
      return {
        ...returning,
        id: crypto.randomUUID(),
        patienceRemainingSeconds: createPatienceSeconds(ctx.config, ctx.random),
        mood: generateMoodInfluencedByVenue(ctx.venueMood, ctx.random),
        hasLeft: false,
      };
    }
  }

  return createRandomCustomer(ctx);
}

export function nextCustomerGenerationDelaySeconds(
  config: GameCatalog['gameConfig'],
  random: RandomSource
): number {
  const variation = randomInRange(
    -config.customerGenerationVariationSeconds,
    config.customerGenerationVariationSeconds,
    random.random
  );
  return config.customerGenerationBaseSeconds + variation;
}
