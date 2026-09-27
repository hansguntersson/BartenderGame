import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import type { GameCatalog } from '../types/catalog.js';
import { GameCatalogService } from './GameCatalogService.js';

const moduleDir = path.dirname(fileURLToPath(import.meta.url));

export function loadCatalogFromObject(data: GameCatalog): GameCatalogService {
  return new GameCatalogService(data);
}

/** Loads bundled catalog.json (generated from Swift via npm run extract-data). */
export function loadBundledCatalog(): GameCatalogService {
  const catalogPath = path.join(moduleDir, '../../data/catalog.json');
  const raw = fs.readFileSync(catalogPath, 'utf8');
  return loadCatalogFromObject(JSON.parse(raw) as GameCatalog);
}
