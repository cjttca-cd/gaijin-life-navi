# Feature Handoff: Astro Landing Page (5 Languages, SEO Optimized)

**Epic**: e10-lp
**Feature**: astro-lp
**Task**: task-027
**Status**: ✅ Complete

---

## Intent

Build a production-ready, multi-language (5 locales) landing page for **Gaijin Life Navi** using Astro 5.x + Tailwind CSS 4.x. The LP targets foreign residents in Japan considering the app, and serves as the primary acquisition page.

## Non-goals

- No backend integration (pure SSG)
- No actual app store links (placeholder `#`)
- No real analytics tracking (placeholder comments only)
- No CMS integration (content is in TypeScript translation files)

## Architecture

```
lp/
├── astro.config.mjs          # Astro 5.x config: SSG, i18n (5 locales), Tailwind via Vite
├── package.json
├── tsconfig.json
├── public/
│   ├── favicon.svg            # Gradient globe icon
│   └── og-image.png           # 1200x630 OG image placeholder
├── src/
│   ├── styles/
│   │   └── global.css         # Tailwind 4 import + custom theme (primary/accent colors)
│   ├── i18n/
│   │   ├── index.ts           # Locale types, getTranslations(), getLocalePath()
│   │   ├── en.ts              # English (default)
│   │   ├── zh.ts              # Chinese (Simplified)
│   │   ├── vi.ts              # Vietnamese
│   │   ├── ko.ts              # Korean
│   │   └── pt.ts              # Portuguese (Brazilian)
│   ├── layouts/
│   │   └── Layout.astro       # Base HTML: SEO meta, OG tags, hreflang, analytics placeholder
│   ├── components/
│   │   ├── LandingPage.astro  # Page compositor (Layout + Header + Hero + Features + CTA + Footer)
│   │   ├── Header.astro       # Fixed nav: logo, features/download links, language selector, mobile menu
│   │   ├── Hero.astro         # Badge + headline + subtitle + App Store/Play Store CTAs + social proof
│   │   ├── Features.astro     # Section header + 3-column grid
│   │   ├── FeatureCard.astro  # Icon + title + description card (6 variants by icon key)
│   │   ├── CTA.astro          # Gradient CTA section with download buttons
│   │   └── Footer.astro       # Disclaimer banner + logo + privacy/terms links + copyright
│   └── pages/
│       ├── index.astro        # /  (English — default, no prefix)
│       ├── zh/index.astro     # /zh/
│       ├── vi/index.astro     # /vi/
│       ├── ko/index.astro     # /ko/
│       └── pt/index.astro     # /pt/
```

## SEO Implementation

- **Per-page**: `<title>`, `<meta name="description">`, `<link rel="canonical">`
- **Open Graph**: og:type, og:url, og:title, og:description, og:image (1200×630), og:locale
- **Twitter Card**: summary_large_image with title, description, image
- **Hreflang**: All 5 locales + x-default on every page
- **Structured**: lang attribute per locale (en, zh-Hans, vi, ko, pt-BR)

## i18n Strategy

- **Routing**: Astro built-in i18n with `prefixDefaultLocale: false` (en at `/`, others at `/{locale}/`)
- **Translations**: TypeScript objects per locale (fully typed via `Translations` type)
- **Locale names**: en→English, zh→中文, vi→Tiếng Việt, ko→한국어, pt→Português

## Design

- **Tailwind CSS 4.x** via `@tailwindcss/vite` plugin
- **Custom theme**: Primary (blue-indigo oklch), Accent (teal-green oklch)
- **Font**: Inter (Google Fonts, preconnected)
- **Responsive**: Mobile-first with sm/md/lg breakpoints
- **Mobile menu**: JS toggle with backdrop blur
- **Hover effects**: Cards lift + border highlight, buttons translate-y

## 6 Features Showcased

1. **AI Chat Assistant** — Instant multilingual Q&A about life in Japan
2. **Banking Guide** — Step-by-step account opening and transfers
3. **Visa Navigator** — Deadline tracking and renewal guidance
4. **Life Tracker** — Important dates (visa, tax, health, municipal)
5. **Document Scanner** — OCR + translate Japanese documents
6. **Medical Guide** — Find doctors, understand health insurance

## Deployment

- **Target**: Cloudflare Pages (per ARCHITECTURE.md)
- **Output**: `dist/` directory (5 HTML pages + assets)
- **Build**: `npm run build` → Astro SSG

## Verification

```bash
cd lp && npm run build
# ✅ Build success, 5 pages generated
# ✅ dist/index.html (en)
# ✅ dist/zh/index.html
# ✅ dist/vi/index.html
# ✅ dist/ko/index.html
# ✅ dist/pt/index.html
```

## Gaps / Future Work

- Replace `og-image.png` placeholder with designed OG image
- Add actual App Store / Play Store URLs when available
- Enable Google Analytics / Cloudflare Analytics (uncomment placeholders in Layout.astro)
- Add privacy policy and terms of service pages
- Consider adding a "How it works" section or testimonials
- Add structured data (JSON-LD) for enhanced search results
- Performance optimization: self-host Inter font for better LCP

## Next Steps

1. PM to review and approve
2. Deploy to Cloudflare Pages (staging)
3. Replace placeholder links/images with real assets
4. Enable analytics
