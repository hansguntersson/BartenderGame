import type { VenueRecord, VenueShiftDay } from '../types/catalog.js';

const WEEKDAY_ORDER = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
];

/** Port of Venue.openingHours(for:) */
export function openingHoursForDay(
  venue: VenueRecord,
  dayName: string
): string {
  const pattern = venue.shiftPattern.find((p) => p.day === dayName);
  if (!pattern) return 'Closed';
  if (pattern.start && pattern.end) {
    return `${pattern.start} - ${pattern.end}`;
  }
  return 'Closed';
}

/** Port of Venue.calculateShiftLength(from:) — times like 11AM, 1AM */
export function calculateShiftLengthHours(openingHours: string): number {
  const components = openingHours.replace(/\s/g, '').split('-');
  if (components.length !== 2) return 0;

  const parseHour = (token: string): number | null => {
    const match = token.match(/^(\d{1,2})(AM|PM)$/i);
    if (!match) return null;
    let hour = parseInt(match[1], 10);
    const meridiem = match[2].toUpperCase();
    if (meridiem === 'AM') {
      if (hour === 12) hour = 0;
    } else if (hour !== 12) {
      hour += 12;
    }
    return hour;
  };

  const startHour = parseHour(components[0]);
  let endHour = parseHour(components[1]);
  if (startHour === null || endHour === null) return 0;
  if (endHour <= startHour) endHour += 24;
  return endHour - startHour;
}

export function shiftLengthHoursForDay(
  venue: VenueRecord,
  dayName: string
): number {
  const pattern = venue.shiftPattern.find((p) => p.day === dayName);
  if (!pattern?.start || !pattern.end) return 0;
  return calculateShiftLengthHours(`${pattern.start} - ${pattern.end}`);
}

export function weekdayNameFromDate(date: Date): string {
  return WEEKDAY_ORDER[date.getDay()];
}

export function isVenueOpenOnDay(
  pattern: VenueShiftDay
): pattern is VenueShiftDay & { start: string; end: string } {
  return Boolean(pattern.start && pattern.end);
}
