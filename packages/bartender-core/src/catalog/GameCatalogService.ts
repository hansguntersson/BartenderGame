import type {
  DrinkRecord,
  GameCatalog,
  GarnishRecord,
  GlasswareRecord,
  IngredientRecord,
  VenueMenuItemRecord,
  VenueRecord,
} from '../types/catalog.js';

export class GameCatalogService {
  private readonly ingredientByName: Map<string, IngredientRecord>;
  private readonly garnishByName: Map<string, GarnishRecord>;
  private readonly glassByName: Map<string, GlasswareRecord>;
  private readonly drinkByName: Map<string, DrinkRecord>;
  private readonly venueByName: Map<string, VenueRecord>;

  constructor(public readonly catalog: GameCatalog) {
    this.ingredientByName = new Map(catalog.ingredients.map((i) => [i.name, i]));
    this.garnishByName = new Map(catalog.garnishes.map((g) => [g.name, g]));
    this.glassByName = new Map(catalog.glassware.map((g) => [g.name, g]));
    this.drinkByName = new Map(catalog.drinks.map((d) => [d.name, d]));
    this.venueByName = new Map(catalog.venues.map((v) => [v.name, v]));
  }

  getDrink(name: string): DrinkRecord | undefined {
    return this.drinkByName.get(name);
  }

  getVenue(name: string): VenueRecord | undefined {
    return this.venueByName.get(name);
  }

  getIngredient(name: string): IngredientRecord | undefined {
    return this.ingredientByName.get(name);
  }

  getGarnish(name: string): GarnishRecord | undefined {
    return this.garnishByName.get(name);
  }

  getGlassware(name: string): GlasswareRecord | undefined {
    return this.glassByName.get(name);
  }

  getVenueMenu(venueName: string): VenueMenuItemRecord[] {
    return this.catalog.venueMenus[venueName] ?? [];
  }

  getDrinkPrice(venueName: string, drinkName: string): number {
    const item = this.getVenueMenu(venueName).find(
      (m) => m.drinkName === drinkName
    );
    return item?.price ?? 0;
  }
}
