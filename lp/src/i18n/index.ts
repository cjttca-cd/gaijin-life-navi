import en from './en';
import zh from './zh';
import vi from './vi';
import ko from './ko';
import pt from './pt';

export type Locale = 'en' | 'zh' | 'vi' | 'ko' | 'pt';
export type Translations = typeof en;

const translations: Record<Locale, Translations> = { en, zh, vi, ko, pt };

export const locales: Locale[] = ['en', 'zh', 'vi', 'ko', 'pt'];

export const localeNames: Record<Locale, string> = {
  en: 'English',
  zh: '中文',
  vi: 'Tiếng Việt',
  ko: '한국어',
  pt: 'Português',
};

export function getTranslations(locale: Locale): Translations {
  return translations[locale] ?? translations.en;
}

export function getLocalePath(locale: Locale, path: string = '/'): string {
  if (locale === 'en') return path;
  return `/${locale}${path}`;
}
