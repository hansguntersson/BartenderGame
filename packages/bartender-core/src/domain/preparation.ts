import type { DrinkRecord, GameConfig, PreparationSelection } from '../types/catalog.js';
import { roundTo } from '../utils/math.js';
import {
  allowsNoGarnish,
  getGarnishTipMultiplier,
  getGlassTipMultiplier,
  isValidGarnish,
  isValidGlass,
} from './requirements.js';

/** Port of PreparationView.checkDrink() */
export function checkDrink(
  drink: DrinkRecord,
  selection: PreparationSelection
): boolean {
  if (!selection.glasswareName) return false;

  const ingredientsCorrect =
    selection.ingredientNames.length === drink.recipe.length &&
    selection.ingredientNames.every((name) =>
      drink.recipe.some((line) => line.ingredientName === name)
    );

  const iceCorrect = selection.ice === drink.requiredIce;
  const methodCorrect = selection.method === drink.requiredMethod;
  const glassCorrect = isValidGlass(
    drink.glassRequirement,
    selection.glasswareName
  );

  const garnishCorrect = (() => {
    const req = drink.garnishRequirement;
    if (req.ideal.length === 0 && req.acceptable.length === 0) {
      return (
        selection.garnishNames.length === 0 ||
        selection.garnishNames.some((g) => g === 'None')
      );
    }
    if (req.required && selection.garnishNames.length === 0) return false;
    return selection.garnishNames.every((g) => isValidGarnish(req, g));
  })();

  return (
    ingredientsCorrect &&
    iceCorrect &&
    methodCorrect &&
    glassCorrect &&
    garnishCorrect
  );
}

/** Port of PreparationView.getTipMultiplier() */
export function getTipMultiplier(
  drink: DrinkRecord,
  selection: PreparationSelection,
  config: GameConfig
): number {
  if (!selection.glasswareName) return 0;

  const glassMultiplier = getGlassTipMultiplier(
    drink.glassRequirement,
    selection.glasswareName,
    config
  );

  let garnishMultiplier: number;
  const req = drink.garnishRequirement;
  if (selection.garnishNames.length === 0) {
    garnishMultiplier = allowsNoGarnish(req, req.required)
      ? config.tipMultiplierIdeal
      : config.tipMultiplierWrong;
  } else {
    garnishMultiplier = Math.max(
      ...selection.garnishNames.map((g) =>
        getGarnishTipMultiplier(req, g, config)
      )
    );
  }

  return roundTo((glassMultiplier + garnishMultiplier) / 2, 2);
}
