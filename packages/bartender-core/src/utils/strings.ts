const VOWELS = new Set(['a', 'e', 'i', 'o', 'u']);

/** Matches Swift `String.article` in CustomerOrderView.swift */
export function indefiniteArticle(phrase: string): 'a' | 'an' {
  const firstWord = phrase.trim().split(/\s+/)[0] ?? '';
  const firstChar = firstWord.toLowerCase().charAt(0);
  return VOWELS.has(firstChar) ? 'an' : 'a';
}

export function formatOrderPhrase(template: string, drinkName: string): string {
  const article = indefiniteArticle(drinkName);
  const formattedDrink = `${article} ${drinkName}`;
  return template.replace('%@', formattedDrink);
}

export function getCurrentDateString(date = new Date()): string {
  return date.toISOString().slice(0, 10);
}
