import type { GameCatalog } from '../types/catalog.js';
import { calculateShiftPay } from './shift.js';
import { GameCatalogService } from '../catalog/GameCatalogService.js';

export interface DailyTransitionInput {
  catalog: GameCatalogService;
  startedShiftVenueNames: string[];
  shiftsWorkedCount: number;
  playerLivingSituation: string;
  playerTransport: string;
  /** venueName -> seconds worked today */
  screenTimeByVenueSeconds: Record<string, number>;
  /** venueName -> shift metrics */
  metricsByVenue: Record<
    string,
    { sales: number; tips: number; wastage: number }
  >;
}

export interface DailyTransitionResult {
  totalEarnings: number;
  livingCosts: number;
  transportCosts: number;
  netChange: number;
  earningsByVenue: Record<string, number>;
}

/** Port of DailyTransitionManager.processDailyTransition economics */
export function processDailyTransition(
  input: DailyTransitionInput
): DailyTransitionResult {
  const { catalog } = input;
  const config = catalog.catalog.gameConfig;
  let totalEarnings = 0;
  const earningsByVenue: Record<string, number> = {};

  for (const venueName of input.startedShiftVenueNames) {
    const venue = catalog.getVenue(venueName);
    if (!venue) continue;

    const metrics = input.metricsByVenue[venueName] ?? {
      sales: 0,
      tips: 0,
      wastage: 0,
    };
    const seconds = input.screenTimeByVenueSeconds[venueName] ?? 0;
    const hoursWorked = seconds / 3600;

    const pay = calculateShiftPay({
      venue,
      sales: metrics.sales,
      tips: metrics.tips,
      wastage: metrics.wastage,
      hoursWorked,
      config,
    });

    earningsByVenue[venueName] = pay.totalEarnings;
    totalEarnings += pay.totalEarnings;
  }

  const living = catalog.catalog.livingSituations.find(
    (l) => l.name === input.playerLivingSituation
  );
  const livingCosts = living?.dailyCost ?? 0;

  const transport = catalog.catalog.transportOptions.find(
    (t) => t.name === input.playerTransport
  );
  const transportCosts =
    (transport?.perShiftCost ?? 0) * input.shiftsWorkedCount;

  const netChange = totalEarnings - livingCosts - transportCosts;

  return {
    totalEarnings,
    livingCosts,
    transportCosts,
    netChange,
    earningsByVenue,
  };
}
