export interface IngredientRecord {
  name: string;
  shortName: string;
  category: string;
  subcategory: string;
  cost: number;
}

export interface GarnishRecord {
  name: string;
  shortName: string;
  category: string;
  cost: number;
}

export interface GlasswareRecord {
  name: string;
  shortName: string;
  category: string;
}

export interface DrinkRecipeLine {
  ingredientName: string;
  amountOz: number;
}

export interface GlassRequirementData {
  ideal: string[];
  acceptable: string[];
  minimum?: string | null;
}

export interface GarnishRequirementData {
  ideal: string[];
  acceptable: string[];
  required: boolean;
}

export interface DrinkRecord {
  name: string;
  description: string;
  recipe: DrinkRecipeLine[];
  requiredIce: string;
  requiredMethod: string;
  glassRequirement: GlassRequirementData;
  garnishRequirement: GarnishRequirementData;
  category: string;
  style: string;
  family: string;
}

export interface VenueShiftDay {
  day: string;
  start: string | null;
  end: string | null;
}

export interface VenueRecord {
  name: string;
  description: string;
  location: string;
  capacity: number;
  shiftLengthHours: number;
  basePayPerHour: number;
  minimumHoursPerShift: number;
  minimumBarTake: number;
  shiftPattern: VenueShiftDay[];
}

export interface VenueMenuItemRecord {
  drinkName: string;
  price: number;
  isSignature: boolean;
}

export interface LivingSituationRecord {
  name: string;
  dailyCost: number;
  oneOffCost: number;
}

export interface TransportOptionRecord {
  name: string;
  purchaseCost: number;
  perShiftCost: number;
}

export interface GameConfig {
  customerPatienceBaseSeconds: number;
  customerPatienceVariationSeconds: number;
  maxActiveCustomers: number;
  customersPerWave: number;
  initialCustomerCount: number;
  customerGenerationBaseSeconds: number;
  customerGenerationVariationSeconds: number;
  returningCustomerChance: number;
  tipMultiplierIdeal: number;
  tipMultiplierAcceptable: number;
  tipMultiplierWrong: number;
  belowMinimumBarTakeWagePenalty: number;
  aboveMinimumBarTakeBonusThreshold: number;
  aboveMinimumBarTakeBonus: number;
}

export interface GameCatalog {
  version: number;
  extractedAt: string;
  ingredients: IngredientRecord[];
  garnishes: GarnishRecord[];
  glassware: GlasswareRecord[];
  drinks: DrinkRecord[];
  venues: VenueRecord[];
  venueMenus: Record<string, VenueMenuItemRecord[]>;
  orderPhrases: string[];
  livingSituations: LivingSituationRecord[];
  transportOptions: TransportOptionRecord[];
  gameConfig: GameConfig;
}

export interface PreparationSelection {
  glasswareName: string | null;
  ice: string;
  method: string;
  ingredientNames: string[];
  garnishNames: string[];
}

export interface CustomerState {
  id: string;
  drinkOrder: string;
  avatarNumber: number;
  orderPhrase: string;
  mood: number;
  patienceRemainingSeconds: number;
  hasLeft: boolean;
  preparation?: PreparationSelection;
}

export interface ShiftMetrics {
  sales: number;
  tips: number;
  wastage: number;
  successfulDrinks: number;
  failedDrinks: number;
}

export interface RandomSource {
  random(): number;
  randomInt(min: number, max: number): number;
}
