export function roundTo(value: number, places: number): number {
  const divisor = 10 ** places;
  return Math.round(value * divisor) / divisor;
}

export function randomInRange(
  min: number,
  max: number,
  random: () => number = Math.random
): number {
  return min + random() * (max - min);
}
