import type { RandomSource } from '../types/catalog.js';

export const defaultRandom: RandomSource = {
  random: () => Math.random(),
  randomInt(min: number, max: number) {
    return Math.floor(this.random() * (max - min + 1)) + min;
  },
};

/** Deterministic RNG for tests */
export function createSeededRandom(seed: number): RandomSource {
  let state = seed >>> 0;
  return {
    random() {
      state = (state * 1664525 + 1013904223) >>> 0;
      return state / 0x100000000;
    },
    randomInt(min: number, max: number) {
      return Math.floor(this.random() * (max - min + 1)) + min;
    },
  };
}
