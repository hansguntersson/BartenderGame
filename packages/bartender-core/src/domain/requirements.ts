import type { GameConfig } from '../types/catalog.js';

export interface NameRequirementSet {
  ideal: string[];
  acceptable: string[];
}

export function isValidGlass(
  requirement: NameRequirementSet,
  glassName: string
): boolean {
  return (
    requirement.ideal.includes(glassName) ||
    requirement.acceptable.includes(glassName)
  );
}

export function getGlassTipMultiplier(
  requirement: NameRequirementSet,
  glassName: string,
  config: Pick<
    GameConfig,
    'tipMultiplierIdeal' | 'tipMultiplierAcceptable' | 'tipMultiplierWrong'
  >
): number {
  if (requirement.ideal.includes(glassName)) return config.tipMultiplierIdeal;
  if (requirement.acceptable.includes(glassName)) {
    return config.tipMultiplierAcceptable;
  }
  return config.tipMultiplierWrong;
}

export function isValidGarnish(
  requirement: NameRequirementSet,
  garnishName: string
): boolean {
  return (
    requirement.ideal.includes(garnishName) ||
    requirement.acceptable.includes(garnishName)
  );
}

export function allowsNoGarnish(
  requirement: NameRequirementSet,
  garnishRequired: boolean
): boolean {
  if (!garnishRequired) return true;
  return (
    requirement.ideal.includes('None') ||
    requirement.acceptable.includes('None')
  );
}

export function getGarnishTipMultiplier(
  requirement: NameRequirementSet,
  garnishName: string,
  config: Pick<
    GameConfig,
    'tipMultiplierIdeal' | 'tipMultiplierAcceptable' | 'tipMultiplierWrong'
  >
): number {
  if (requirement.ideal.includes(garnishName)) return config.tipMultiplierIdeal;
  if (requirement.acceptable.includes(garnishName)) {
    return config.tipMultiplierAcceptable;
  }
  return config.tipMultiplierWrong;
}
