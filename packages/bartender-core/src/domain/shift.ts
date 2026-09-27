import type { VenueRecord } from '../types/catalog.js';
import { roundTo } from '../utils/math.js';

export interface ShiftPayInput {
  venue: VenueRecord;
  sales: number;
  tips: number;
  wastage: number;
  hoursWorked: number;
  config: {
    belowMinimumBarTakeWagePenalty: number;
    aboveMinimumBarTakeBonusThreshold: number;
    aboveMinimumBarTakeBonus: number;
  };
}

export interface ShiftPayBreakdown {
  basePay: number;
  minimumHoursMet: boolean;
  salesPenalty: number;
  salesBonus: number;
  totalEarnings: number;
}

/** Port of DailyTransitionManager.calculateShiftEarnings + calculateBasePay */
export function calculateShiftPay(input: ShiftPayInput): ShiftPayBreakdown {
  const { venue, sales, tips, wastage, hoursWorked, config } = input;
  const minimumHoursMet = hoursWorked >= venue.minimumHoursPerShift;
  const basePay = minimumHoursMet ? venue.basePayPerHour * hoursWorked : 0;

  let totalEarnings = basePay + tips - wastage;
  let salesPenalty = 0;
  let salesBonus = 0;

  if (sales < venue.minimumBarTake) {
    salesPenalty = basePay * config.belowMinimumBarTakeWagePenalty;
    totalEarnings -= salesPenalty;
  } else if (sales >= venue.minimumBarTake * config.aboveMinimumBarTakeBonusThreshold) {
    salesBonus = basePay * config.aboveMinimumBarTakeBonus;
    totalEarnings += salesBonus;
  }

  return {
    basePay: roundTo(basePay, 2),
    minimumHoursMet,
    salesPenalty: roundTo(salesPenalty, 2),
    salesBonus: roundTo(salesBonus, 2),
    totalEarnings: roundTo(totalEarnings, 2),
  };
}

export function canEndShift(
  venue: VenueRecord,
  totalElapsedSeconds: number
): boolean {
  return totalElapsedSeconds >= venue.minimumHoursPerShift * 3600;
}
