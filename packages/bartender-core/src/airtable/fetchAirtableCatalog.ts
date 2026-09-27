import type { GameCatalog } from '../types/catalog.js';
import { GameCatalogService } from '../catalog/GameCatalogService.js';
import {
  mapAirtableToCatalog,
  type AirtableImportBundle,
} from './mapAirtableToCatalog.js';

export interface AirtableFetchConfig {
  apiKey: string;
  baseId: string;
  tableNames?: Partial<Record<keyof AirtableImportBundle, string>>;
}

const DEFAULT_TABLES: Record<keyof AirtableImportBundle, string> = {
  ingredients: 'Ingredients',
  garnishes: 'Garnishes',
  glassware: 'Glassware',
  drinks: 'Drinks',
  recipeLines: 'Drink Recipe Lines',
  glassOptions: 'Drink Glass Options',
  garnishOptions: 'Drink Garnish Options',
  venues: 'Venues',
  venueHours: 'Venue Hours',
  venueMenu: 'Venue Menu Items',
};

async function fetchTable<T>(
  config: AirtableFetchConfig,
  tableKey: keyof AirtableImportBundle
): Promise<T[]> {
  const tableName = config.tableNames?.[tableKey] ?? DEFAULT_TABLES[tableKey];
  const url = `https://api.airtable.com/v0/${config.baseId}/${encodeURIComponent(tableName)}`;
  const records: T[] = [];
  let offset: string | undefined;

  do {
    const query = offset ? `?offset=${offset}` : '';
    const response = await fetch(`${url}${query}`, {
      headers: { Authorization: `Bearer ${config.apiKey}` },
    });
    if (!response.ok) {
      throw new Error(
        `Airtable fetch failed for ${tableName}: ${response.status} ${response.statusText}`
      );
    }
    const body = (await response.json()) as {
      records: Array<{ fields: T }>;
      offset?: string;
    };
    records.push(...body.records.map((r) => r.fields));
    offset = body.offset;
  } while (offset);

  return records;
}

/** Fetches all catalog tables from Airtable and returns a GameCatalogService. */
export async function fetchAirtableCatalog(
  config: AirtableFetchConfig
): Promise<GameCatalogService> {
  const bundle: AirtableImportBundle = {
    ingredients: await fetchTable(config, 'ingredients'),
    garnishes: await fetchTable(config, 'garnishes'),
    glassware: await fetchTable(config, 'glassware'),
    drinks: await fetchTable(config, 'drinks'),
    recipeLines: await fetchTable(config, 'recipeLines'),
    glassOptions: await fetchTable(config, 'glassOptions'),
    garnishOptions: await fetchTable(config, 'garnishOptions'),
    venues: await fetchTable(config, 'venues'),
    venueHours: await fetchTable(config, 'venueHours'),
    venueMenu: await fetchTable(config, 'venueMenu'),
  };

  const catalog: GameCatalog = mapAirtableToCatalog(bundle);
  return new GameCatalogService(catalog);
}
