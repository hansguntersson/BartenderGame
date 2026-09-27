import { roundTo, randomInRange } from '../utils/math.js';
import type { RandomSource } from '../types/catalog.js';

/** Port of ContentView onContinue tip calculation (mood-based). */
export function calculateTipForSuccessfulDrink(
  drinkPrice: number,
  customerMood: number,
  tipMultiplier: number,
  random: RandomSource
): number {
  let tip = 0;

  switch (customerMood) {
    case 5:
      tip =
        drinkPrice *
        randomInRange(0.2, 0.25, random.random) *
        tipMultiplier;
      break;
    case 4:
      tip =
        drinkPrice *
        randomInRange(0.15, 0.2, random.random) *
        tipMultiplier;
      break;
    case 3:
      if (random.random() < 0.8) {
        tip =
          drinkPrice *
          randomInRange(0.1, 0.15, random.random) *
          tipMultiplier;
      }
      break;
    case 2:
      if (random.random() < 0.4) {
        tip =
          drinkPrice *
          randomInRange(0.05, 0.1, random.random) *
          tipMultiplier;
      }
      break;
    case 1:
      if (random.random() < 0.1) {
        tip =
          drinkPrice *
          randomInRange(0, 0.05, random.random) *
          tipMultiplier;
      }
      break;
    default:
      tip = 0;
  }

  return roundTo(tip, 2);
}
