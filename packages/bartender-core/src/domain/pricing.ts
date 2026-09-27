import type { DrinkRecord } from '../types/catalog.js';
import { GameCatalogService } from '../catalog/GameCatalogService.js';

/** Port of ContentView.calculateDrinkCost / DrinksMenuData.calculateIngredientCost */
export function calculateDrinkIngredientCost(
  drink: DrinkRecord,
  catalog: GameCatalogService
): number {
  let total = 0;
  for (const line of drink.recipe) {
    const ingredient = catalog.getIngredient(line.ingredientName);
    if (ingredient) {
      total += ingredient.cost * line.amountOz;
    }
  }
  return total;
}

export function calculateDrinkCostByName(
  drinkName: string,
  catalog: GameCatalogService
): number {
  const drink = catalog.getDrink(drinkName);
  if (!drink) return 0;
  return calculateDrinkIngredientCost(drink, catalog);
}

export function calculateMarkup(
  drinkName: string,
  menuPrice: number,
  catalog: GameCatalogService
): number {
  const cost = calculateDrinkCostByName(drinkName, catalog);
  if (cost <= 0) return 0;
  return ((menuPrice - cost) / cost) * 100;
}
